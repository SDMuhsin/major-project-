function [abs_q,sign_q] = func_module_absoluter (q)
  # Input : 1x32 integers
  # Output  
  #      1. abs_q 1x32 positive integers
  #      2. sign_q 1x32 bitset
  
  abs_q = func_saturate( abs( q));
  sign_q = zeros(1,32);
  sign_q(q<0) = 1;
  
  #I am flippinf the signs here itself
  flip = sign_q(1);
  for i = 2:1:size(sign_q)(2)
      flip = xor(flip,sign_q);
  endfor
  if(flip)
    sign_q = xor(sign_q,1);
  endif
endfunction
