`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2020 16:15:46
// Design Name: 
// Module Name: Absoluter_case_tb
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


module Absoluter_case_tb(

    );
       reg [5:0]in;
       wire sign;
       wire [4:0]mag;
       Absoluter_case_statement a( sign, mag, in);
       
       always #5 in = $random;
endmodule
