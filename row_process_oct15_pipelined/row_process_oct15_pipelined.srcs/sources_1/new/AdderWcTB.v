`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2020 14:58:35
// Design Name: 
// Module Name: AdderWcTB
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


module AdderWcTB(

    );
    parameter Wc = 18;
    parameter W = 6;
    
    reg [Wc*W-1:0]a;
    reg [Wc*W-1:0]b;
    wire [Wc*W-1:0]sum;
    
    wire [W-1:0]a_display[Wc-1:0];
    wire [W-1:0]b_display[Wc-1:0];
    wire [W-1:0]sum_display[Wc-1:0];
    initial begin
        a = $random;
        b = $random;
    end
    
    always #10 {a} = a + 10'b11111_00000;
    always #10 {b} = b - 10'b11111_00000;
    AdderWc a1(sum,a,b);
    
    genvar i;
    generate for(i=0;i<Wc;i=i+1)begin:label
        assign a_display[i][W-1:0] = a[(i+1)*W-1:i*W];
        assign b_display[i][W-1:0] = b[(i+1)*W-1:i*W];
        assign sum_display[i][W-1:0] = sum[(i+1)*W-1:i*W];
    end 
    endgenerate
    
endmodule
