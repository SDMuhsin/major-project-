`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2020 19:50:06
// Design Name: 
// Module Name: Data_MUX
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


//module Data_MUX(msg_to_encode,sm,msg_in,sel,rst);
module Data_MUX(msg_to_encode,sm,msg_in,sel);
parameter K=1024;
parameter Lm=16;
parameter La=8;
parameter M=32;
parameter DIV = K/(M*La);
parameter MSEL_BITSIZE = 3; //log2(Km/(Lm*La))

output  [M*La-1:0]msg_to_encode;
input [K-1:0]msg_in;
input [1:0]sel; //same as f_sel 2 bit
//input rst;
input sm;
reg [M*La-1:0]msg_out1;
wire [K-1:0]msg_in1;
//assign msg_in1=rst?0:msg_in;
assign msg_in1 = msg_in;
always@(sel,msg_in1)
 begin
  case({sm,sel})
  3'b111 : msg_out1=msg_in1[(1*K/DIV-1):0];
  3'b110 : msg_out1=msg_in1[(2*K/DIV-1):K/DIV];
  3'b101 : msg_out1=msg_in1[(3*K/DIV-1):2*K/DIV];
  3'b100 : msg_out1=msg_in1[(4*K/DIV-1):3*K/DIV]; 
  default : msg_out1=0;
  endcase
  end
  assign msg_to_encode=msg_out1;
  //assign msg_to_encode=sm?msg_out1:'d0;
endmodule
