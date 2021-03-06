`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2020 23:38:33
// Design Name: 
// Module Name: coverrecover
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


module coverrecover(Euncomp, Ecomp,clk,rst);
    parameter Wc=18;
parameter Wcbits = 5;
parameter W=6;
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
    output reg[(Wc*W)-1:0]Euncomp; 
    input[ECOMPSIZE-1:0] Ecomp;
    input clk,rst;
    
    wire[(Wc*W)-1:0] Euncompcomb;
    reg [ECOMPSIZE-1:0] Ecompcomb;
    
    always@(posedge clk)
    begin
      if(!rst)
      begin
       //input
        Ecompcomb<= 0;
        //output
        Euncomp <= 0; 
      end
      else
      begin
        Ecompcomb<= Ecomp;
        //output
        Euncomp <= Euncompcomb; 
      end
    end



    recovunit_ne d1(Euncompcomb, Ecompcomb);
    
endmodule
