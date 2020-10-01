`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: recovunit_ne
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
// per row Ecomp = Min1, Min2, Pos, UpdatedSignbits
// ((W-1)+(W-1)+5+18)
//////////////////////////////////////////////////////////////////////////////////


module recovunit_mux(Euncomp,min1pos,min1neg,min2pos,min2neg,hotpos,UpdatedSign);
parameter Wc=18;
parameter Wcbits = 6;
parameter W=6;
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
output[(Wc*W)-1:0] Euncomp; 
    input [Wc-1:0] UpdatedSign;
input [Wc-1:0]hotpos;
input[W-1:0]min1pos,min1neg,min2pos,min2neg;

reg [W-1:0] E[Wc-1:0];

genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin: loop1

  
  always@(*)
  begin  
    case({hotpos[i],UpdatedSign[i]})
      2'b00: E[i] = min1pos;
      2'b01: E[i] = min1neg;
      2'b10: E[i] = min2pos;
      2'b11: E[i] = min2neg;
   
    endcase
  end
  
  
assign Euncomp[((i+1)*W)-1:(i*W)] = E[i];
end
endgenerate

endmodule
