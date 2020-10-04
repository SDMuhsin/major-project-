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


module Absoluter_18_pipelined(
        sgn_5,
        mag_wire,
        //mag_5,
        in,rst,clk
    );
parameter w = 6; // width of each input :
parameter wc = 18; // number of inputs

output [wc*(w-1)-1:0]mag_wire;
output reg [wc-1:0]sgn_5;
//output reg [wc*(w-1)-1:0]mag_5;
input [wc*w-1:0]in;
input rst,clk;

wire [wc-1:0]sign_wire;
//wire [wc*(w-1)-1:0]mag_wire;
reg [wc-1:0]sgn_1,sgn_2,sgn_3,sgn_4;//,sgn_5;
//reg [wc*(w-1)-1:0]mag_1,mag_2,mag_3,mag_4;//,mag_5;

always@(posedge clk)
begin
    if(rst)
        begin
        sgn_1<=0;
        sgn_2<=0;
        sgn_3<=0;
        sgn_4<=0;
        sgn_5<=0;
        //sign<=0;
        
       /* mag_1<=0;
        mag_2<=0;
        mag_3<=0;
        mag_4<=0;
        mag_5<=0;*/
        //mag<=0;
        end
        else
        begin
        sgn_1<=sign_wire;
        sgn_2<=sgn_1;
        sgn_3<=sgn_2;
        sgn_4<=sgn_3;
        sgn_5<=sgn_4;
        //sign<=sgn_5;
        
        /*mag_1<=mag_wire;
        mag_2<=mag_1;
        mag_3<=mag_2;
        mag_4<=mag_3;
        mag_5<=mag_4;*/
        //mag<=mag_5;
        
        end
end
        
genvar i;
generate for(i=0;i<wc;i=i+1) begin :loop1
    defparam a.w = w;
    Absoluter_adder a( sign_wire[i], mag_wire[ (i + 1)*(w-1) -1 : i * (w - 1)], in[(i + 1)*w -1 : i * w]);
end
endgenerate

endmodule