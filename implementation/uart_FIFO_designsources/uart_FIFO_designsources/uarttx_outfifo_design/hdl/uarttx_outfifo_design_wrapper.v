//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sat Feb 27 14:45:35 2021
//Host        : Sdmuhsin running 64-bit major release  (build 9200)
//Command     : generate_target uarttx_outfifo_design_wrapper.bd
//Design      : uarttx_outfifo_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module uarttx_outfifo_design_wrapper
   (default_250mhz_clk1_0_clk_n,
    default_250mhz_clk1_0_clk_p,
    in_clk,
    locked,
    o_Tx_Active,
    o_Tx_Serial,
    out_clk,
    outfifo_full,
    reset,
    start,
    transmit_Ready,
    transmit_en);
  input default_250mhz_clk1_0_clk_n;
  input default_250mhz_clk1_0_clk_p;
  output in_clk;
  output locked;
  output o_Tx_Active;
  output o_Tx_Serial;
  output out_clk;
  output outfifo_full;
  input reset;
  input start;
  output transmit_Ready;
  input transmit_en;

  wire default_250mhz_clk1_0_clk_n;
  wire default_250mhz_clk1_0_clk_p;
  wire in_clk;
  wire locked;
  wire o_Tx_Active;
  wire o_Tx_Serial;
  wire out_clk;
  wire outfifo_full;
  wire reset;
  wire start;
  wire transmit_Ready;
  wire transmit_en;

  uarttx_outfifo_design uarttx_outfifo_design_i
       (.default_250mhz_clk1_0_clk_n(default_250mhz_clk1_0_clk_n),
        .default_250mhz_clk1_0_clk_p(default_250mhz_clk1_0_clk_p),
        .in_clk(in_clk),
        .locked(locked),
        .o_Tx_Active(o_Tx_Active),
        .o_Tx_Serial(o_Tx_Serial),
        .out_clk(out_clk),
        .outfifo_full(outfifo_full),
        .reset(reset),
        .start(start),
        .transmit_Ready(transmit_Ready),
        .transmit_en(transmit_en));
endmodule
