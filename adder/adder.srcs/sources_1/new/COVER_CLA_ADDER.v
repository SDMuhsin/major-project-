`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2020 13:26:44
// Design Name: 
// Module Name: COVER_CLA_ADDER
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


module COVER_CLA_ADDER(
        output reg cout_ff,
        output reg [6:0]sum_ff,
        input [6:0]a_input,
        input [6:0]b_input,
        input cin_input,
        input clk,
        input rst 
    );
    
    reg [6:0]a_ff,b_ff;
    reg cin_ff;

    wire [6:0]sum_cut;
    wire cout_cut,cin_cut;
        
    always @(posedge clk)begin
        if(!rst)begin
            
            //input
            cin_ff <= 1'b0;
            a_ff <= 0;
            b_ff <= 0;
            
            //output
            cout_ff <= 1'b0;
            sum_ff <= 0;
        end
        else begin
            
           //input
           a_ff <= a_input;
           b_ff <= b_input;
           cin_ff <= cin_input;
            
            //output
            cout_ff <= cout_cut;
            sum_ff <= sum_cut;
        end
    end

    CLA_ADDER ca(cout_cut,sum_cut,a_ff,b_ff,cin_ff);
endmodule
