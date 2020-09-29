`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2020 21:17:22
// Design Name: 
// Module Name: Absoluter_cover
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


module Absoluter_2_cover(
        output reg sign_ff,
        output reg [4:0]mag_ff,
        input [5:0]in,
        clk,
        rst
    );
    
    reg [5:0]in_ff;
    wire sign_op;
    wire [4:0]mag_op;
    always @(posedge clk)begin
        if(rst)begin
            //o/p
            sign_ff <= 1'b0;
            mag_ff <= 5'b0;
            
            //i/p
            in_ff <= 6'b0;
        end
        else begin
            //o/p
            sign_ff <= sign_op;
            mag_ff <= mag_op;
            
            //i/p
            in_ff <= in;          
        end
    end
    
   // Absoluter_adder a(sign_op,mag_op,in_ff);
    //Absoluter_case_statement a(sign_op,mag_op,in_ff);
    //Absoluter_primitive a(sign_op,mag_op,in_ff);
    
   //original
   defparam a.W = 6;
   absW a(sign_op,mag_op,in_ff);
endmodule
