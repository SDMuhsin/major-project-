`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:32:29
// Design Name: 
// Module Name: function_generator1
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


module Function_generator1 (f,adrs,rst);
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
  2'b00: f = 256'hA46E4D428785B1F9D8B4E21F29CBC29BAEA864941632C25D592CF718233853E4;
  2'b01: f = 256'hCDE507D9D76A4E862DD0B259985C5C7F79BC655F18914CA6AC5D996B07F67B32;
  2'b10: f = 256'h8CC55DD293683704607D5B56B65BC01B82B9133F1708DEA7280FFC336042EDB2;
  2'b11: f = 256'hA03BA4371527756650C054E5086DF88DEF5B2EBBA6AB6F46ED7572AA3675EFA8;
  default: f = 256'd0;
 
endcase
endmodule

