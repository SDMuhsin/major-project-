`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 13:56:11
// Design Name: 
// Module Name: acc_synth_tb
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
// Test bench design
//////////////////////////////////////////////////////////////////////////////////


module acc_synth_tb();
parameter W=6;
parameter Wc=4;
//inmem
//parameter WIDTH=4;
//parameter DEPTH=16;
//parameter ADDRESSWIDTH = 4;

// Non-configurable
parameter DEPTH=10;
parameter ADDRESSWIDTH=4;
parameter DW=Wc*W;
parameter READDEFAULTCASE=2**ADDRESSWIDTH;//maximum adress value

  // Testbench uses a 10 MHz clock
  // Want to interface to 115200 baud UART
  // 10000000 / 115200 = 87 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 100; //1/10MHz = 100ns
  parameter c_CLKS_PER_BIT    = 87; //10MHz = 1,00,00,000 Hz / 115200 = 87
  parameter c_BIT_PERIOD      = 8600;//
  

//wire valid; //output//signal write to out fifo
//wire[(Wc*W)-1:0] y;//output
////reg [(Wc*W)-1:0] x;//input
//wire [(Wc*W)-1:0] x;//input
//reg en;
//reg clk, rst;//input

////inmem
////wire[WIDTH-1:0] read_dout;
////reg[ADDRESSWIDTH-1:0] rd_address, wr_address;
////reg[WIDTH-1:0] write_din;
////reg rd_en, wr_en;

////test stimulus ROM
//wire[DW-1:0] dout;
//reg [ADDRESSWIDTH-1:0] rd_address;
//wire rd_en;

////outmem
//wire[DW-1:0] outmem_read_dout;
//reg[ADDRESSWIDTH-1:0] outmem_rd_address, outmem_wr_address;
//reg[DW-1:0] outmem_write_din;
//reg outmem_rd_en, outmem_wr_en;

////uarttx
//reg i_Clock;
//reg i_Tx_DV;
//reg[7:0] i_Tx_Byte; 
//wire o_Tx_Active;
//wire o_Tx_Serial;

 // wire o_Tx_Done;
  wire o_Tx_Active;
  wire o_Tx_Serial;
  wire outfifo_full;
  wire locked;
  wire in_clk;
  wire out_clk;
  wire transmit_Ready;  
  reg allrst;
  reg clk_in1;
  reg start;
 // reg srst;
  reg transmit_en;
//  input allrst;
//  input clk_in1;
//  output o_Tx_Active;
//  output o_Tx_Serial;
//  output outfifo_full;
//  input start;
//  output transmit_Ready;
//  input transmit_en;

//uart_rx
   
  reg r_Clock = 0;
  reg r_Tx_DV = 0;
  wire w_Tx_Done;
  reg [7:0] r_Tx_Byte = 0;
  //reg r_Rx_Serial = 1;
    wire r_Rx_Serial;
  wire [7:0] w_Rx_Byte;
  
//other
reg stop_en;

uarttx_outfifo_design_wrapper dut
   (allrst,
    clk_in1,
    in_clk,
    locked,
    o_Tx_Active,
    o_Tx_Serial,
    out_clk,
    outfifo_full,
    start,
    transmit_Ready,
    transmit_en);

  uart_receiver1 #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
    (.i_Clock(out_clk),
     .i_Rx_Serial(o_Tx_Serial),
     .o_Rx_DV(),
     .o_Rx_Byte(w_Rx_Byte)
     );
     
//interconnections:
//assign rd_en=en;
//assign x = dout;


//always
//#1 clk=~clk;

parameter CLK_PER=10; //1 / 100MHz = 10ns
// Tin_clk=1/20MHz=50ns (5x Tclk_in1), Tout_clk=1/10MHz=100ns = (10x Tclk_in1)
always
#(CLK_PER/2) clk_in1=~clk_in1;

//initial
//begin
//clk=0; rst=0;  en=0; rd_address=0; //x=0;
//@(posedge clk);
//@(posedge clk) rst=1;
//@(posedge clk)  en=1; rd_address=0;//x={4'd3,4'd3,4'd3,4'd3};
//@(posedge clk) en=1; rd_address=1;//x={4'd0,4'd0,4'd0,4'd0}; 
//@(posedge clk) en=0; rd_address=2;//x=0; 
//@(posedge clk);
//@(posedge clk) $finish;
//end

initial
begin
clk_in1=0; allrst=0;start=0;transmit_en=0; stop_en=0;
//@(posedge locked);
//repeat(5*10) @(posedge clk_in1);//wait for 10 cycles of slowest clock, 100ns =10 cycles of 10ns clock(clk_in1)
@(posedge clk_in1);
@(posedge clk_in1) allrst=1;
@(posedge locked);
repeat(5*10) @(posedge clk_in1);//wait 10x 100ns
repeat(5) @(posedge clk_in1); @(negedge clk_in1) start=1; //wait 50ns and give start
repeat(5) @(posedge clk_in1); @(negedge clk_in1) start=0; //clear start after 50ns

repeat((DEPTH)*5) @(posedge clk_in1);//wait DEPTH times inclk cycles (till all ROM stimulus is given)

repeat(10) @(posedge clk_in1); @(negedge clk_in1) transmit_en=1; //wait 100ns and give transmit_en
repeat(10) @(posedge clk_in1); @(negedge clk_in1) transmit_en=0; //clear transmit_en after 1 cycle.

@(posedge out_clk) stop_en=1;
//repeat(DEPTH*2) @(posedge o_Tx_Done); //wait till all symbols are sent to uart tx

end

always@(posedge transmit_Ready)
begin
  if(stop_en) begin
    repeat (3) @(posedge out_clk);
    if(transmit_Ready!=0) begin
      repeat(10) @(posedge out_clk);
      $finish;
    end
    end
  end

endmodule
