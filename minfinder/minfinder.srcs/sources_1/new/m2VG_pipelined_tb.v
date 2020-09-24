`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2020 12:12:28
// Design Name: 
// Module Name: m2VG_pipelined_tb
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


module m2VG_pipelined_tb(

    );
    
    wire [4:0]min1,min2;
    wire cp;
    reg [4:0]x0,x1;
    
    reg clk,rst;
    
    initial begin
        {x0,x1} = 8'b0;
        {clk,rst} = 2'b0;
    end
    
    always #5 clk =~clk;
    always @(posedge clk) #3 {x0,x1} = $random;
    
    m2VG_pipelined m(min1,min2,cp,x0,x1,clk,rst);
    
    always @(posedge clk)begin
        #1;
        if (min1 != x0<x1?x0:x1 || min2 != x0>x1?x0:x1 || cp != x0<x1?0:1)begin
            $display("ERROR at %d",$time);
        end
    end
endmodule
