`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:35:08
// Design Name: 
// Module Name: function_generator4
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


module Function_generator4(f,adrs,rst);
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
  2'b00: f = 256'h32C682B95BE872024F8682DC7499AC4AD1D2D257873D0962856C5B9F8DD9C268;
  2'b01: f = 256'hE4364EF359421CDE2243EC5DDBE8EE7753993A27DC807C7E253001DEE74FE4A6;
  2'b10: f = 256'hBD110A540816D36E84BC96D3ABF79703760A499F4107399465AA88096855C9D0;
  2'b11: f = 256'h4E441AAE9942A76839D0E0BEEA80C8D54B98636EAB4700AA9A2019F8C1FE39BA;
  default: f = 256'd0;
endcase
endmodule
