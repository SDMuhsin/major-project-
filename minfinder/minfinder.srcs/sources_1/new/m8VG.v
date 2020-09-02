`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2020 21:23:15
// Design Name: 
// Module Name: m8VG
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


module m8VG(
        output [4:0]min1,
        output [4:0]min2,
        output [2:0]q2q1q0,
        
        input [4:0]x0,
        input [4:0]x1,
        input [4:0]x2,
        input [4:0]x3,
        input [4:0]x4,
        input [4:0]x5,
        input [4:0]x6,
        input [4:0]x7
    );
    
    wire [1:0]m1_q1q0;
    wire [1:0]m2_q1q0;
    wire [4:0]m1A,m1B,m2A,m2B;
    
    m4VG m1(m1A,m1B,m1_q1q0,x0,x1,x2,x3);
    m4VG m2(m2A,m2B,m2_q1q0,x4,x5,x6,x7);
    
    assign min1 = m1A < m2A ? m1A : m2A;
    assign q2q1q0[2] = m1A < m2A ? 0 : 1;
    assign min2 = q2q1q0[2] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    assign q2q1q0[1:0] = q2q1q0[2] ? m2_q1q0 : m1_q1q0;
    
endmodule
