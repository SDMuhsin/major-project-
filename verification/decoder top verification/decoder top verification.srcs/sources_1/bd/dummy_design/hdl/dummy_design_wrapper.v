//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Fri Feb 26 19:14:09 2021
//Host        : Sdmuhsin running 64-bit major release  (build 9200)
//Command     : generate_target dummy_design_wrapper.bd
//Design      : dummy_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module dummy_design_wrapper
   (clk,
    in_1,
    o_Tx_Serial);
  input clk;
  input [191:0]in_1;
  output o_Tx_Serial;

  wire clk;
  wire [191:0]in_1;
  wire o_Tx_Serial;

  dummy_design dummy_design_i
       (.clk(clk),
        .in_1(in_1),
        .o_Tx_Serial(o_Tx_Serial));
endmodule
