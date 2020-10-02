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


module RowUnitStageIII_tb(

    );
    
    parameter Wc=18;
    parameter Wcbits = 5;
    parameter W=6;   
    parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
    
    //output [Wc*W-1:0]LLR_OUT;
    reg [Wc*W-1:0]LLR_IN;
    reg [ECOMPSIZE-1:0]E_MEM_IN;
    
    wire [Wc-1:0]SIGN;
    wire [Wc*(W-1)-1:0]ABS;
    
    wire [W-2:0]ABS_DISPLAY[Wc-1:0];
    wire [W-1:0]LLR_IN_DISPLAY[Wc-1:0];
    
    wire [W-2:0]MIN1_DISPLAY;
    wire [W-2:0]MIN2_DISPLAY;
    wire [4:0]INDEX_DISPLAY; // 5 bit
    wire [Wc-1:0]SIGNS_IN_DISPLAY;
    
    assign {MIN1_DISPLAY,MIN2_DISPLAY,INDEX_DISPLAY,SIGNS_IN_DISPLAY} = E_MEM_IN;
    
   genvar i;
   generate for(i=0;i<Wc;i=i+1)begin:l1
        assign LLR_IN_DISPLAY[i][W-1:0] = LLR_IN[(i+1)*W-1:i*W];
        assign ABS_DISPLAY[i][W-2:0] = ABS[(i+1)*(W-1)-1:i*(W-1)];
   end
   endgenerate
    
    //Internal signals
    wire [Wc*W-1:0]SUB_OUT;
    wire [Wc*W-1:0]REC_1_OUT;
    
    RowUnit r(SIGN,ABS,E_MEM_IN,LLR_IN);
    
    assign SUB_OUT = r.SUB_OUT2;
    assign REC_1_OUT = r.REC_1_OUT;
    initial begin
        LLR_IN = 0;
        E_MEM_IN = 0;
    end
endmodule
