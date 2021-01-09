`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.01.2021 10:48:37
// Design Name: 
// Module Name: adder_cover
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


module adder_cover(sum_s,a_s,b_s,c_s,clk,rst

    );
    
    parameter W=6;
    //output carryout;
    output reg [W-1:0] sum_s;
    input [W-1:0] a_s, b_s, c_s;
    input clk,rst;
    
    reg [W-1:0]a,b,c,sum_r;
    //wire [W:0] x,y,z,sum_inter_2,sum_2;
    wire [W-1:0] sum;
    
    always@(posedge clk)
        begin
        if(rst)
        begin
        a<=0;
        b<=0;
        c<=0;
        sum_s<=0;
        end
        
        else
        begin
        a<=a_s;
        b<=b_s;
        c<=c_s;
        sum_s<=sum;
        end
        
        end
        
        adderW2 m1(sum,a,b,c,clk,rst);
endmodule
