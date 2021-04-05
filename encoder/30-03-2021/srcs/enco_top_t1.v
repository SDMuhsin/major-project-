`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2021 22:52:27
// Design Name: 
// Module Name: enco_top_t1
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


module enco_top_t1(

    );
    parameter Lm=2;// number of message bit
    parameter M=5; 
    reg clk,rst;
    wire [M-1:0]u_reg;
//output u0,u1,u2,u3,u4;
    reg [Lm-1:0]msg_inp;
    reg [M-1:0]f_inp;//
    reg ce;
    wire [M-1:0]parityout;
    Parity_generation_unit_chaintree d1(u_reg,msg_inp,f_inp,rst,clk);
    parityshift2 d2(parityout,u_reg,ce,clk,rst);
endmodule
