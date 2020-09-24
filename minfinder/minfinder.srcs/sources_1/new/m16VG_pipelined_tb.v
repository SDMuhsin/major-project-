`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2020 13:25:03
// Design Name: 
// Module Name: m16VG_pipelined_tb
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


module m16VG_pipelined_tb(

    );
    wire [4:0]min1,min2;
    wire [3:0]q3q2q1q0;
    reg [4:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15;
    
    reg clk,rst;
    
    initial begin
        {x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15} = 64'b0;
        {clk,rst} = 2'b0;
    end
    
    always #5 clk =~clk;
    always @(posedge clk) #3 {x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15} = $random;
    
    m16VG_pipelined m(min1,min2,q3q2q1q0,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,clk,rst);
endmodule
