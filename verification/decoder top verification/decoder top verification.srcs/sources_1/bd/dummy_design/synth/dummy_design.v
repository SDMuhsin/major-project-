//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Fri Feb 26 19:14:08 2021
//Host        : Sdmuhsin running 64-bit major release  (build 9200)
//Command     : generate_target dummy_design.bd
//Design      : dummy_design
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "dummy_design,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=dummy_design,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "dummy_design.hwdef" *) 
module dummy_design
   (clk,
    in_1,
    o_Tx_Serial);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN dummy_design_clk, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk;
  input [191:0]in_1;
  output o_Tx_Serial;

  wire clk_1;
  wire dumy_gen_32_0_datavalid;
  wire [7:0]dumy_gen_32_0_out;
  wire [7:0]fifo_generator_0_dout;
  wire [191:0]in_1_1;
  wire uart_transmitter1_0_o_Tx_Serial;

  assign clk_1 = clk;
  assign in_1_1 = in_1[191:0];
  assign o_Tx_Serial = uart_transmitter1_0_o_Tx_Serial;
  dummy_design_dumy_gen_32_0_0 dumy_gen_32_0
       (.clk(clk_1),
        .datavalid(dumy_gen_32_0_datavalid),
        .in(in_1_1),
        .out(dumy_gen_32_0_out),
        .rst(1'b0));
  dummy_design_fifo_generator_0_0 fifo_generator_0
       (.clk(clk_1),
        .din(dumy_gen_32_0_out),
        .dout(fifo_generator_0_dout),
        .rd_en(1'b0),
        .srst(1'b0),
        .wr_en(dumy_gen_32_0_datavalid));
  dummy_design_uart_transmitter1_0_0 uart_transmitter1_0
       (.i_Clock(clk_1),
        .i_Tx_Byte(fifo_generator_0_dout),
        .i_Tx_DV(dumy_gen_32_0_datavalid),
        .o_Tx_Serial(uart_transmitter1_0_o_Tx_Serial));
endmodule
