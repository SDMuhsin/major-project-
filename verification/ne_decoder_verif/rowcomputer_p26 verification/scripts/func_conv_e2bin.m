function retval = func_conv_e2bin (e)
  if(size(e)(2) ~= 35)
    fprintf("ASSERTION ERROR, size of E is not 35\n");
  endif
  
  e(3) = e(3) -1 ;
  if(e(3) < 0)
    fprintf("ASSERTION ERROR e(3) < 0\n" );
    e(3)
  endif
  for i = e(1:2)
      if(i < 0)
        fprintf("ASSERTION ERROR e(1:2) < 0\n" );  
      endif
  endfor
  assert(size(func_conv_abssymbols2bin(e(1:2)))(2),10);
  
  
  e_1_bin = [func_conv_abssymbols2bin(e(1:2)), dec2bin(e(3),5)];
  
  e_2_bin = bin2str(e(4:end),1);
  if( size(e_1_bin)(2) ~= 15)
    fprintf("ASSERTION ERROR, e_1_bin is not 15 characters long\n");
    e_1_bin
  endif
  if( size(e_2_bin)(2) ~= 32)
    fprintf("ASSERTION ERROR, e_2_bin is not 32 characters long\n");
    e(4:end)
    e_2_bin
  endif
  retval = strcat(e_1_bin, flip(e_2_bin,2));
endfunction