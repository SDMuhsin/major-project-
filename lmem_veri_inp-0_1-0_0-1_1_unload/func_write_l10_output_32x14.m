


function retval = func_write_l10_output_32x14 (cdwrd,blocks=16)
  # Get pattern from unloadRequestMap_mymod
  # for block = 1:16, unload_map_i : 17 x 32
  # we want : unload_map  : 17 x (32 * 16)
    len=8176;

  p = unloadRequestMap_mymod(1)
 

  #layerAddressMap_mymod(layerAddressMap_mymod<0)=-8176;
  for i = 2:1:14
    f=unloadRequestMap_mymod(i)
    f(f<=0)=-10000;
    p = [p, f+(i-1)*511];
  endfor
  
  pattern=p
size(pattern)(2);
  #Convert this to symbol list_in_columns
  symbols = zeros(size(pattern));
  for r = 1:1:size(pattern)(1)
      
      for c = 1:1:size(pattern)(2)
        if((pattern(r,c) > 0)&&pattern(r,c) < 7155)
          symbols(r,c) = cdwrd(pattern(r,c));
        else
          symbols(r,c) = 7.75;
        endif
      endfor
  endfor
  symbols=flip(symbols,2);
  # Write this to file in structure 17x(32*16)
  filename = sprintf("./outputs/output_codeword_17x32x14x1.txt");
  fiddd = fopen(filename,"w");  
  for s = 1:1:size(symbols)(1)
      symbols_to_write = symbols(s,:);
      symbols_in_bin_str = func_conv_symbol2bin_out(symbols_to_write,1);
      fprintf(fiddd,"%s\n",symbols_in_bin_str);
      

  endfor
  fclose(fiddd);
endfunction
