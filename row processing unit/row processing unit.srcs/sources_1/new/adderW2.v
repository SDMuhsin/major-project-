`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2020 19:37:14
// Design Name: 
// Module Name: adderW2
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

module adderW2( /*carryout*/ sum, a, b);
parameter W=10;
//output carryout;
output reg[W-1:0] sum;
input [W-1:0] a, b;

wire [W:0] x,y,sum_inter;
assign x = {a[W-1],a};
assign y = {b[W-1],b};

assign {sum_inter} = x+y;

always@(sum_inter)
begin
  case({sum_inter[W:W-1]})
    2'b00,2'b11: sum = sum_inter[W-1:0]; 
    2'b01: sum = {1'b0,{(W-1){1'b1}}};
    2'b10: sum = {1'b1,{(W-1){1'b0}}};
  endcase
end

endmodule

