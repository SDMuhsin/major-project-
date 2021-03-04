`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2020 17:38:22
// Design Name: 
// Module Name: subtractorW
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
// inputs a, b and output diff are made W+1 bit
// for correct calculation
//////////////////////////////////////////////////////////////////////////////////


module subtractorW(borrowout, diff, a, b, borrowin);
parameter W=10;
output borrowout;
output reg[W-1:0] diff;
input [W-1:0] a, b;
input borrowin;

wire [W:0] x,y, diff_inter;
assign x = {a[W-1],a};
assign y = {b[W-1],b};

assign {borrowout,diff_inter} = x+~y+1'b1; //x-y;//-borrowin;

always@(diff_inter)
begin
  case(diff_inter[W:W-1])
    2'b00, 2'b11: diff = diff_inter[W-1:0];
    2'b01: diff = {1'b0,{(W-1){1'b1}}};
    2'b10: diff = {1'b1,{(W-1){1'b0}}};
  endcase
end

endmodule
