
function [pattern,symbols] = func_write_l10_input_32x16 (cdwrd,fn = "input_codeword_17x32x16.txt",blocks=16)
  # Get pattern from unloadRequestMap_mymod
  # for block = 1:16, unload_map_i : 17 x 32
  # we want : unload_map  : 17 x (32 * 16)
    len=8176;

  load_mem = loadMemAddressMap();
    load_mem(load_mem<0)=-8176;
  pattern = load_mem(:,:,1);
  
  for i = 2:1:size(load_mem)(3)
    pattern = [pattern, load_mem(:,:,i)+(i-1)*511];
  endfor
  pattern(pattern<=0) = -1;
size(pattern)(2)
  #Convert this to symbol list_in_columns
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
  #pattern = flip(pattern,2);
  symbols=flip(symbols,2);
  # Write this to file in structure 17x(32*16)
  filename = sprintf( strcat( "./outputs/", fn) );
  fid = fopen(filename,"w");  
  for s = 1:1:size(symbols)(1)
      symbols_to_write = symbols(s,:);
      symbols_in_bin_str = func_conv_symbol2bin(symbols_to_write);
      fprintf(fid,"%s\n",symbols_in_bin_str);
      
 
  endfor
  fclose(fid);
endfunction