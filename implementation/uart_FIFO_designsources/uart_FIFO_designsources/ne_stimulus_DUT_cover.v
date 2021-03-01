`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.02.2021 16:02:58
// Design Name: 
// Module Name: ne_stimulus_DUT_cover
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


module ne_stimulus_DUT_cover(outfiforst, outpvalid, y, start, in_clk, clk, out_clk, rst);
parameter W=6;
parameter Wc=32;
parameter HDDW=32;

// Non-configurable
parameter DEPTH=257;//(8160+64)/32
parameter ADDRESSWIDTH=9;//ceil(log2(DEPTH))
parameter DW=Wc*W;
parameter READDEFAULTCASE=(2**ADDRESSWIDTH)-1;//maximum adress value
//parameter READDEFAULTCASE=9'b1_1111_1111;

output outfiforst;
output outpvalid; //output//signal write to out fifo
output[(HDDW)-1:0] y;//output
input start;
input in_clk, clk, out_clk, rst;

wire [(Wc*W)-1:0] x;//input
wire inpvalid;

//test stimulus ROM
wire[DW-1:0] dout;
//wire[ADDRESSWIDTH-1:0] rd_address;
//wire rd_en;

//stimulus controller
wire [ADDRESSWIDTH-1:0] rom_rd_address;
wire rd_en;

defparam inpcontroller.DEPTH=DEPTH, inpcontroller.ADDRESSWIDTH=ADDRESSWIDTH;
stimuluscontroller inpcontroller(rom_rd_address, rd_en, start, in_clk, rst);

ne_testcodestimulusROM stimulusLUT(dout, rom_rd_address, rd_en);
//acctest_stimulus_ROM stimulusLUT(x, rom_rd_address, rd_en);

defparam dut.W=W, dut.Wc=Wc;
//accumulator dut( outpvalid, y, x, inpvalid, in_clk, rst);

wire datavalid;
assign outpvalid = datavalid;
ne_decoder_top_pipeV3 dut(datavalid, y, dout, inpvalid, in_clk, clk, out_clk, rst);

//interconnections:
assign inpvalid=rd_en;

assign outfiforst=~rst;

endmodule
