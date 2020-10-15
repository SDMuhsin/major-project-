`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2020 22:47:56
// Design Name: 
// Module Name: rowunit_cover
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


module rowunit_cover(LLR_OUT_s,E_MEM_OUT_s,E_MEM_IN_s,LLR_IN_s,clk,rst);
    
     parameter Wc=18;
     parameter Wcbits = 5;
     parameter W=6;   
     parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
     
     input clk,rst;
     
     output reg [Wc*W-1:0]LLR_OUT_s;
     input [Wc*W-1:0]LLR_IN_s;
     input [ECOMPSIZE-1:0]E_MEM_IN_s;
     output reg [ECOMPSIZE-1:0]E_MEM_OUT_s;
     
     wire [Wc*W-1:0]LLR_OUT;
     reg [Wc*W-1:0]LLR_IN;
     reg [ECOMPSIZE-1:0]E_MEM_IN;
     wire [ECOMPSIZE-1:0]E_MEM_OUT;
     
     always@(posedge clk)
     begin
     if(rst)
     begin
         LLR_OUT_s<=0;
         E_MEM_OUT_s<=0;
         LLR_IN<=0;
         E_MEM_IN<=0;
     end
     
     else
     begin
         LLR_OUT_s<=LLR_OUT;
         E_MEM_OUT_s<=E_MEM_OUT;
         LLR_IN<=LLR_IN_s;
         E_MEM_IN<=E_MEM_IN_s;
     end
     
     end
     
     RowUnit m1(LLR_OUT,E_MEM_OUT,E_MEM_IN,LLR_IN,clk,rst);
      
endmodule