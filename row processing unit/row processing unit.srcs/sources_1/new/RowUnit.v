`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2020 16:32:03
// Design Name: 
// Module Name: RowUnit
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


module RowUnit(
       LLR_OUT,
       E_MEM_OUT,
       //ABS_SIGN_OUT, // Stage III OUT
       //ABS_MAG_OUT, //Stage III OUT
       E_MEM_IN,
       LLR_IN,
       clk,
       rst 
    );
    
 parameter Wc=18;
 parameter Wcbits = 5;
 parameter W=6;   
 parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
 
 input clk;
 input rst;
 
 output [Wc*W-1:0]LLR_OUT;
 input [Wc*W-1:0]LLR_IN;
 input [ECOMPSIZE-1:0]E_MEM_IN;
 output [ECOMPSIZE-1:0]E_MEM_OUT;
 
 //STAGE III BEGIN
 //Recover
 wire [W*Wc-1:0]REC_1_OUT;
 recovunit_ne rec1(REC_1_OUT,E_MEM_IN);
 
 //To subtractor
 wire [Wc*W-1:0]SUB_OUT;
 reg [Wc*W-1:0]SUB_OUT_1,SUB_OUT_2,SUB_OUT_3,SUB_OUT_4,SUB_OUT_5;
 subtractor_18 s1( SUB_OUT ,LLR_IN,REC_1_OUT);

 always@(posedge clk)begin
    if(rst)begin
        SUB_OUT_1 <= 0;
        SUB_OUT_2 <= 0;
        SUB_OUT_3 <= 0;
        SUB_OUT_4 <= 0;
        SUB_OUT_5 <= 0;
    end
    else begin
        SUB_OUT_1 <= SUB_OUT;
        SUB_OUT_2 <= SUB_OUT_1;
        SUB_OUT_3 <= SUB_OUT_2;
        SUB_OUT_4 <= SUB_OUT_3;
        SUB_OUT_5 <= SUB_OUT_4;  
    end
 end
 //To Absoluter...
 //output [Wc-1:0]ABS_SIGN_OUT;
// output [Wc*(W-1)-1:0]ABS_MAG_OUT;

 
 //STAGE IV ...
 // ABSOLUTER + MINFINDER + ECOMP GEN
 wire [ECOMPSIZE-1:0]E_COMP;
 emsggen absmin(E_COMP, SUB_OUT, clk, rst);
 //STAGE III END, STAGE IV END
 
 //STAGE V
 //recover
 wire [W*Wc-1:0]REC_2_OUT;
 recovunit_ne rec2(REC_2_OUT,E_COMP);
  
 //adder
 AdderWc add1(LLR_OUT,SUB_OUT_5,REC_2_OUT);
 assign E_MEM_OUT = E_COMP;
  
endmodule
