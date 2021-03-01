//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sun Feb 28 18:37:34 2021
//Host        : Sdmuhsin running 64-bit major release  (build 9200)
//Command     : generate_target decoder_stimulus_design.bd
//Design      : decoder_stimulus_design
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "decoder_stimulus_design,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=decoder_stimulus_design,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "decoder_stimulus_design.hwdef" *) 
module decoder_stimulus_design
   (default_250mhz_clk1_clk_n,
    default_250mhz_clk1_clk_p,
    full,
    o_Tx_Active,
    o_Tx_Serial,
    reset,
    start,
    transmit_Ready,
    transmit_en);
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_250mhz_clk1 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_250mhz_clk1, CAN_DEBUG false, FREQ_HZ 250000000" *) input default_250mhz_clk1_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_250mhz_clk1 CLK_P" *) input default_250mhz_clk1_clk_p;
  output full;
  output o_Tx_Active;
  output o_Tx_Serial;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset;
  input start;
  output transmit_Ready;
  input transmit_en;

  wire clk_wiz_0_clk;
  wire clk_wiz_0_clk_out4;
  wire clk_wiz_0_in_clk;
  wire clk_wiz_0_locked;
  wire clk_wiz_0_out_clk;
  wire default_250mhz_clk1_1_CLK_N;
  wire default_250mhz_clk1_1_CLK_P;
  wire [7:0]fifo_generator_0_dout;
  wire fifo_generator_0_empty;
  wire fifo_generator_0_full;
  wire ne_stimulus_DUT_cover_0_outfiforst;
  wire ne_stimulus_DUT_cover_0_outpvalid;
  wire [31:0]ne_stimulus_DUT_cover_0_y;
  wire outfifo_uarttx_contr_0_o_Tx_Active;
  wire outfifo_uarttx_contr_0_o_Tx_Serial;
  wire outfifo_uarttx_contr_0_outfifo_rden;
  wire outfifo_uarttx_contr_0_transmit_Ready;
  wire reset_1;
  wire start_1;
  wire transmit_en_1;

  assign default_250mhz_clk1_1_CLK_N = default_250mhz_clk1_clk_n;
  assign default_250mhz_clk1_1_CLK_P = default_250mhz_clk1_clk_p;
  assign full = fifo_generator_0_full;
  assign o_Tx_Active = outfifo_uarttx_contr_0_o_Tx_Active;
  assign o_Tx_Serial = outfifo_uarttx_contr_0_o_Tx_Serial;
  assign reset_1 = reset;
  assign start_1 = start;
  assign transmit_Ready = outfifo_uarttx_contr_0_transmit_Ready;
  assign transmit_en_1 = transmit_en;
  decoder_stimulus_design_clk_wiz_0_0 clk_wiz_0
       (.clk(clk_wiz_0_clk),
        .clk_in1_n(default_250mhz_clk1_1_CLK_N),
        .clk_in1_p(default_250mhz_clk1_1_CLK_P),
        .clk_out4(clk_wiz_0_clk_out4),
        .in_clk(clk_wiz_0_in_clk),
        .locked(clk_wiz_0_locked),
        .out_clk(clk_wiz_0_out_clk),
        .reset(reset_1));
  decoder_stimulus_design_fifo_generator_0_0 fifo_generator_0
       (.clk(clk_wiz_0_clk_out4),
        .din(ne_stimulus_DUT_cover_0_y),
        .dout(fifo_generator_0_dout),
        .empty(fifo_generator_0_empty),
        .full(fifo_generator_0_full),
        .rd_en(outfifo_uarttx_contr_0_outfifo_rden),
        .srst(ne_stimulus_DUT_cover_0_outfiforst),
        .wr_en(ne_stimulus_DUT_cover_0_outpvalid));
  decoder_stimulus_design_ne_stimulus_DUT_cover_0_0 ne_stimulus_DUT_cover_0
       (.clk(clk_wiz_0_clk),
        .in_clk(clk_wiz_0_in_clk),
        .out_clk(clk_wiz_0_out_clk),
        .outfiforst(ne_stimulus_DUT_cover_0_outfiforst),
        .outpvalid(ne_stimulus_DUT_cover_0_outpvalid),
        .rst(clk_wiz_0_locked),
        .start(start_1),
        .y(ne_stimulus_DUT_cover_0_y));
  decoder_stimulus_design_outfifo_uarttx_contr_0_0 outfifo_uarttx_contr_0
       (.i_Tx_Byte(fifo_generator_0_dout),
        .o_Tx_Active(outfifo_uarttx_contr_0_o_Tx_Active),
        .o_Tx_Serial(outfifo_uarttx_contr_0_o_Tx_Serial),
        .out_clk(clk_wiz_0_clk_out4),
        .outfifo_empty(fifo_generator_0_empty),
        .outfifo_rden(outfifo_uarttx_contr_0_outfifo_rden),
        .rst(clk_wiz_0_locked),
        .transmit_Ready(outfifo_uarttx_contr_0_transmit_Ready),
        .transmit_en(transmit_en_1));
endmodule
