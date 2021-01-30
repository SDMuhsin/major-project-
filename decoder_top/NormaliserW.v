`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2020 12:37:20
// Design Name: 
// Module Name: normaliserW
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


module normaliserW(NormMagX,MagX);
parameter W = 10;
parameter Wabs=W-1;
output [Wabs-1:0] NormMagX;//Wabs = W-1
input [Wabs-1:0] MagX;

wire cout;
wire [Wabs:0] normby2mag, normby4mag,NormMagX_W;

//Normaliser: normalisedMagX = 0.75*MagX 
//logic: normval = magX>>1 + magX>>2
//wire [Wabs-1:0] normactmag;
//assign normactmag= 0.75*MagX; //unsupported for Synthesis
//assign NormMagX=normactmag;
assign normby2mag = {1'b0,MagX[Wabs-1:0]};//increasing precision
assign normby4mag = {2'b0,MagX[Wabs-1:1]};//increasing precision
assign {cout,NormMagX_W} = normby2mag + normby4mag;
assign NormMagX = NormMagX_W[Wabs:1];//truncation precision

endmodule