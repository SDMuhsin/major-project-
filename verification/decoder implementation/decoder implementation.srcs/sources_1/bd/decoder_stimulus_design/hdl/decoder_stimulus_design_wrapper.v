//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sun Feb 28 18:37:34 2021
//Host        : Sdmuhsin running 64-bit major release  (build 9200)
//Command     : generate_target decoder_stimulus_design_wrapper.bd
//Design      : decoder_stimulus_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decoder_stimulus_design_wrapper
   (default_250mhz_clk1_clk_n,
    default_250mhz_clk1_clk_p,
    full,
    o_Tx_Active,
    o_Tx_Serial,
    reset,
    start,
    transmit_Ready,
    transmit_en);
  input default_250mhz_clk1_clk_n;
  input default_250mhz_clk1_clk_p;
  output full;
  output o_Tx_Active;
  output o_Tx_Serial;
  input reset;
  input start;
  output transmit_Ready;
  input transmit_en;

  wire default_250mhz_clk1_clk_n;
  wire default_250mhz_clk1_clk_p;
  wire full;
  wire o_Tx_Active;
  wire o_Tx_Serial;
  wire reset;
  wire start;
  wire transmit_Ready;
  wire transmit_en;

  decoder_stimulus_design decoder_stimulus_design_i
       (.default_250mhz_clk1_clk_n(default_250mhz_clk1_clk_n),
        .default_250mhz_clk1_clk_p(default_250mhz_clk1_clk_p),
        .full(full),
        .o_Tx_Active(o_Tx_Active),
        .o_Tx_Serial(o_Tx_Serial),
        .reset(reset),
        .start(start),
        .transmit_Ready(transmit_Ready),
        .transmit_en(transmit_en));
endmodule
