`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2020 12:01:35
// Design Name: 
// Module Name: absW
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


module absW(SignX, MagX, X);
parameter W = 10;
output SignX;
output [W-2:0] MagX;
input [W-1:0] X;

wire [W:0] a,y,c;
reg [W-1:0] negX;
//assign a = {1'b0,Xmag};
assign a = {X[W-1],X};

//y=-a logic: y = (~a) + {{W{1'b0}},1'b1};
assign y[0] = a[0];
assign c[0] = ~a[0];

assign c[W:1] = c[W-1:0]&(~a[W:1]);
assign y[W:1] = c[W-1:0]^(~a[W:1]);

//truncation for negX:
always@(y)
begin
  case({y[W:W-1]})
    2'b00,2'b11: negX = y[W-1:0]; 
    2'b01: negX = {1'b0,{(W-1){1'b1}}};
    2'b10: negX = {1'b1,{(W-1){1'b0}}};
  endcase
end

assign MagX = X[W-1] ? negX[W-2:0] : X[W-2:0];
assign SignX = X[W-1];

endmodule