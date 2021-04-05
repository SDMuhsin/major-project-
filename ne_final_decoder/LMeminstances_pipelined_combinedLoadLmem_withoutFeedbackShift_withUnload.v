
//write result of Layer0 to fifoq and read via mux in Layer1 pattern:
defparam lmemcirc_01_0.w=W, lmemcirc_01_0.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ0_scripted lmemcirc_01_0(lmem_data_out_0to1[0], lmem_data_in[0], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_1.w=W, lmemcirc_01_1.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ1_scripted lmemcirc_01_1(lmem_data_out_0to1[1], lmem_data_in[1], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_2.w=W, lmemcirc_01_2.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ2_scripted lmemcirc_01_2(lmem_data_out_0to1[2], lmem_data_in[2], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_3.w=W, lmemcirc_01_3.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ3_scripted lmemcirc_01_3(lmem_data_out_0to1[3], lmem_data_in[3], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_4.w=W, lmemcirc_01_4.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ4_scripted lmemcirc_01_4(lmem_data_out_0to1[4], lmem_data_in[4], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_5.w=W, lmemcirc_01_5.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ5_scripted lmemcirc_01_5(lmem_data_out_0to1[5], lmem_data_in[5], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_6.w=W, lmemcirc_01_6.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ6_scripted lmemcirc_01_6(lmem_data_out_0to1[6], lmem_data_in[6], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_7.w=W, lmemcirc_01_7.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ7_scripted lmemcirc_01_7(lmem_data_out_0to1[7], lmem_data_in[7], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_8.w=W, lmemcirc_01_8.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ8_scripted lmemcirc_01_8(lmem_data_out_0to1[8], lmem_data_in[8], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_9.w=W, lmemcirc_01_9.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ9_scripted lmemcirc_01_9(lmem_data_out_0to1[9], lmem_data_in[9], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_10.w=W, lmemcirc_01_10.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ10_scripted lmemcirc_01_10(lmem_data_out_0to1[10], lmem_data_in[10], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_11.w=W, lmemcirc_01_11.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ11_scripted lmemcirc_01_11(lmem_data_out_0to1[11], lmem_data_in[11], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_12.w=W, lmemcirc_01_12.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ12_scripted lmemcirc_01_12(lmem_data_out_0to1[12], lmem_data_in[12], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_13.w=W, lmemcirc_01_13.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ13_scripted lmemcirc_01_13(lmem_data_out_0to1[13], lmem_data_in[13], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_14.w=W, lmemcirc_01_14.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ14_scripted lmemcirc_01_14(lmem_data_out_0to1[14], lmem_data_in[14], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);
defparam lmemcirc_01_15.w=W, lmemcirc_01_15.maxVal=maxVal; //lmemcirc_01_
LMem0To1_511_circ15_scripted lmemcirc_01_15(lmem_data_out_0to1[15], lmem_data_in[15], wr_en0to1, rd_address_0to1, rd_en0to1, clk,rst);


//load new codesymbols in load pattern to fifoq OR write result of Layer1 to fifoq and read via mux in Layer0 pattern, if unload enabled, read HD data via mux in Unload pattern:
defparam lmemcirc_10_0.w=W, lmemcirc_10_0.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ0_combined_ns_yu_pipelined_scripted lmemcirc_10_0(unload_HDout[0],unload_en,unloadAddress, lmem_data_out_1to0[0], lmem_data_in[0], lmem_loaddata_in[0], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_1.w=W, lmemcirc_10_1.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ1_combined_ns_yu_pipelined_scripted lmemcirc_10_1(unload_HDout[1],unload_en,unloadAddress, lmem_data_out_1to0[1], lmem_data_in[1], lmem_loaddata_in[1], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_2.w=W, lmemcirc_10_2.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ2_combined_ns_yu_pipelined_scripted lmemcirc_10_2(unload_HDout[2],unload_en,unloadAddress, lmem_data_out_1to0[2], lmem_data_in[2], lmem_loaddata_in[2], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_3.w=W, lmemcirc_10_3.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ3_combined_ns_yu_pipelined_scripted lmemcirc_10_3(unload_HDout[3],unload_en,unloadAddress, lmem_data_out_1to0[3], lmem_data_in[3], lmem_loaddata_in[3], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_4.w=W, lmemcirc_10_4.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ4_combined_ns_yu_pipelined_scripted lmemcirc_10_4(unload_HDout[4],unload_en,unloadAddress, lmem_data_out_1to0[4], lmem_data_in[4], lmem_loaddata_in[4], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_5.w=W, lmemcirc_10_5.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ5_combined_ns_yu_pipelined_scripted lmemcirc_10_5(unload_HDout[5],unload_en,unloadAddress, lmem_data_out_1to0[5], lmem_data_in[5], lmem_loaddata_in[5], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_6.w=W, lmemcirc_10_6.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ6_combined_ns_yu_pipelined_scripted lmemcirc_10_6(unload_HDout[6],unload_en,unloadAddress, lmem_data_out_1to0[6], lmem_data_in[6], lmem_loaddata_in[6], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_7.w=W, lmemcirc_10_7.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ7_combined_ns_yu_pipelined_scripted lmemcirc_10_7(unload_HDout[7],unload_en,unloadAddress, lmem_data_out_1to0[7], lmem_data_in[7], lmem_loaddata_in[7], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_8.w=W, lmemcirc_10_8.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ8_combined_ns_yu_pipelined_scripted lmemcirc_10_8(unload_HDout[8],unload_en,unloadAddress, lmem_data_out_1to0[8], lmem_data_in[8], lmem_loaddata_in[8], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_9.w=W, lmemcirc_10_9.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ9_combined_ns_yu_pipelined_scripted lmemcirc_10_9(unload_HDout[9],unload_en,unloadAddress, lmem_data_out_1to0[9], lmem_data_in[9], lmem_loaddata_in[9], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_10.w=W, lmemcirc_10_10.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ10_combined_ns_yu_pipelined_scripted lmemcirc_10_10(unload_HDout[10],unload_en,unloadAddress, lmem_data_out_1to0[10], lmem_data_in[10], lmem_loaddata_in[10], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_11.w=W, lmemcirc_10_11.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ11_combined_ns_yu_pipelined_scripted lmemcirc_10_11(unload_HDout[11],unload_en,unloadAddress, lmem_data_out_1to0[11], lmem_data_in[11], lmem_loaddata_in[11], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_12.w=W, lmemcirc_10_12.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ12_combined_ns_yu_pipelined_scripted lmemcirc_10_12(unload_HDout[12],unload_en,unloadAddress, lmem_data_out_1to0[12], lmem_data_in[12], lmem_loaddata_in[12], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_13.w=W, lmemcirc_10_13.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ13_combined_ns_yu_pipelined_scripted lmemcirc_10_13(unload_HDout[13],unload_en,unloadAddress, lmem_data_out_1to0[13], lmem_data_in[13], lmem_loaddata_in[13], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
//load new codesymbols in load pattern to fifoq OR write result of Layer1 to fifoq and read via mux in Layer0 pattern, without unload mux:
defparam lmemcirc_10_14.w=W, lmemcirc_10_14.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ14_combined_ns_yu_pipelined_scripted lmemcirc_10_14( lmem_data_out_1to0[14], lmem_data_in[14], lmem_loaddata_in[14], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);
defparam lmemcirc_10_15.w=W, lmemcirc_10_15.maxVal=maxVal; //lmemcirc_1_
LMem1To0_511_circ15_combined_ns_yu_pipelined_scripted lmemcirc_10_15( lmem_data_out_1to0[15], lmem_data_in[15], lmem_loaddata_in[15], loaden, firstiter, wr_en1to0, rd_address_1to0, rd_en1to0, clk,rst);