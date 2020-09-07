`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2020 22:00:49
// Design Name: 
// Module Name: m16VG
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


module m16VG(
    output [4:0]min1,
    output [4:0]min2,
    output [3:0]q3q2q1q0,
    
    input [4:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15
    );

    wire [2:0]m1_q2q1q0;
    wire [2:0]m2_q2q1q0;
    wire [4:0]m1A,m1B,m2A,m2B;
    
    m8VG m1(m1A,m1B,m1_q2q1q0,x0,x1,x2,x3,x4,x5,x6,x7);
    m8VG m2(m2A,m2B,m2_q2q1q0,x8,x9,x10,x11,x12,x13,x14,x15);

    assign min1 = m1A < m2A ? m1A : m2A;
    assign q3q2q1q0[3] = m1A < m2A ? 0 : 1;
    assign min2 = m1A < m2A ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    //assign min2 = q3q2q1q0[3] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    assign q3q2q1q0[2:0] = m1A < m2A ? m2_q2q1q0 : m1_q2q1q0;    
    //assign q3q2q1q0[2:0] = q3q2q1q0[3] ? m2_q2q1q0 : m1_q2q1q0;    
endmodule
