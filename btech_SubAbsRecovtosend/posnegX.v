`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2020 13:38:13
// Design Name: 
// Module Name: signappend
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
// For recover unit, Xmag = {0,Min1mag} or {0,Min2mag}
// For Absolute unit, Xmag = L with its sign bit.
//////////////////////////////////////////////////////////////////////////////////


module posnegX(posX, negX, Xmag);
parameter W = 10;
output [W-1:0] posX, negX;
input [W-1:0] Xmag;

wire [W-1:0] a,y,c;
//assign a = {1'b0,Xmag};
assign a = Xmag;
assign posX = a;
//y=-a logic: y = (~a) + {{W{1'b0}},1'b1};
assign y[0] = a[0];
assign c[0] = ~a[0];

assign c[W-1:1] = c[W-2:0]&(~a[W-1:1]);
assign y[W-1:1] = c[W-2:0]^(~a[W-1:1]);

assign negX = y;
endmodule