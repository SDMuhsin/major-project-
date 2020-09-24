`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2020 19:45:24
// Design Name: 
// Module Name: m18VG_pipelined_tb
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


module m18VG_pipelined_tb(

    );
    wire [4:0]min1,min2;
    wire [4:0]q4q3q2q1q0;
    
    reg clk,rst;
    reg [4:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17;
    m18VG_pipelined m( min1, min2, q4q3q2q1q0, x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,clk,rst);

    initial begin
        clk = 0;
        rst = 0;
        {x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17} = 66'b0;
    end
    always #10 clk = ~clk;
    always @(negedge clk) #1 {x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17} = {x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17} + $random;   
    
endmodule
