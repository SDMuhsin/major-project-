`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2020 17:33:32
// Design Name: 
// Module Name: function_generator2
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


module Function_generator2(f,adrs,rst);
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
  2'b00: f = 256'hE9C00937C6052526652373D9F0E5DA0B87DAA8E783390FFE9A047476A7E6A8FE;
  2'b01: f = 256'hA7F8D121F651AD508FE0E82CD2E26CF7A5E5C46F5D937AC576D909241915E526;
  2'b10: f = 256'h61ABFC0A89D16F4ACFB96BE9726E3948EFC284D15DCF76C53691E43EADE6F06A;
  2'b11: f = 256'h509FE28A803770FF366995488DA0E8E10CFFAC97EA94C7623F96B62A60BD851D;
  default: f = 256'd0;

endcase
endmodule
