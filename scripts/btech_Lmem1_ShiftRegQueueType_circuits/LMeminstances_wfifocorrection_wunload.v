
//write result of Layer0 to fifoq and read via mux in Layer1 pattern:
defparam lmemcirc_0_0.w=W; //lmemcirc_0_0.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ0_scripted lmemcirc_0_0(lmem_data_out_0[0], lmem_data_in[0], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_1.w=W; //lmemcirc_0_1.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ1_scripted lmemcirc_0_1(lmem_data_out_0[1], lmem_data_in[1], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_2.w=W; //lmemcirc_0_2.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ2_scripted lmemcirc_0_2(lmem_data_out_0[2], lmem_data_in[2], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_3.w=W; //lmemcirc_0_3.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ3_scripted lmemcirc_0_3(lmem_data_out_0[3], lmem_data_in[3], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_4.w=W; //lmemcirc_0_4.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ4_scripted lmemcirc_0_4(lmem_data_out_0[4], lmem_data_in[4], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_5.w=W; //lmemcirc_0_5.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ5_scripted lmemcirc_0_5(lmem_data_out_0[5], lmem_data_in[5], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_6.w=W; //lmemcirc_0_6.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ6_scripted lmemcirc_0_6(lmem_data_out_0[6], lmem_data_in[6], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_7.w=W; //lmemcirc_0_7.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ7_scripted lmemcirc_0_7(lmem_data_out_0[7], lmem_data_in[7], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_8.w=W; //lmemcirc_0_8.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ8_scripted lmemcirc_0_8(lmem_data_out_0[8], lmem_data_in[8], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_9.w=W; //lmemcirc_0_9.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ9_scripted lmemcirc_0_9(lmem_data_out_0[9], lmem_data_in[9], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_10.w=W; //lmemcirc_0_10.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ10_scripted lmemcirc_0_10(lmem_data_out_0[10], lmem_data_in[10], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_11.w=W; //lmemcirc_0_11.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ11_scripted lmemcirc_0_11(lmem_data_out_0[11], lmem_data_in[11], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_12.w=W; //lmemcirc_0_12.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ12_scripted lmemcirc_0_12(lmem_data_out_0[12], lmem_data_in[12], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_13.w=W; //lmemcirc_0_13.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ13_scripted lmemcirc_0_13(lmem_data_out_0[13], lmem_data_in[13], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_14.w=W; //lmemcirc_0_14.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ14_scripted lmemcirc_0_14(lmem_data_out_0[14], lmem_data_in[14], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);
defparam lmemcirc_0_15.w=W; //lmemcirc_0_15.r=P*Wt; //addresswidth is constant at 5.
LMem0To1_511_circ15_scripted lmemcirc_0_15(lmem_data_out_0[15], lmem_data_in[15], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);


//write result of Layer1 to fifoq and read via mux in Layer0 pattern, if unload enabled, read HD data via mux in Unload pattern:
defparam lmemcirc_1_0.w=W; //lmemcirc_1_0.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ0_scripted lmemcirc_1_0(unload_HDout[0],unload_en,unloadAddress, lmem_data_out_1[0], lmem_data_in[0], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_1.w=W; //lmemcirc_1_1.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ1_scripted lmemcirc_1_1(unload_HDout[1],unload_en,unloadAddress, lmem_data_out_1[1], lmem_data_in[1], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_2.w=W; //lmemcirc_1_2.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ2_scripted lmemcirc_1_2(unload_HDout[2],unload_en,unloadAddress, lmem_data_out_1[2], lmem_data_in[2], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_3.w=W; //lmemcirc_1_3.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ3_scripted lmemcirc_1_3(unload_HDout[3],unload_en,unloadAddress, lmem_data_out_1[3], lmem_data_in[3], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_4.w=W; //lmemcirc_1_4.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ4_scripted lmemcirc_1_4(unload_HDout[4],unload_en,unloadAddress, lmem_data_out_1[4], lmem_data_in[4], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_5.w=W; //lmemcirc_1_5.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ5_scripted lmemcirc_1_5(unload_HDout[5],unload_en,unloadAddress, lmem_data_out_1[5], lmem_data_in[5], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_6.w=W; //lmemcirc_1_6.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ6_scripted lmemcirc_1_6(unload_HDout[6],unload_en,unloadAddress, lmem_data_out_1[6], lmem_data_in[6], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_7.w=W; //lmemcirc_1_7.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ7_scripted lmemcirc_1_7(unload_HDout[7],unload_en,unloadAddress, lmem_data_out_1[7], lmem_data_in[7], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_8.w=W; //lmemcirc_1_8.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ8_scripted lmemcirc_1_8(unload_HDout[8],unload_en,unloadAddress, lmem_data_out_1[8], lmem_data_in[8], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_9.w=W; //lmemcirc_1_9.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ9_scripted lmemcirc_1_9(unload_HDout[9],unload_en,unloadAddress, lmem_data_out_1[9], lmem_data_in[9], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_10.w=W; //lmemcirc_1_10.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ10_scripted lmemcirc_1_10(unload_HDout[10],unload_en,unloadAddress, lmem_data_out_1[10], lmem_data_in[10], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_11.w=W; //lmemcirc_1_11.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ11_scripted lmemcirc_1_11(unload_HDout[11],unload_en,unloadAddress, lmem_data_out_1[11], lmem_data_in[11], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_12.w=W; //lmemcirc_1_12.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ12_scripted lmemcirc_1_12(unload_HDout[12],unload_en,unloadAddress, lmem_data_out_1[12], lmem_data_in[12], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_13.w=W; //lmemcirc_1_13.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ13_scripted lmemcirc_1_13(unload_HDout[13],unload_en,unloadAddress, lmem_data_out_1[13], lmem_data_in[13], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
//write result of Layer1 to fifoq and read via mux in Layer0 pattern, without unload mux:
defparam lmemcirc_1_14.w=W; //lmemcirc_1_14.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ14_scripted lmemcirc_1_14(lmem_data_out_1[14], lmem_data_in[14], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);
defparam lmemcirc_1_15.w=W; //lmemcirc_1_15.r=P*Wt; //addresswidth is constant at 5.
LMem1To0_511_wunload_circ15_scripted lmemcirc_1_15(lmem_data_out_1[15], lmem_data_in[15], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);


//write fresh data in Load pattern to fifoq and read via mux in Layer0 pattern:
defparam lmemloadtolyr0_0.w=W;// lmemloadtolyr0_0.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_0 lmemloadtolyr0_0(lmem_data_out_init[0], lmem_loaddata_in[0], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_1.w=W;// lmemloadtolyr0_1.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_1 lmemloadtolyr0_1(lmem_data_out_init[1], lmem_loaddata_in[1], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_2.w=W;// lmemloadtolyr0_2.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_2 lmemloadtolyr0_2(lmem_data_out_init[2], lmem_loaddata_in[2], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_3.w=W;// lmemloadtolyr0_3.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_3 lmemloadtolyr0_3(lmem_data_out_init[3], lmem_loaddata_in[3], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_4.w=W;// lmemloadtolyr0_4.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_4 lmemloadtolyr0_4(lmem_data_out_init[4], lmem_loaddata_in[4], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_5.w=W;// lmemloadtolyr0_5.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_5 lmemloadtolyr0_5(lmem_data_out_init[5], lmem_loaddata_in[5], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_6.w=W;// lmemloadtolyr0_6.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_6 lmemloadtolyr0_6(lmem_data_out_init[6], lmem_loaddata_in[6], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_7.w=W;// lmemloadtolyr0_7.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_7 lmemloadtolyr0_7(lmem_data_out_init[7], lmem_loaddata_in[7], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_8.w=W;// lmemloadtolyr0_8.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_8 lmemloadtolyr0_8(lmem_data_out_init[8], lmem_loaddata_in[8], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_9.w=W;// lmemloadtolyr0_9.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_9 lmemloadtolyr0_9(lmem_data_out_init[9], lmem_loaddata_in[9], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_10.w=W;// lmemloadtolyr0_10.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_10 lmemloadtolyr0_10(lmem_data_out_init[10], lmem_loaddata_in[10], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_11.w=W;// lmemloadtolyr0_11.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_11 lmemloadtolyr0_11(lmem_data_out_init[11], lmem_loaddata_in[11], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_12.w=W;// lmemloadtolyr0_12.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_12 lmemloadtolyr0_12(lmem_data_out_init[12], lmem_loaddata_in[12], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_13.w=W;// lmemloadtolyr0_13.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_13 lmemloadtolyr0_13(lmem_data_out_init[13], lmem_loaddata_in[13], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_14.w=W;// lmemloadtolyr0_14.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_14 lmemloadtolyr0_14(lmem_data_out_init[14], lmem_loaddata_in[14], rd_address_0, loaden, rd_enloadto0, clk,rst);
defparam lmemloadtolyr0_15.w=W;// lmemloadtolyr0_15.r=P*Wt; //addresswidth is constant at 5.
InputQueueCirc_15 lmemloadtolyr0_15(lmem_data_out_init[15], lmem_loaddata_in[15], rd_address_0, loaden, rd_enloadto0, clk,rst);