`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 23:58:54
// Design Name: 
// Module Name: outfifo_uarttx_controller
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
// outfifo size:
// for 7136 output bits / 32 = 223 is write depth
// for 7136/8 = 892 is read depth
// When configuring outfifo for 32 bits input port and 8 bit output port
// write depth becomes 512 and read depth becomes 2048
// Empty flag should be given from FIFO when 892 (8-bit)words are out, 
// i.e. if FIFO words become 2048- 892 = 1156
// Full flag should be given from FIFO when 223 (32-bit) words are loaded,
// i.e. if FIFO words become 512- 223 = 289
//////////////////////////////////////////////////////////////////////////////////


module outfifo_uarttx_controller(o_Tx_Active, o_Tx_Serial, transmit_Ready, outfifo_rden, i_Tx_Byte, outfifo_empty, transmit_en, out_clk, rst);
//parameter W=8;
//parameter Wc=4;
//parameter DW=Wc*W;
//uarttx
parameter CLK_FREQ_FPGA=10000000;//10MHz , 100ns//50000000;//50MHz
parameter BAUDRATE=115200;//if baudrate is 9600 => CLK_FREQ_FPGA/BAUDRATE= 1042, c_BIT_PERIOD=104100ns
//output o_Tx_Done;
output o_Tx_Active; //LEd1
output o_Tx_Serial; //USB/UART/JTAG port
output transmit_Ready; //Led2

output reg outfifo_rden; //1 cycle read assumed
input[7:0] i_Tx_Byte; //input to uarttx from outfifo's read port output
input outfifo_empty; //flag from outfifo
input transmit_en; //switch from user
input out_clk, rst;


//
//uarttx
wire i_Clock; //input
reg i_Tx_DV; //input
//reg[7:0] i_Tx_Byte; //input
//wire o_Tx_Active;
//wire o_Tx_Serial;
wire o_Tx_Done;

defparam uarttx.CLK_FREQ_FPGA=CLK_FREQ_FPGA, uarttx.BAUDRATE=BAUDRATE;
uart_transmitter1 uarttx(i_Clock, i_Tx_DV, i_Tx_Byte, o_Tx_Active, o_Tx_Serial, o_Tx_Done);

assign i_Clock = out_clk;  
assign transmit_Ready = o_Tx_Done | outfifo_empty;
//controller
reg[2:0] ps,ns;
parameter INIT=2'd0, CLRREAD=2'd1, TXMIT2=2'd2;
always@(posedge out_clk)
begin
  if(!rst)
  begin
    i_Tx_DV<=0;
    ps<=0;
  end
  else
  begin
    i_Tx_DV<=outfifo_rden;
    ps<=ns;
  end
end

always@(*)
begin
  case(ps)
    INIT: begin
            ns = transmit_en ? CLRREAD : INIT;
            outfifo_rden = transmit_en ? 1 : 0;
          end
    CLRREAD: begin
            ns = TXMIT2;
            outfifo_rden = 0;
          end           
    TXMIT2: begin
            ns = o_Tx_Done ? (outfifo_empty ? INIT : CLRREAD) : ps;
            outfifo_rden = o_Tx_Done ? (outfifo_empty ? 0 : 1) : 0;
          end          
    default: begin
               ns=0;
               outfifo_rden=0;
          end
  endcase
end
endmodule
