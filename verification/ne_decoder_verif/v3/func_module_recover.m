function e_uncompressed = func_module_recover (e_compressed)
  # e_compressed = min1  min2 min1index signs
  # Dimensions   =  5     5       6       32
  # matlab form  = int   int     int      bits ( 32 ints) 1x25
  # Example = [1,2,32, 0,0,1,1,1,...0]
  # Output = {int}^32
  min_1 = e_compressed(1);
  min_2 = e_compressed(2);
  min_1_index = e_compressed(3);
  
  signs = e_compressed(1,4:end);
  
  e_uncompressed = zeros(1,size(signs)(2));
  
  for i = 1:1:size(signs)(2)
    if(i == min_1_index)
      e_uncompressed(1,i) = min_2;
    else
      e_uncompressed(1,i) = min_1;
    endif
    
    if( signs(1,i) == 1)
      #fprintf("flipping sign \n");
      e_uncompressed(1,i) = - e_uncompressed(1,i);
    endif
  endfor
  
endfunction
