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
    parameter W = 6;
    parameter Wc = 18;
    
    wire [W-2:0]min1,min2;
    wire [4:0]q4q3q2q1q0;
    
    reg clk,rst;
    reg [Wc*(W-1)-1:0]x;
    
    wire [(W-2):0]x_display[Wc-1:0];
    
    genvar i;
    generate for(i=0;i<Wc;i=i+1)begin:lab
        assign x_display[i] = x[(i+1)*(W-1)-1:i*(W-1)];
    end
    endgenerate
    m18VG_pipelined m( min1, min2, q4q3q2q1q0, x,clk,rst);

    initial begin
        clk = 0;
        rst = 0;
        {x} = 66'b0;
    end
    always #10 clk = ~clk;
    always @(negedge clk) #1 {x} = {x} + $random;   
    
endmodule
