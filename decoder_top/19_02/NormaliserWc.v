`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2020 12:37:20
// Design Name: 
// Module Name: NormaliserWc
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
// additional reg at output absnormL. removed;
// registered input removed.
// sign registers removed.
//////////////////////////////////////////////////////////////////////////////////


module NormaliserWc(absnormL, absL, clk,rst);
//module NormaliserWc(signL_regout, absnormL_regout,signL_regin, absL_regin, clk,rst);
parameter W = 10;
parameter Wabs = W-1;
parameter Wc = 18;
//output reg[Wc-1:0] signL_regout;
//output reg[(Wc*Wabs)-1:0] absnormL_regout;
output[(Wc*Wabs)-1:0] absnormL;
//input [Wc-1:0] signL_regin;
//input [(Wc*Wabs)-1:0] absL_regin;
input [(Wc*Wabs)-1:0] absL;
input clk,rst;
  
//////////
//reg input and output
//reg [(Wc*Wabs)-1:0] absL;
//wire [(Wc*Wabs)-1:0] absnormL;
//always@(posedge clk)
//begin
//  if(!rst)
//  begin
//  //  absL<=0;
//    //outputs
//   // signL_regout<=0; 
////    absnormL_regout<=0;
//  end
//  else
//  begin
//  //  absL<=absL_regin;
//    //outputs
//   // signL_regout<=signL_regin;
////    absnormL_regout<=absnormL;
//  end
//end
////////

wire [Wabs-1:0] absLarray[Wc-1:0];
wire [Wabs-1:0] normabsL[Wc-1:0];
genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin : normloop
  assign absLarray[i] = absL[((i+1)*Wabs)-1:(i*Wabs)]; //split bitvec into array
  
  defparam norm.W = W;
  normaliserW norm(normabsL[i], absLarray[i]);

 assign absnormL[((i+1)*(W-1))-1:(i*(W-1))] = normabsL[i]; //combine bitvec into array
end
endgenerate


endmodule
