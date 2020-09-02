`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2020 20:05:19
// Design Name: 
// Module Name: m2VG
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


module m2VG(
        output [4:0]min1,
        output [4:0]min2,
        output cp,
        input [4:0]x0,
        input [4:0]x1
    );
    assign min1 = x0<x1?x0:x1;
    assign min2 = x0<x1?x1:x0;
    assign cp = x0<x1?0:1;
endmodule
