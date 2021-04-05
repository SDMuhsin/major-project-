`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2021 17:22:14
// Design Name: 
// Module Name: AdderW_3in_pipelined
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
// Bug1: c was not sign extended before addition : Fixed by adding z
// error1: for c=-4=3'b100, suminter=4 = 0+0+(-4); should be summinter=-4
// Bug2: Sign extension should be by 2 bits instead of 1 bit.
// error2: case01, a=b=c=-4, suminter should be -12, but it is +4 (4'b0100) since 1 extra bit missing
// error2: case10, a=b=c=+3, suminter should be +9, but it is -7 (4'b1001) since 1 extra sign bit is missing
// soln: if suminter= -12 (5'b10100), case 101
// soln: if suminter= +9 (5'b01001), case 010
// case 000,100,011,111: sum is same as suminter[W-1:0]
// Sat logic modified to:-
// case 001: same as old max +ve
// case 110: same as old max -ve
// case 101: max -ve
// case 010: max +ve
//////////////////////////////////////////////////////////////////////////////////


module AdderW_3in_pipelined(carryout, sum, a, b, c, clk, rst);
parameter W=10;//configurable parameter
output carryout;
output reg[W-1:0] sum;
input [W-1:0] a, b, c;
input clk, rst;
//for 2 operand adder:
//wire [W:0] x,y,z,sum_inter;
//assign x = {a[W-1],a};
//assign y = {b[W-1],b};

//for 3 operand adder (fix2)
wire [W+1:0] x,y,z,sum_inter_regin;
reg [W+1:0] sum_inter;

assign x = {a[W-1],a[W-1],a};
assign y = {b[W-1],b[W-1],b};
assign z = {c[W-1],c[W-1],c};//fix1

assign {carryout,sum_inter_regin} = x+y+z;//c; //fix1

//Sat Logic: 
// for 2 operand adder:
//always@(sum_inter)
//begin
//  case({sum_inter[W:W-1]})
//    2'b00,2'b11: sum = sum_inter[W-1:0]; 
//    2'b01: sum = {1'b0,{(W-1){1'b1}}};
//    2'b10: sum = {1'b1,{(W-1){1'b0}}};
//  endcase
//end

//Pipereg:
always@(posedge clk)
begin
  if(!rst)
  begin
    sum_inter<=0;
  end
  else
  begin
    sum_inter<=sum_inter_regin;
  end
end

//for 3 operand adder: (fix2)
always@(sum_inter)
begin
  case({sum_inter[W+1:W-1]})
    3'b000,3'b100, 3'b011, 3'b111: sum = sum_inter[W-1:0]; 
    3'b001: sum = {1'b0,{(W-1){1'b1}}};
    3'b101: sum = {1'b1,{(W-1){1'b0}}};
    3'b010: sum = {1'b0,{(W-1){1'b1}}};
    3'b110: sum = {1'b1,{(W-1){1'b0}}};
  endcase
end

endmodule
