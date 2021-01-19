`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2021 11:19:38
// Design Name: 
// Module Name: SISO_RowUnit_tb
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


module SISO_RowUnit_tb(

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
    parameter PIPESTAGES=10;
    
    wire [(Wc*(W))-1:0] updLLR_regout;
    wire [(Wc*(W))-1:0] Dout_regout;
    wire [(ADDRWIDTH+1+1)-1:0] Dmem_rden_layer_address;
    wire wrlayer;
    wire [ADDRWIDTH-1:0]wraddress;
    wire wren;
    reg rdlayer_regin;
    reg [ADDRWIDTH-1:0]rdaddress_regin;
    reg rden_LLR_regin;
    reg rden_E_regin;
    reg [(Wc*(W))-1:0] Lmemout_regin;
    reg [(Wc*(W))-1:0] D_reaccess_in_regin;
    
    reg clk, rst; 
    
    //output [Wc*W-1:0]LLR_OUT;
    //reg [Wc*W-1:0]LLR_IN;
    //reg [ECOMPSIZE-1:0]E_MEM_IN;
    //reg clk,rst;
    
    //wire [Wc*W-1:0]LLR_OUT;
    //wire [ECOMPSIZE-1:0]E_MEM_OUT;
    
    //wire [Wc-1:0]SIGN;
    //wire [Wc*(W-1)-1:0]ABS;
    
    //wire [W-2:0]ABS_DISPLAY[Wc-1:0];
    wire [W-1:0]LLR_IN_DISPLAY[Wc-1:0];
    wire [W-1:0]LLR_OUT_DISPLAY[Wc-1:0];
    wire [W-1:0]D_IN_DISPLAY[Wc-1:0];
    wire [W-1:0]D_OUT_DISPLAY[Wc-1:0];
    wire [(ADDRWIDTH+1+1)-1:0] Dmem_rden_layer_address_display;
    wire wrlayer_display;
    wire [ADDRWIDTH-1:0]wraddress_display;
    wire wren_display;
    wire rdlayer_regin_display;
    wire [ADDRWIDTH-1:0]rdaddress_regin_display;
    wire rden_LLR_regin_display;
    wire rden_E_regin_display;
    
    /*wire [W-2:0]ECOMP_IN_MIN1_DISPLAY;
    wire [W-2:0]ECOMP_IN_MIN2_DISPLAY;
    wire [4:0]ECOMP_IN_INDEX_DISPLAY; // 5 bit
    wire [Wc-1:0]ECOMP_IN_SIGNS_IN_DISPLAY;
        
    wire [W-2:0]ECOMP_OUT_MIN1_DISPLAY;
    wire [W-2:0]ECOMP_OUT_MIN2_DISPLAY;
    wire [4:0]ECOMP_OUT_INDEX_DISPLAY; // 5 bit
    wire [Wc-1:0]ECOMP_OUT_SIGNS_IN_DISPLAY;*/
    
    wire [(ADDRWIDTH+1+1)-1:0]wren_layer_address_reg_display[PIPESTAGES-1:0];
   
    
    genvar i;
    generate for(i=0;i<Wc;i=i+1)begin:l1
        assign LLR_IN_DISPLAY[i][W-1:0] = Lmemout_regin[(i+1)*W-1:i*W];
        assign LLR_OUT_DISPLAY[i][W-1:0] = updLLR_regout[(i+1)*W-1:i*W];
        assign D_IN_DISPLAY[i][W-1:0] = D_reaccess_in_regin[(i+1)*W-1:i*W];
        assign D_OUT_DISPLAY[i][W-1:0] = Dout_regout[(i+1)*W-1:i*W];
        //assign ABS_DISPLAY[i][W-2:0] = ABS[(i+1)*(W-1)-1:i*(W-1)];
    end
    endgenerate
    
    SISO_rowunit ru(updLLR_regout, Dout_regout, wrlayer,wraddress,wren, Dmem_rden_layer_address, rdlayer_regin,rdaddress_regin,rden_LLR_regin,rden_E_regin, Lmemout_regin,
    D_reaccess_in_regin, clk,rst);
    
    /*genvar j;
    generate for(j=0;j<PIPESTAGES;j=j+1) begin:l2
        assign wren_layer_address_reg_display[j][ADDRWIDTH+1:0] = ru.wren_layer_address_reg[j][ADDRWIDTH+1:0];
        end
        endgenerate*/

    
    integer k;
    initial begin
    
        Lmemout_regin[5:0] = 6'b000011;
        Lmemout_regin[11:6] = 6'b000011;
        Lmemout_regin[17:12] = 6'b000011;
        Lmemout_regin[23:18] = 6'b000011;
        Lmemout_regin[29:24] = 6'b00010;
        Lmemout_regin[35:30] = 6'b000011;
        Lmemout_regin[41:36] = 6'b000011;
        Lmemout_regin[47:42] = 6'b000011;
        Lmemout_regin[53:48] = 6'b000011;
        Lmemout_regin[59:54] = 6'b000011;
        Lmemout_regin[65:60] = 6'b000011;
        Lmemout_regin[71:66] = 6'b000011;
        Lmemout_regin[77:72] = 6'b000011;
        Lmemout_regin[83:78] = 6'b000011;
        Lmemout_regin[89:84] = 6'b000011;
        Lmemout_regin[95:90] = 6'b000100;
        Lmemout_regin[101:96] = 6'b000100;
        Lmemout_regin[107:102] = 6'b000100;
        Lmemout_regin[113:108] = 6'b000011;
        Lmemout_regin[119:114] = 6'b000011;
        Lmemout_regin[125:120] = 6'b000011;
        Lmemout_regin[131:126] = 6'b000011;
        Lmemout_regin[137:132] = 6'b000011;
        Lmemout_regin[143:138] = 6'b000100;
        Lmemout_regin[149:144] = 6'b000100;
        Lmemout_regin[155:150] = 6'b000100;
        Lmemout_regin[161:156] = 6'b000100;
        Lmemout_regin[167:162] = 6'b000100;
        Lmemout_regin[173:168] = 6'b000100;
        Lmemout_regin[179:174] = 6'b000100;
        Lmemout_regin[185:180] = 6'b000100;
        Lmemout_regin[191:186] = 6'b000100;
        D_reaccess_in_regin = 0;
        
        clk = 0;
        rst = 0;
        
        rdlayer_regin = 0;
        rdaddress_regin = 5'b00110;
        rden_LLR_regin = 1'b1;
        rden_E_regin = 1'b1;
        
        /*LLR_IN = 0;
        E_MEM_IN = 0;
        
        clk = 0;
        rst = 0;
        
        
        LLR_IN[5:0] = 31;
        LLR_IN[11:6] = 30;
        LLR_IN[17:12] = 29;
        LLR_IN[25:18] = 28;
        LLR_IN[31:24] = 27;
        LLR_IN[37:30] = 26;
        LLR_IN[43:36] = 25;
        LLR_IN[49:42] = 24;
        LLR_IN[55:48] = 23;
        LLR_IN[61:54] = 22;
        LLR_IN[67:60] = 21;
        LLR_IN[73:66] = 20;
        LLR_IN[79:72] = 19;
        LLR_IN[83:78] = 18;
        LLR_IN[89:84] = 17;
        LLR_IN[95:90] = 16;
        LLR_IN[101:96] = 15;
        LLR_IN[107:102] = 14;*/

    end
    always #5 clk = ~clk;
    
    always@(posedge clk)
    begin
    if(Dmem_rden_layer_address[ADDRWIDTH+1]==1)
    D_reaccess_in_regin=1;
    end
    
    /*always @(negedge clk)begin
        #1;
        //LLR_IN = LLR_IN + 3'b101;
        Lmemout_regin = Lmemout_regin + 3'b101;   
        //#0.1;
        //LLR_IN[Wc*W-1:Wc*W-1-5*W] = LLR_IN[Wc*W-1:Wc*W-1- 5*W] + $random; 
        //#0.1;
        //LLR_IN[6*W:4*W] = LLR_IN[ 6*W: 4*W] + 64'b11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111;
        //#0.1;
        //LLR_IN = LLR_IN + 64'b11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111;
    end */
    
    //wire [Wc*W-1:0]SUB_OUT = RowUnit.SUB_OUT;
    
    //assign {ECOMP_IN_MIN1_DISPLAY,ECOMP_IN_MIN2_DISPLAY,ECOMP_IN_INDEX_DISPLAY,ECOMP_IN_SIGNS_IN_DISPLAY} = ru.Emem_rd_dataout;
    //assign {ECOMP_OUT_MIN1_DISPLAY,ECOMP_OUT_MIN2_DISPLAY,ECOMP_OUT_INDEX_DISPLAY,ECOMP_OUT_SIGNS_IN_DISPLAY} = ru.E_COMP;
    
    assign Dmem_rden_layer_address_display=Dmem_rden_layer_address;
    assign wrlayer_display=wrlayer;
    assign wraddress_display=wraddress;
    assign wren_display=wren;
    assign rdlayer_regin_display=rdlayer_regin;
    assign rdaddress_regin_display=rdaddress_regin;
    assign rden_LLR_regin_display=rden_LLR_regin;
    assign rden_E_regin_display=rden_E_regin;
    
endmodule