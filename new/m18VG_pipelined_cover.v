`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2020 13:57:43
// Design Name: 
// Module Name: m18VG_pipelined_cover
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


module m18VG_pipelined_cover(
    min1_s,
    min2_s,
    q4q3q2q1q0_s,
    x_s,
    clk,rst

    );
    
        parameter W=6;
        parameter Wc=18;
        
        output reg [W-2:0]min1_s;
        output reg [W-2:0]min2_s;
        output reg [4:0] q4q3q2q1q0_s;
        
         input [Wc*(W-1)-1:0]x_s;
         input clk,rst;
         
    wire [W-2:0]min1;     
    wire [W-2:0]min2;
    wire [4:0]q4q3q2q1q0;
    reg [Wc*(W-1)-1:0]x;
    
    always@(posedge clk)
    begin
    if(rst)
    begin
    min1_s<=4'b0;
    min2_s<=4'b0;
    q4q3q2q1q0_s<=4'b0;
    
    x<=0;
    
    end
    
    else
    begin
    min1_s<=min1;
    min2_s<=min2;
    q4q3q2q1q0_s<=q4q3q2q1q0;
    
    x<=x_s;
    
    end
    end
    
    m18VG_pipelined g1(min1,min2,q4q3q2q1q0,x,clk,rst);
endmodule