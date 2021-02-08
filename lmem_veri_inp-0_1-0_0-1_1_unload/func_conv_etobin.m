
function retval = func_conv_etobin (e)
  if(size(e)(2) ~= 35)
    fprintf("ASSERTION ERROR, size of E is not 35\m");
  endif
  if(min(e) < 0)
    fprintf("ASSERTION ERROR, E has negative values\m");
  endif
  
  e_1_bin = func_conv_symbol2bin(e(1:3),5);
  e_2_bin = bin2str(e(4:end),1);
  if( size(e_1_bin)(2) ~= 15)
    fprintf("ASSERTION ERROR, e_1_bin is not 15 characters long\m");
    e_1_bin
  endif
  if( size(e_2_bin)(2) ~= 32)
    fprintf("ASSERTION ERROR, e_2_bin is not 32 characters long\n");
    e(4:end)
    e_2_bin
  endif
  retval = strcat(e_1_bin,e_2_bin);
endfunction
