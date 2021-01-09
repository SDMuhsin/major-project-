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

module adderW2(sum, a, b,c,clk,rst);
parameter W=6;
//output carryout;
output reg [W-1:0] sum;
input [W-1:0] a, b, c;
input clk,rst;

reg [W-1:0]a_r,b_r,c_r,sum_1;
  wire [W+1:0] x,y,z,sum_inter,sum_inter_2,sum_2;
  assign x = {a[W-1],a[W-1],a};
  assign y = {b[W-1],b[W-1],b};
  assign z = {c[W-1],c[W-1],c};
//assign sum_2={sum_1[W-1],sum_1};

assign {sum_inter} = x+y+z;
//assign {sum_inter_1} = x+y;

always@(sum_inter)
begin
  case({sum_inter[W+1:W-1]})
    3'b000,3'b111,3'b011,3'b100: sum = sum_inter[W-1:0]; //sum_inter[W]=sum_inter[W-1] -> no overflow
    3'b010,3'b001: sum = {1'b0,{(W-1){1'b1}}};    //overflow and msb 0->positive saturation
    3'b101,3'b110: sum = {1'b1,{(W-1){1'b0}}};    //overflow and msb 1->negative saturation
  endcase
end

/*assign {sum_inter_2} = sum_2+z;
always@(sum_inter_2)
begin
  case({sum_inter_2[W:W-1]})
    2'b00,2'b11: sum = sum_inter_2[W-1:0]; 
    2'b01: sum = {1'b0,{(W-1){1'b1}}};
    2'b10: sum = {1'b1,{(W-1){1'b0}}};
  endcase
end*/
  
/*always@(posedge clk)
    begin
    if(rst)
    begin
    a_r<=0;
    b_r<=0;
    end
    
    else
    begin
    a_r<=a;
    b_r<=b;
    end
    
    end*/

endmodule
