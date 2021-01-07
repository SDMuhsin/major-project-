clc
clear all
close all



%------------------------------%
% Prints Lmem instances
%------------------------------%
ver_instancelist_en=1

%printing instances for Lmem
if(ver_instancelist_en)
  
  filename = sprintf("./outputs/LMeminstances_wfifocorrection_wunload.v");
  fid = fopen (filename, "w");
  fprintf(fid,sprintf("\n//write result of Layer0 to fifoq and read via mux in Layer1 pattern:"));    
  for circ=1:16
    fprintf(fid,sprintf("\ndefparam lmemcirc_0_%d.w=W; //lmemcirc_0_%d.r=P*Wt; //addresswidth is constant at 5.",circ-1,circ-1));    
    fprintf(fid,sprintf("\nLMem0To1_511_circ%d_scripted lmemcirc_0_%d(lmem_data_out_0[%d], lmem_data_in[%d], wr_en0to1, rd_address_0, rd_en0to1, clk,rst);",circ-1,circ-1,circ-1,circ-1));    
    
  end
  fprintf(fid,sprintf("\n\n")); 
  fprintf(fid,sprintf("\n//write result of Layer1 to fifoq and read via mux in Layer0 pattern, if unload enabled, read HD data via mux in Unload pattern:"));    
  for circ=1:14
    fprintf(fid,sprintf("\ndefparam lmemcirc_1_%d.w=W; //lmemcirc_1_%d.r=P*Wt; //addresswidth is constant at 5.",circ-1,circ-1));    
    fprintf(fid,sprintf("\nLMem1To0_511_wunload_circ%d_scripted lmemcirc_1_%d(unload_HDout[%d],unload_en,unloadAddress, lmem_data_out_1[%d], lmem_data_in[%d], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);",circ-1,circ-1,circ-1,circ-1,circ-1));    
    
  end
  
  fprintf(fid,sprintf("\n//write result of Layer1 to fifoq and read via mux in Layer0 pattern, without unload mux:"));
  for circ=15:1:16
    fprintf(fid,sprintf("\ndefparam lmemcirc_1_%d.w=W; //lmemcirc_1_%d.r=P*Wt; //addresswidth is constant at 5.",circ-1,circ-1));    
    fprintf(fid,sprintf("\nLMem1To0_511_wunload_circ%d_scripted lmemcirc_1_%d(lmem_data_out_1[%d], lmem_data_in[%d], wr_en1to0, rd_address_1, rd_en1to0, clk,rst);",circ-1,circ-1,circ-1,circ-1));    
    
  end
  
    
  fprintf(fid,sprintf("\n\n")); 
  fprintf(fid,sprintf("\n//write fresh data in Load pattern to fifoq and read via mux in Layer0 pattern:"));    
  for circ=1:16
    fprintf(fid,sprintf("\ndefparam lmemloadtolyr0_%d.w=W;// lmemloadtolyr0_%d.r=P*Wt; //addresswidth is constant at 5.",circ-1,circ-1));    
    fprintf(fid,sprintf("\nInputQueueCirc_%d lmemloadtolyr0_%d(lmem_data_out_init[%d], lmem_loaddata_in[%d], rd_address_0, loaden, rd_enloadto0, clk,rst);",circ-1,circ-1,circ-1,circ-1));    
  end
  
  fclose(fid);
end