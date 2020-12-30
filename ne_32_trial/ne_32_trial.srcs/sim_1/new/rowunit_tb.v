`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2020 16:58:52
// Design Name: 
// Module Name: RowUnitStageIII_tb
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


module RowUnit_tb(

    );
    
    parameter Wc=18;
    parameter Wcbits = 5;
    parameter W=6;   
    parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
    
    //output [Wc*W-1:0]LLR_OUT;
    reg [Wc*W-1:0]LLR_IN;
    reg [ECOMPSIZE-1:0]E_MEM_IN;
    reg clk,rst;
    
    wire [Wc*W-1:0]LLR_OUT;
    wire [ECOMPSIZE-1:0]E_MEM_OUT;
    
    //wire [Wc-1:0]SIGN;
    //wire [Wc*(W-1)-1:0]ABS;
    
    //wire [W-2:0]ABS_DISPLAY[Wc-1:0];
    wire [W-1:0]LLR_IN_DISPLAY[Wc-1:0];
    wire [W-1:0]LLR_OUT_DISPLAY[Wc-1:0];
    
    wire [W-2:0]ECOMP_IN_MIN1_DISPLAY;
    wire [W-2:0]ECOMP_IN_MIN2_DISPLAY;
    wire [4:0]ECOMP_IN_INDEX_DISPLAY; // 5 bit
    wire [Wc-1:0]ECOMP_IN_SIGNS_IN_DISPLAY;
        
    wire [W-2:0]ECOMP_OUT_MIN1_DISPLAY;
    wire [W-2:0]ECOMP_OUT_MIN2_DISPLAY;
    wire [4:0]ECOMP_OUT_INDEX_DISPLAY; // 5 bit
    wire [Wc-1:0]ECOMP_OUT_SIGNS_IN_DISPLAY;
    
    assign {ECOMP_IN_MIN1_DISPLAY,ECOMP_IN_MIN2_DISPLAY,ECOMP_IN_INDEX_DISPLAY,ECOMP_IN_SIGNS_IN_DISPLAY} = E_MEM_IN;
    assign {ECOMP_OUT_MIN1_DISPLAY,ECOMP_OUT_MIN2_DISPLAY,ECOMP_OUT_INDEX_DISPLAY,ECOMP_OUT_SIGNS_IN_DISPLAY} = E_MEM_OUT;
    
    genvar i;
    generate for(i=0;i<Wc;i=i+1)begin:l1
        assign LLR_IN_DISPLAY[i][W-1:0] = LLR_IN[(i+1)*W-1:i*W];
        assign LLR_OUT_DISPLAY[i][W-1:0] = LLR_OUT[(i+1)*W-1:i*W];
        //assign ABS_DISPLAY[i][W-2:0] = ABS[(i+1)*(W-1)-1:i*(W-1)];
    end
    endgenerate
    
    RowUnit ru(LLR_OUT,E_MEM_OUT,E_MEM_IN,LLR_IN,clk,rst);
    
    integer k;
    initial begin
        LLR_IN = 0;
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
        LLR_IN[107:102] = 14;

    end
    always #5 clk = ~clk;
    
    always @(negedge clk)begin
        #1;
        LLR_IN = LLR_IN + 3'b101;   
        //#0.1;
        //LLR_IN[Wc*W-1:Wc*W-1-5*W] = LLR_IN[Wc*W-1:Wc*W-1- 5*W] + $random; 
        //#0.1;
        //LLR_IN[6*W:4*W] = LLR_IN[ 6*W: 4*W] + 64'b11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111;
        //#0.1;
        //LLR_IN = LLR_IN + 64'b11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111;
    end 
    
    //wire [Wc*W-1:0]SUB_OUT = RowUnit.SUB_OUT;
    wire [Wc*W-1:0]SUB_OUT_5 = RowUnit.SUB_OUT_5;
endmodule