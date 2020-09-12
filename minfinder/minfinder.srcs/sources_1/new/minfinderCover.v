`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2020 13:51:16
// Design Name: 
// Module Name: m18VG_synth
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


module m18VGCOVER(output reg [4:0]min1_s,
    output reg [4:0]min2_s,
    output reg [4:0]q4q3q2q1q0_s,
    input [4:0]x0_s,x1_s,x2_s,x3_s,x4_s,x5_s,x6_s,x7_s,x8_s,x9_s,x10_s,x11_s,x12_s,x13_s,x14_s,x15_s,x16_s,x17_s,
    input rst,clk

    );
        
        wire [4:0]min1;     
        wire [4:0]min2;
        wire [4:0]q4q3q2q1q0;
        reg [4:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17;
        
        always@(posedge clk)
        begin
        if(rst)
        begin
        min1_s<=4'b0;
        min2_s<=4'b0;
        q4q3q2q1q0_s<=4'b0;
        
        x0<=4'b0;
        x1<=4'b0;
        x2<=4'b0;
        x3<=4'b0;
        x4<=4'b0;
        x5<=4'b0;
        x6<=4'b0;
        x7<=4'b0;
        x8<=4'b0;
        x9<=4'b0;
        x10<=4'b0;
        x11<=4'b0;
        x12<=4'b0;
        x13<=4'b0;
        x14<=4'b0;
        x15<=4'b0;
        
        end
        
        else
        begin
        min1_s<=min1;
        min2_s<=min2;
        q4q3q2q1q0_s<=q4q3q2q1q0;
        
        x0<=x0_s;
        x1<=x1_s;
        x2<=x2_s;
               x3<=x3_s;
               x4<=x4_s;
               x5<=x5_s;
               x6<=x6_s;
               x7<=x7_s;
               x8<=x8_s;
               x9<=x9_s;
               x10<=x10_s;
               x11<=x11_s;
               x12<=x12_s;
               x13<=x13_s;
               x14<=x14_s;
               x15<=x15_s;
        end
        end
        
        m18VG g1(min1,min2,q4q3q2q1q0,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17);
endmodule