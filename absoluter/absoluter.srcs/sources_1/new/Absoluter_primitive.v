`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2020 17:25:11
// Design Name: 
// Module Name: Absoluter_primitive
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


module Absoluter_primitive(
        output sign,
        output [4:0]mag,
        input [5:0]in
    );
    assign f = in[0];
    assign e = in[1];
    assign d = in[2];
    assign c = in[3];
    assign b = in[4];
    assign a = in[5];
    
    assign sign = a;
    
    assign mag[4] = ~a&b | a&~b | b&~c&~d&~e&~f;
    assign mag[3] = c&~d&~e&~f | a&~c&f | a&~c&e | a&~c&d | ~a&c | a&~b&~c;    
    assign mag[2] = d&~e&~f | a&~d&f | a&~d&e | ~a&d | a&~b&~c&~d;
    assign mag[1] = a&~e&f|~a&e|e&~f|a&~b&~c&~d&~e;
    assign mag[0] = ~a&~b&~c&~d&~e|f;
endmodule
