function retval = func_write_rcu_input_52xn (cdwrd,blocks = 16)
  # Print ly0 pattern, one line = 1x(26*2*16) 6 bit symbols
  ly = 1;
  p = layerAddressMap_mymod(1)(:,:,ly);
  size(p)
  for i = 2:1:blocks
    p = [p, layerAddressMap_mymod(i)(:,:,ly)];
  endfor
  
  pattern = p;
  # address to symbols
  symbols = zeros(size(pattern));
  for r = 1:1:size(pattern)(1)
      
      for c = 1:1:size(pattern)(2)
        if(pattern(r,c) > 0)
          symbols(r,c) = cdwrd(pattern(r,c));
        elseif
          symbols(r,c) = 0;
        endif
      endfor
  endfor
  
  # Write this to file in structure 20x(26*2*16)
  filename = sprintf("./outputs/input_codeword_20x26x2x16.txt");
  fid = fopen(filename,"wt");  
  for s = 1:1:size(symbols)(1)
      symbols_to_write = symbols(s,:);
      symbols_in_bin_str = func_conv_symbol2bin(symbols_to_write);
      fprintf(fid,"%s\n",symbols_in_bin_str);
      

  endfor
  fclose(fid);
endfunction
