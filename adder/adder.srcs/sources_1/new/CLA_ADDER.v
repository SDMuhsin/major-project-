`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2020 12:55:16
// Design Name: 
// Module Name: CLA_ADDER
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


module CLA_ADDER(
        output carry_out,
        output [6:0]sum_out,
        input [6:0]a,
        input [6:0]b,
        input cin
    );
    
    assign g0 = a[0]&b[0];
    assign p0 = a[0]^b[0];
    assign c0 = g0|cin&p0;
    
    assign g1 = a[1]&b[1];
    assign p1 = a[1]^b[1];
    assign c1 = g1|c0&p1;
        
    assign g2 = a[2]&b[2];
    assign p2 = a[2]^b[2];
    assign c2 = g2|c1&p2;
    
    assign g3 = a[3]&b[3];
    assign p3 = a[3]^b[3];
    assign c3 = g3|c2&p3;
    
    assign g4 = a[4]&b[4];
    assign p4 = a[4]^b[4];
    assign c4 = g4|c3&p4;
        
    assign g5 = a[5]&b[5];
    assign p5 = a[5]^b[5];
    assign c5 = g5|c4&p5;    
    
    assign g6 = a[6]&b[6];
    assign p6 = a[6]^b[6];
    assign carry_cout = g6|c5&p6;
    
    assign sum_out[0] = p0^cin;
    assign sum_out[1] = p1^c0;
    assign sum_out[2] = p2^c1;
    assign sum_out[3] = p3^c2;
    assign sum_out[4] = p4^c3;
    assign sum_out[5] = p5^c4;
    assign sum_out[6] = p6^c5;
    
endmodule
