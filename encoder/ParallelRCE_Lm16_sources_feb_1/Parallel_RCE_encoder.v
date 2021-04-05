`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2020 11:54:00
// Design Name: 
// Module Name: Parallel_RCE_encoder
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


module Parallel_RCE_encoder(p,msg,f,en,p_en,rst,clk,clk_in);//processing unit
parameter Lm=32;// number of message bit
parameter M=32 ;// size of circulant sub matrix of generator matrix
//output y;
output [M-1:0]p;
input [Lm-1:0]msg; 
//input[1:0]m_en;
input [M-1:0]f;
input en,p_en;                 
input rst,clk,clk_in;
wire [M-1:0]f;      //input [M-1:0]f;//now save in luts
wire clk_in,en;
//wire [1:0]adrs;
//wire [Lm:1]q2,q3;
wire [M-1:0]p11; 
//D_flip_flop DUT6(in1,msg,rst,clk_in);
//defparam DUT1.M=M,DUT1.Lm=Lm;
//SPI DUT1(y1,q3,en,in1,rst,clk_in,clk); // adding two clock
//fsm DUT0(adrs,p_en,1'b1,rst,clk_in);
//defparam DUT3.M=M;
//Function_generator DUT3(f,m_en,rst);
defparam DUT4.M=M,DUT4.Lm=Lm;
Parity_generation_unit DUT4(p11,msg,f,rst,clk_in);
defparam DUT7.M=M;
Parity_final_M DUT7(p,p11,~p_en,rst,clk_in); //not needed if Lm
//defparam DUT8.M=M;
//FSM_tx DUT8(t_en,en,rst,clk); // fsm for tx_mux
//transmitter_mux DUT5(y,y1,p,t_en);
endmodule
