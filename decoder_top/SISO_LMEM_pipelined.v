`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2021 14:57:37
// Design Name: 
// Module Name: SISO_rowunit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SISO_rowunit_pipe(
updLLR_regout,
Dout_regout, 
wrlayer,wraddress,wren, 
Dmem_rden_layer_address, 
rdlayer_regin,rdaddress_regin,rden_LLR_regin,rden_E_regin, 
Lmemout_regin,
D_reaccess_in_regin,
clk,rst
    );
    
    parameter Nb=16;
    parameter Wc=32;
    parameter Wcbits = 5;//2**5 =32
    parameter W=6;
    parameter LAYERS=2;
    parameter ADDRWIDTH = 5;//2^5 = 32 > 20
    parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
    parameter PIPESTAGES=13;
    
    output reg [(Wc*(W))-1:0] updLLR_regout;
    output reg [(Wc*(W))-1:0] Dout_regout;
    output [(ADDRWIDTH+1+1)-1:0] Dmem_rden_layer_address;
    output reg wrlayer;
    output reg [ADDRWIDTH-1:0]wraddress;
    output reg wren;
    input rdlayer_regin;
    input [ADDRWIDTH-1:0]rdaddress_regin;
    input rden_LLR_regin;
    input rden_E_regin;
    input [(Wc*(W))-1:0] Lmemout_regin;
    input [(Wc*(W))-1:0] D_reaccess_in_regin;
    
    input clk, rst;  
    
    wire wrlayer_wire;
    wire [ADDRWIDTH-1:0]wraddress_wire;
    wire wren_wire;
    wire wr_E, rd_E;
    wire[(ADDRWIDTH+1)-1:0] E_RA;
    reg[(ADDRWIDTH+1)-1:0] E_RA_reg[1:0];
    reg rd_E_reg[1:0];
    wire[(ADDRWIDTH+1)-1:0] E_WA;
    wire[ECOMPSIZE-1:0] Ecomp_wr_datain;
    wire[ECOMPSIZE-1:0] Emem_rd_dataout;
    reg [ECOMPSIZE-1:0] Emem_rd_dataout_reg;
    reg[ECOMPSIZE-1:0] Ecomp_in;
    wire forwarded_rcu_en;
    
    reg [(ADDRWIDTH+1+1)-1:0]wren_layer_address_reg[PIPESTAGES-1:0];

    wire[(Wc*W)-1:0] D_out;
    wire[(Wc*W)-1:0] updLLR_out;
    wire [W*Wc-1:0] REC_2_OUT;
    wire [Wc*W-1:0]SUB_OUT;
    reg [Wc*W-1:0]SUB_OUT_REG [6:0];
    reg [Wc*W-1:0] REC_1_OUT_REG [8:0];
    wire [W*Wc-1:0]REC_1_OUT;
    wire [ECOMPSIZE-1:0]E_COMP;
    
    //input-output
    //Regd outputs
    assign {wren_wire,wrlayer_wire,wraddress_wire} = wren_layer_address_reg[10];
    //assign {wren,wrlayer,wraddress} = wren_layer_address_reg[PIPESTAGES-2];
        
    always@(posedge clk)
    begin
        if(!rst)
      begin
        wren<=0;
        wrlayer<=0;
        wraddress<=0;
        updLLR_regout<=0;
        //Dout_regout<=0;
      end
      else
      begin
      wren<=wren_wire;
      wrlayer<=wrlayer_wire;
      wraddress<=wraddress_wire;
      if(forwarded_rcu_en) begin
        updLLR_regout<=updLLR_out;
        //Dout_regout<=D_out;
        end
        else begin
        updLLR_regout<=0;
        //Dout_regout<=0;
        end
      end
    end
    
    //assign updLLR_regout=forwarded_rcu_en?updLLR_out:0;
    //assign Dout_regout=forwarded_rcu_en?D_out:0;
    
    //regd inputs 
    reg rdlayer;
    reg [ADDRWIDTH-1:0]rdaddress;
    reg rden_LLR;
    reg rden_E;
    reg [(Wc*(W))-1:0] Lmemout, Lmemreg[1:0];
    reg [(Wc*(W))-1:0] D_reaccess_in;
    always@(posedge clk)
    begin
      if(!rst)
      begin
        D_reaccess_in<=0;
        Lmemout<=0;
        rdlayer<=0;
        rdaddress<=0;
        rden_LLR<=0;
        rden_E<=0;
      end
      else
      begin
        D_reaccess_in<=D_reaccess_in_regin;
        Lmemout<=Lmemout_regin;
        rdlayer<=rdlayer_regin;
        rdaddress<=rdaddress_regin;
        rden_LLR<=rden_LLR_regin;
        rden_E<=rden_E_regin;
      end
    end
    
    //---------------------------------//
    //Address Queue
    always@(posedge clk)
    begin
      if(!rst)
      begin
        wren_layer_address_reg[0]<=0;
      end
      else
      begin
        wren_layer_address_reg[0]<={rden_LLR,rdlayer,rdaddress};
      end
    end
    
    //Queue to forward address and memory enable signals
    genvar stageidx;
    generate for(stageidx=0;stageidx<=PIPESTAGES-2;stageidx=stageidx+1) begin: stageidx_addrQ_loop
      always@(posedge clk)
      begin
        if(!rst)
        begin
          wren_layer_address_reg[stageidx+1]<=0;
        end
        else
        begin
          wren_layer_address_reg[stageidx+1]<=wren_layer_address_reg[stageidx];
        end
      end
    end//stageidx_addrQ_loop
    endgenerate
    //--------------------------------------//
      
    assign {rd_E,E_RA} = {rden_E,rdlayer,rdaddress};
    assign {wr_E,E_WA} = wren_layer_address_reg[8];
    assign Ecomp_wr_datain = E_COMP;
    
   /*always@(posedge clk)
    begin
      if(!rst)
      begin
        rd_E_reg[0]<=0;
        rd_E_reg[1]<=0;
        E_RA_reg[0]<=0;
        E_RA_reg[1]<=0;
      end
      else
      begin
        rd_E_reg[0]<=rd_E;
        rd_E_reg[1]<=rd_E_reg[0];
        E_RA_reg[0]<=E_RA;
        E_RA_reg[1]<=E_RA_reg[0];
      end
    end*/
    
    defparam e_memory.DEPTH=ADDRDEPTH*LAYERS, e_memory.ADDRWIDTH=ADDRWIDTH+1;
    defparam e_memory.ECOMPSIZE=ECOMPSIZE;
    //assign Emem_rd_dataout=0;
    E_mem_ne_bram e_memory(Emem_rd_dataout, Ecomp_wr_datain, E_WA, E_RA, wr_E, rd_E, clk, rst);

    always@(posedge clk)
    begin
      if(!rst)
      begin
        Emem_rd_dataout_reg<=0;
        //Lmemreg[1]<=0;
      end
      else
      begin
        Emem_rd_dataout_reg<=Emem_rd_dataout;
        //Lmemreg[1]<=Lmemreg[0];
      end
    end
    
    //synchronising stages
    always@(posedge clk) begin
    
    if(!rst) begin
    SUB_OUT_REG[0]<=0;
    SUB_OUT_REG[1]<=0;
    SUB_OUT_REG[2]<=0;
    SUB_OUT_REG[3]<=0;
    SUB_OUT_REG[4]<=0;
    SUB_OUT_REG[5]<=0;
    SUB_OUT_REG[6]<=0;
    
    end
    else begin
    SUB_OUT_REG[0]<=SUB_OUT;
    SUB_OUT_REG[1]<=SUB_OUT_REG[0];
    SUB_OUT_REG[2]<=SUB_OUT_REG[1];
    SUB_OUT_REG[3]<=SUB_OUT_REG[2];
    SUB_OUT_REG[4]<=SUB_OUT_REG[3];
    SUB_OUT_REG[5]<=SUB_OUT_REG[4];
    SUB_OUT_REG[6]<=SUB_OUT_REG[5];    
    
    end    
    end   
    
    always@(posedge clk) begin
    
    if(!rst) begin
    REC_1_OUT_REG[0] <= 0;
    REC_1_OUT_REG[1] <= 0;
    REC_1_OUT_REG[2] <= 0;
    REC_1_OUT_REG[3] <= 0;
    REC_1_OUT_REG[4] <= 0;
    REC_1_OUT_REG[5] <= 0;
    REC_1_OUT_REG[6] <= 0;
    REC_1_OUT_REG[7] <= 0;
    REC_1_OUT_REG[8] <= 0;
    
    end
    
    else begin
    REC_1_OUT_REG[0] <= REC_1_OUT;
    REC_1_OUT_REG[1] <= REC_1_OUT_REG[0];
    REC_1_OUT_REG[2] <= REC_1_OUT_REG[1];
    REC_1_OUT_REG[3] <= REC_1_OUT_REG[2];
    REC_1_OUT_REG[4] <= REC_1_OUT_REG[3];
    REC_1_OUT_REG[5] <= REC_1_OUT_REG[4];
    REC_1_OUT_REG[6] <= REC_1_OUT_REG[5];
    REC_1_OUT_REG[7] <= REC_1_OUT_REG[6];
    REC_1_OUT_REG[8] <= REC_1_OUT_REG[7];
    
    end    
    end    
        
    reg [Wc*W-1:0]REC_2_OUT_REG;
    
    always@(posedge clk) begin
    
    if(!rst) begin
    REC_2_OUT_REG <= 0;
    end
    
    else begin
    REC_2_OUT_REG <= REC_2_OUT;
    
    end    
    end  
    
    //Recover unit
      //recovunit_ne rec1(REC_1_OUT,Ecomp_in);
      defparam rec1.Wc=Wc, rec1.W=W;
      recovunit_ne rec1(REC_1_OUT,Emem_rd_dataout_reg);
    
      //To subtractor      
      //subtractor_32 s1(SUB_OUT ,Lmemreg[1],REC_1_OUT,clk,rst);
      defparam s1.Wc=Wc, s1.W=W;
    subtractor_32 s1(SUB_OUT ,Lmemout,REC_1_OUT_REG[0],clk,rst);
            
      //Emsggen
      defparam absmin.wc=Wc, absmin.w=W;
      emsggen absmin(E_COMP, SUB_OUT, clk, rst);
      assign Dmem_rden_layer_address = wren_layer_address_reg[7];
      
      //recover unit
      defparam rec2.Wc=Wc, rec2.W=W;
      recovunit_ne rec2(REC_2_OUT,E_COMP);
      
      //subtractor for D calculation
      defparam sub2.Wc=Wc, sub2.W=W;
    subtractor_32_d sub2(Dout_regout,REC_2_OUT_REG,REC_1_OUT_REG[8],clk,rst); 
      
      //adder
      defparam add1.Wc=Wc, add1.W=W;
    AdderWc add1(updLLR_out,SUB_OUT_REG[6],REC_2_OUT_REG,D_reaccess_in,clk,rst);  
      
      assign forwarded_rcu_en=wren_layer_address_reg[11][ADDRWIDTH+1];
            

endmodule
