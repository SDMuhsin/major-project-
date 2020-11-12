`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2020 14:47:04
// Design Name: 
// Module Name: AdderWc
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


module AdderWc(
        sum,
        a,
        b,clk,rst
    );
parameter Wc = 18;
parameter W = 6;

output [Wc*W-1:0]sum;
input [Wc*W-1:0]a;
input [Wc*W-1:0]b;
input clk,rst;

//reg [Wc*W-1:0]a_1,a_2,a_3,a_4,a_5;
reg [Wc*W-1:0]b_1,b_2,b_3,b_4,b_5;

always@(posedge clk)
begin
if(rst)
begin
/*a_1<=0;
a_2<=0;
a_3<=0;
a_4<=0;
a_5<=0;*/

b_1<=0;
b_2<=0;
b_3<=0;
b_4<=0;
b_5<=0;
end

else
begin
/*a_1<=a;
a_2<=a_1;
a_3<=a_2;
a_4<=a_3;
a_5<=a_4;*/

b_1<=b;
b_2<=b_1;
b_3<=b_2;
b_4<=b_3;
b_5<=b_4;
end
end
genvar i;
generate for(i=0;i<Wc;i=i+1)begin:label
    defparam a.W = W;
    adderW2 a(sum[(i+1)*W-1:i*W],a[(i+1)*W-1:i*W],b_5[(i+1)*W-1:i*W]);
end
endgenerate

endmodule