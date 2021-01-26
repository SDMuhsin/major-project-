
function tg = func_conv_symbol2bin (symbols, w = 6)
  # This should convert to 2's compliment representation that we use
  # We can expect that the symbols are already quantized...
  # Output should be a single string ...
  # MSB to the left.. 1 => 000001
  
  tg = "";
  for i = 1:1:size(symbols)(2)
    t = "";
    
    # -8 to -0.25 = 100000 to 111111 = 32 to 32+31
    neg = -8:0.25:-0.25;
    neg_bin_dec = 32:1:32+31;
    
    #0 to 7.75 = 000000 to 011111 = 0 to 31
    pos = 0:0.25:7.75;
    pos_bin_dec = 0:1:31;
    
    #Assert sanity
    if( size(pos) ~= size(pos_bin_dec) || size(neg) ~= size(neg_bin_dec))
      fprintf("[conv symbol to binary] ERROR size(neg) ~= size(neg_bin_dec)");
    endif 
    
    if(symbols(i) < 0)
      
      for j = 1:1:size(neg)(2)
        if(neg(j) == symbols(i))
          t = dec2bin( neg_bin_dec(j), w );
        endif
      endfor
    else
      for j = 1:1:size(pos)(2)
        if(pos(j) == symbols(i))
          t = dec2bin( pos_bin_dec(j), w );
        endif
      endfor
    endif
      
    
    
    tg = strcat(tg,t);
  endfor
endfunction
