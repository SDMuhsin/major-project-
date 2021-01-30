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
        b,c,clk,rst
    );
parameter Wc = 32;
parameter W = 6;

output [Wc*W-1:0]sum;
input [Wc*W-1:0]a;
input [Wc*W-1:0]b;
input [Wc*W-1:0]c;
reg [Wc*W-1:0]a_r,b_r,c_r;
input clk,rst;

genvar i;
generate for(i=0;i<Wc;i=i+1)begin:label
    defparam a.W = W;
    adderW2 a(sum[(i+1)*W-1:i*W],a[(i+1)*W-1:i*W],b[(i+1)*W-1:i*W],c[(i+1)*W-1:i*W],clk,rst);
end
endgenerate

/*always@(posedge clk)
    begin
    if(!rst)
    begin
    a_r<=0;
    b_r<=0;
    c_r<=0;
    end
    
    else
    begin
    a_r<=a;
    b_r<=b;
    c_r<=c;
    end
    
    end
*/
endmodule