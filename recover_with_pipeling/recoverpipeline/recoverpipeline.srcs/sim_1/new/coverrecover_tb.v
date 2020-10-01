`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2020 12:17:36
// Design Name: 
// Module Name: coverrecover_tb
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


module coverrecover_tb();

    parameter Wc=18;
    parameter Wcbits = 5;
    parameter W=6;
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
    reg clk,rst;
    wire [ECOMPSIZE-1:0] Ecomp;
    reg [Wc-1:0] UpdatedSign;
    reg [Wcbits-1:0]Pos;
    reg [Wabs-1:0]Min1mag,Min2mag;
    wire [(Wc*W)-1:0]Euncomp; 
    wire [W-1:0] E[Wc-1:0];
 assign Ecomp={Min1mag, Min2mag, Pos, UpdatedSign};
 
 
 genvar i;
 generate for(i=0;i<=Wc-1;i=i+1) begin: loop1
 assign E[i] =Euncomp[((i+1)*W)-1:(i*W)] ; 
 end
 endgenerate
 
 coverrecover dut1(Euncomp, Ecomp,clk,rst);
always
#20clk=~clk;
initial
begin
clk=0;
rst=1;
UpdatedSign={{16{1'b1}},{16{1'b0}}};
Min1mag=12;
Min2mag=19;
Pos =17;


end
endmodule
