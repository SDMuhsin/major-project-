`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 22:53:17
// Design Name: 
// Module Name: stimulus_DUT_cover
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


module stimulus_DUT_cover(outfiforst, outpvalid, y, start, in_clk, rst);
parameter W=8;
parameter Wc=4;

// Non-configurable
parameter DEPTH=10;
parameter ADDRESSWIDTH=4;
parameter DW=Wc*W;
parameter READDEFAULTCASE=(2**ADDRESSWIDTH)-1;//maximum adress value

output outfiforst;
output outpvalid; //output//signal write to out fifo
output[(Wc*W)-1:0] y;//output
input start;
input in_clk, rst;

wire [(Wc*W)-1:0] x;//input
wire inpvalid;

//test stimulus ROM
//wire[DW-1:0] dout;
//wire[ADDRESSWIDTH-1:0] rd_address;
//wire rd_en;

//stimulus controller
wire [ADDRESSWIDTH-1:0] rom_rd_address;
wire rd_en;

defparam inpcontroller.DEPTH=DEPTH, inpcontroller.ADDRESSWIDTH=ADDRESSWIDTH;
stimuluscontroller inpcontroller(rom_rd_address, rd_en, start, in_clk, rst);

acctest_stimulus_ROM stimulusLUT(x, rom_rd_address, rd_en);

defparam dut.W=W, dut.Wc=Wc;
accumulator dut( outpvalid, y, x, inpvalid, in_clk, rst);


//interconnections:
assign inpvalid=rd_en;

assign outfiforst=~rst;

endmodule
