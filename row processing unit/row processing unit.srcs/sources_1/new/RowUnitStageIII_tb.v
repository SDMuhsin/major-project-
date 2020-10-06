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
        
        
        for(k=0;k<Wc;k=k+1)begin:lab
            LLR_IN[Wc*W-1-W*(k+1)+1] = 1'b1;
        end
    end
    always #5 clk = ~clk;
    
    always @(negedge clk)begin
        #1;
        LLR_IN = LLR_IN + $random;   
    end 
    
    wire [Wc*W-1:0]SUB_OUT = RowUnit.SUB_OUT;
    wire [Wc*W-1:0]SUB_OUT_5 = RowUnit.SUB_OUT_5;
endmodule
