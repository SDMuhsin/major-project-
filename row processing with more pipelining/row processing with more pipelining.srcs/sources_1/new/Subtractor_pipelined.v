`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2020 18:03:55
// Design Name: 
// Module Name: subtractor_18
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


module subtractor_18 (sub18, L, E,clk,rst);

    parameter W=6;  //no. of bits
    parameter Wc=18;  //no. of elements in the list  
    output reg [W*Wc-1:0]sub18;
    input [W*Wc-1:0]L;
    input [W*Wc-1:0]E;
    input clk,rst;
    wire [W*Wc-1:0]sub18_wire;
    reg [W*Wc-1:0]L_reg;
    reg [W*Wc-1:0]E_reg;
    
    genvar i;
    generate for(i=Wc*W-1;i>=0;i=i-W) begin : loop
        subtract_2 sb1(sub18_wire[i:i-W+1],L_reg[i:i-W+1],E_reg[i:i-W+1],clk,rst);
        end
    endgenerate
    
    always@(posedge clk)
    begin
    if(rst)
    begin
    sub18<=0;
    L_reg<=0;
    E_reg<=0;
    end
    
    else
    begin
    sub18<=sub18_wire;
    L_reg<=L;
    E_reg<=E;
    end
    end
    
endmodule