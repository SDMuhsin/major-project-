`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2021 13:44:17
// Design Name: 
// Module Name: ne_parityshifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Shift and Add network: 
// Function: preg[0:Z-1] = (RightRotate(preg[0:Z-1], Lm) ) XOR u[0:Z-1] 
// Z: circulant size
// Lm: Parallelism parameter
// u: MAC network product
// clr: Active high clear the parity registers after encoding
// rst: active high rst  
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Shift and Add:
// preg[0:Z-1] = (RightRotate(preg[0:Z-1], Lm) ) XOR u[0:Z-1] . 
// in Verilog big endian: R[Z-1:0] = (LeftRotate(R[Z-1:0], Lm)) XOR u[Z-1:0]. 
//////////////////////////////////////////////////////////////////////////////////


module ne_parityshifter(parityout,u,clk,clr,parityshiften,rst);
parameter Z=5;
parameter Lm=2;
input [Z-1:0]u;
input parityshiften;
input clk,rst,clr;
output[Z-1:0] parityout;

reg[Z-1:0] pReg;


always@(posedge clk)
begin
  if(rst)
  begin
    pReg<=0;
  end
  else
  begin
    if(clr)
    begin
      pReg<=0;
    end
    else
    begin
      if(parityshiften)
        pReg<= {pReg[(Z-1)-Lm:0], pReg[Z-1:(Z-1)-(Lm-1)]} ^ u;
      else
        pReg<= pReg; 
    end
  end
end

assign parityout=pReg;

endmodule
