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


module subtractor_18 (sub18, L, E);

    parameter W=6;  //no. of bits
    parameter Wc=18;  //no. of elements in the list  
    output [W*Wc-1:0]sub18;
    input [W*Wc-1:0]L;
    input [W*Wc-1:0]E;
    
    genvar i;
    generate for(i=Wc*W-1;i>=0;i=i-W) begin : loop
        subtract_2 sb1(sub18[i:i-W+1],L[i:i-W+1],E[i:i-W+1]);
        end
    endgenerate
    

    
endmodule
