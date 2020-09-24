`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2020 10:25:46
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
// ((W-1)+(W-1)+5+32)
//////////////////////////////////////////////////////////////////////////////////


module recovunit_ne(Euncomp, Ecomp);
parameter Wc=32;
parameter Wcbits = 5;
parameter W=10;
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
output[(Wc*W)-1:0] Euncomp; 
input[ECOMPSIZE-1:0] Ecomp;

//input clk, rst;
//Registered output
//wire[(Wc*W)-1:0] Euncomp;

//always@(posedge clk)
//begin
//  if(!rst)
//    Euncompout<=0;
//  else
//    Euncompout<=Euncomp;
//end
/////////////

wire[Wabs-1:0] Min1mag, Min2mag;
wire[W-1:0] posMin1, negMin1, posMin2, negMin2;
wire [Wcbits-1:0] Pos;
wire [Wc-1:0] UpdatedSign;

reg [W-1:0] E[Wc-1:0];
wire [Wc-1:0] poseq;

//Extract Min1, Min2, Pos, UpdatedSignbits
//assign Min1mag = Ecomp[ECOMPSIZE-1:ECOMPSIZE-1-(W-2)];
//assign Min2mag = Ecomp[ECOMPSIZE-1-(W-1):ECOMPSIZE-1-(W-1)-(W-2)];
//assign Pos = Ecomp[ECOMPSIZE-1-(2*(W-1)):ECOMPSIZE-1-(2*(W-1))-(Wcbits-1)];
//assign UpdatedSign = Ecomp[ECOMPSIZE-1-(2*(W-1))-(Wcbits):ECOMPSIZE-1-(2*(W-1))-(Wcbits)-(Wc-1)];
assign {Min1mag, Min2mag, Pos, UpdatedSign} = Ecomp;

//Find pos and neg Min1 and min2.
defparam signedMin1dut.W = W;
posnegX signedMin1dut(posMin1, negMin1, {1'b0,Min1mag});
defparam signedMin2dut.W = W;
posnegX signedMin2dut(posMin2, negMin2, {1'b0,Min2mag});

//Make uncompressed E
genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin: loop1
  assign poseq[i] = (Pos == i);
  
  always@(poseq[i],UpdatedSign[i],posMin1,negMin1,posMin2,negMin2)
  begin  
    case({poseq[i],UpdatedSign[i]})
      2'b00: E[i] = posMin1;
      2'b01: E[i] = negMin1;
      2'b10: E[i] = posMin2;
      2'b11: E[i] = negMin2;
      default: E[i] = 0;
    endcase
  end
  
  assign Euncomp[((i+1)*W)-1:(i*W)] = E[i];
end
endgenerate

endmodule
