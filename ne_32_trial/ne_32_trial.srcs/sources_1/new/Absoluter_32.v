`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2020 21:17:45
// Design Name: 
// Module Name: Absoluter_18
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


module Absoluter_32(
        sign,
        mag,
        in,
        clk,rst
    );
parameter w = 6; // width of each input :
parameter wc = 32; // number of inputs

output [wc-1:0]sign;
output [wc*(w-1)-1:0]mag;
//wire [wc-1:0]sign_wire;
//wire [wc*(w-1)-1:0]mag_wire;
input [wc*w-1:0]in;
//reg [wc*w-1:0]in_reg;
input clk,rst;

genvar i;
generate for(i=0;i<wc;i=i+1) begin :loop1
    defparam a.w = w;
    Absoluter_adder a( sign[i], mag[ (i + 1)*(w-1) -1 : i * (w - 1)], in[(i + 1)*w -1 : i * w]);
end
endgenerate

/*always@(posedge clk)
    begin
    if(rst)
    begin
    //mag<=0;
    //sign<=0;
    in_reg<=0;
    end
    else
    begin
    //mag<=mag_wire;
    //sign<=sign_wire;
    in_reg<=in;
    end
    end*/

endmodule