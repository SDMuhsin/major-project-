`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:51:38
// Design Name: 
// Module Name: function_generator6
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


module Function_generator6(f,adrs,rst);
parameter K_N=32;
output reg [K_N-1:0]f;
input [1:0]adrs;
input rst;
//input clk;
always@(adrs,rst)
if(rst)
f = 256'd0;
else
case(adrs)
  2'b00: f = 256'h86F9814253CEEC2C54926588FC2F4C12B7883921F2617F0F0020E433766B64E9;
  2'b01: f = 256'h1FB654F641FD4FF9AACA46CB8196622483528FAB57524387C1B0A115048A3C5E;
  2'b10: f = 256'h6861F1584D4BEFA3723D4B5ADB6178FD5FFDEF35E9A91ACF32A6EEE526C8BB48;
  2'b11: f = 256'h0FF7F9768FD3E9E024136C97AF578393627E062B70DEB711B5068749B50288CE;
  default: f = 256'd0;
endcase
endmodule
