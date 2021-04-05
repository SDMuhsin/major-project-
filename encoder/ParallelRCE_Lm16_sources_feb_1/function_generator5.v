`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:50:50
// Design Name: 
// Module Name: function_generator5
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


module Function_generator5(f,adrs,rst);
parameter K_N=256;
output reg [K_N-1:0]f;
input [1:0]adrs;
input rst;
//input clk;
always@(adrs,rst)
if(rst)
f = 256'd0;
else
case(adrs)
  2'b00: f = 256'hAD2A4EBAD1E92DA8244A0B00209BDE081A7EBA13A58F8A20E918B9779F65BC89;
  2'b01: f = 256'h41EC63AEEC80233868F9678AFAA8D2827B2698FBEF8E3C8F2201797661373A36;
  2'b10: f = 256'h737F7F186CAC600D910E12A99DD8CDD2E9BFCF66051AD4C75E429C54F97B1B3A;
  2'b11: f = 256'hB85BB056086D176F85070BA40792E42460525B7F6B96B4E09E5BE3C0AACC558A;
  default: f = 256'd0;
endcase
endmodule
