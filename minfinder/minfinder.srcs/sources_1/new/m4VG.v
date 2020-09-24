`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: My House Inc
// Engineer: 
// 
// Create Date: 01.09.2020 20:19:51
// Design Name: 
// Module Name: m4VG
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


module m4VG(
        output [4:0]min1,
        output [4:0]min2,
        output [1:0]q1q0,
        
        input [4:0]x0,
        input [4:0]x1,
        input [4:0]x2,
        input [4:0]x3
    );
    
    wire [4:0]m1A,m1B,m2A,m2B;
    wire cp1,cp2;
    
    m2VG m1(m1A,m1B,cp1,x0,x1);
    m2VG m2(m2A,m2B,cp2,x2,x3);
    

    assign min1 = m1A > m2A ?  m2A :m1A ;
    assign q1q0[1] = m1A > m2A ?  1 : 0;
    //assign min2 = q1q0[1] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;   
    assign min2 = m1A > m2A ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;   
    //assign q1q0[0] = q1q0[1] ? cp2 : cp1;
    assign q1q0[0] = m1A > m2A ? cp2 : cp1;
endmodule
