`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2021 18:47:47
// Design Name: 
// Module Name: dumy_gen_32
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


module dumy_gen_32(
        out,
        datavalid,
        in,
        clk,
        rst
    );
    
    output reg [7:0]out;
    output reg datavalid;
    input [32*6-1:0]in;
    
    input clk,rst;
    
    always@(posedge clk)begin
        if(!rst)begin
            out <= 0;
            datavalid <= 0;
        end
        else begin
            out <= in[7:0];
            datavalid <= 1'b1;
        end
    end
endmodule
