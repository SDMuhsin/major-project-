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


module SISO_rowunit(
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
    parameter PIPESTAGES=11;
    
    output reg[(Wc*(W))-1:0] updLLR_regout;
    output reg[(Wc*(W))-1:0] Dout_regout;
    output [(ADDRWIDTH+1+1)-1:0] Dmem_rden_layer_address;
    output wrlayer;
    output [ADDRWIDTH-1:0]wraddress;
    output wren;
    input rdlayer_regin;
    input [ADDRWIDTH-1:0]rdaddress_regin;
    input rden_LLR_regin;
    input rden_E_regin;
    input [(Wc*(W))-1:0] Lmemout_regin;
    input [(Wc*(W))-1:0] D_reaccess_in_regin;
    
    input clk, rst;  
    
    wire wr_E, rd_E;
    wire[(ADDRWIDTH+1)-1:0] E_RA;
    wire[(ADDRWIDTH+1)-1:0] E_WA;
    wire[ECOMPSIZE-1:0] Ecomp_wr_datain;
    wire[ECOMPSIZE-1:0] Emem_rd_dataout;
    reg[ECOMPSIZE-1:0] Ecomp_in;
    
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
    assign {wren,wrlayer,wraddress} = wren_layer_address_reg[PIPESTAGES-1];
    
    always@(posedge clk)
    begin
      if(!rst)
      begin
        updLLR_regout<=0;
        Dout_regout<=0;
      end
      else
      begin
        updLLR_regout<=updLLR_out;
        Dout_regout<=D_out;
      end
    end
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
    
    always@(posedge clk)
    begin
      if(!rst)
      begin
        Lmemreg[0]<=0;
      end
      else
      begin
        Lmemreg[0]<=Lmemout;
      end
    end
    
    assign {rd_E,E_RA} = {rden_E,rdlayer,rdaddress};
    assign {wr_E,E_WA} = wren_layer_address_reg[8];
    assign Ecomp_wr_datain = REC_2_OUT;
    
    defparam e_memory.DEPTH=ADDRDEPTH*LAYERS, e_memory.ADDRWIDTH=ADDRWIDTH+1;
    defparam e_memory.ECOMPSIZE=ECOMPSIZE;
    
    E_mem_ne_bram e_memory(Emem_rd_dataout, Ecomp_wr_datain, E_WA, E_RA, wr_E, rd_E, clk, rst);

    /*always@(posedge clk)
    begin
      if(!rst)
      begin
        Ecomp_in<=0;
        Lmemreg[1]<=0;
      end
      else
      begin
        Ecomp_in<=Emem_rd_dataout;
        Lmemreg[1]<=Lmemreg[0];
      end
    end*/
    
    //synchronising stages
    always@(posedge clk) begin
    
    if(rst) begin
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
    
    if(rst) begin
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
    
      //Recover unit
      //recovunit_ne rec1(REC_1_OUT,Ecomp_in);
      recovunit_ne rec1(REC_1_OUT,Emem_rd_dataout);
    
      //To subtractor      
      //subtractor_32 s1(SUB_OUT ,Lmemreg[1],REC_1_OUT,clk,rst);
      subtractor_32 s1(SUB_OUT ,Lmemreg[0],REC_1_OUT,clk,rst);
            
      //Emsggen
      emsggen absmin(E_COMP, SUB_OUT, clk, rst);
      assign Dmem_rden_layer_address = wren_layer_address_reg[7];
      
      //recover unit
      recovunit_ne rec2(REC_2_OUT,E_COMP);
      
      //subtractor for D calculation
      subtractor_32_d sub2(D_out,REC_2_OUT,REC_1_OUT_REG[8],clk,rst); 
      
      //adder
      AdderWc add1(updLLR_out,SUB_OUT_REG[6],REC_2_OUT,D_reaccess_in,clk,rst);      
      
endmodule
