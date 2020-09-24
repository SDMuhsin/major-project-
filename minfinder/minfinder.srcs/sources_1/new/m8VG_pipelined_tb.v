`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2020 13:19:13
// Design Name: 
// Module Name: m8VG_pipelined_tb
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


module m8VG_pipelined_tb(

    );
    wire [4:0]min1,min2;
    wire [2:0]q2q1q0;
    reg [4:0]x0,x1,x2,x3,x4,x5,x6,x7;
    
    reg clk,rst;
    
    initial begin
        {x0,x1,x2,x3,x4,x5,x6,x7} = 32'b0;
        {clk,rst} = 2'b0;
    end
    
    always #5 clk =~clk;
    always @(posedge clk) #3 {x0,x1,x2,x3,x4,x5,x6,x7} = $random;
    
    m8VG_pipelined m(min1,min2,q2q1q0,x0,x1,x2,x3,x4,x5,x6,x7,clk,rst);
endmodule
