
function retval = func_write_cdwrd_1x8176 (cdwrd)
  filename = sprintf("./outputs/input_codeword_1x8176.txt");
  fid = fopen(filename,"wt");  
  
  fprintf(fid,"%s", func_conv_symbol2bin( func_saturate(cdwrd) ));
  fclose(fid);
endfunction
