`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2020 12:24:10
// Design Name: 
// Module Name: m4VG_pipelined_tb
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


module m4VG_pipelined_tb(

    );
     wire [4:0]min1,min2;
    wire [1:0]q1q0;
    reg [4:0]x0,x1,x2,x3;
    
    reg clk,rst;
    
    initial begin
        {x0,x1,x2,x3} = 16'b0;
        {clk,rst} = 2'b0;
    end
    
    always #5 clk =~clk;
    always @(posedge clk) #3 {x0,x1,x2,x3} = $random;
    
    m4VG_pipelined m(min1,min2,q1q0,x0,x1,x2,x3,clk,rst);
endmodule
