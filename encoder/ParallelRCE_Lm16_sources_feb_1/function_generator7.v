`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:52:47
// Design Name: 
// Module Name: function_generator7
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


module Function_generator7(f,adrs,rst);
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
  2'b00: f = 256'h22547791E6F83A1668276FB8F74FDE0ADF439AE1FD54684ADFCB86D42310E119;
  2'b01: f = 256'hC3B5D55DB660F37812C1CA6E2AB2BA3FF362B5C2348042CC3B47D7C671F74C1B;
  2'b10: f = 256'h9A5C03FFE4A0A23B8E132DCCCC57455D658AE5C9B274EB9FFE30AD969F8A82EF;
  2'b11: f = 256'hF53F7F4CAEDC610E088F621CFFBC4723CAEFCB9E5F126260AF4A20C1A221B79D;
  default: f = 256'd0;
endcase
endmodule
