`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2020 17:44:20
// Design Name: 
// Module Name: Absoluter_primitive_tb
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


module Absoluter_primitive_tb(

    );
       reg [5:0]in;
    wire sign;
    wire [4:0]mag;
    Absoluter_primitive a( sign, mag, in);
    
    always #5 in = $random;
endmodule
