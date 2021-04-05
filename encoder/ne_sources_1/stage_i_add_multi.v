`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2020 13:23:21
// Design Name: 
// Module Name: stage_i_add_multi
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


module stage_i_add_multi(w,w0,si,f);
output w;
input w0;
input si;
input f;
wire z;
 and D0(z,si,f);
 xor D1(w,z,w0);
endmodule
