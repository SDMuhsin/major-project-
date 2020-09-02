`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2020 12:58:39
// Design Name: 
// Module Name: m18VG
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


module m18VG(
    output [4:0]min1,
    output [4:0]min2,
    output [4:0]q4q3q2q1q0,

    input [4:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
    );
    
    wire [3:0]m1_q3q2q1q0;
    wire m2_q0;
    wire [4:0]m1A,m1B,m2A,m2B;
    
    m16VG m1(m1A,m1B,m1_q3q2q1q0,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15);
    m2VG m2(m2A,m2B,m2_q0,x16,x17);
    
    assign min1 = m1A < m2A ? m1A : m2A;
    assign q4q3q2q1q0[4] = m1A < m2A ? 0 : 1;
    assign min2 = q4q3q2q1q0[4] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    assign q4q3q2q1q0[3:0] = q4q3q2q1q0[4] ? {1'b0,1'b0,1'b0,m2_q0} : m1_q3q2q1q0;   
endmodule
