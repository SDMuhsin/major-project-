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


module Absoluter_18(
        sign,
        mag,
        in
    );
parameter w = 6; // width of each input :
parameter wc = 18; // number of inputs

output [wc-1:0]sign;
output [wc*(w-1)-1:0]mag;
input [wc*w-1:0]in;

genvar i;
generate for(i=0;i<wc;i=i+1) begin :loop1
    defparam a.w = w;
    Absoluter_adder a( sign[i], mag[ (i + 1)*(w-1) -1 : i * (w - 1)], in[(i + 1)*w -1 : i * w]);
end
endgenerate

endmodule
