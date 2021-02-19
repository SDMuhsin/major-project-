function [min_1,min_2,min_1_pos] = func_module_minfinder (abs_q)
  # Input : 1 x 32 positive integers
  # Output : min_1, min_2, min_1_pos : All integers
  
  min_1 = 99;
  min_2 = 99;
  min_1_pos = -1;
  flag=0;
  for i = 1:1:size(abs_q)(2)
    if(abs_q(i) <= min_1)
      min_2 = min_1;
      min_1 = abs_q(i);
   #   min_1_pos = i;
    endif
  endfor
  for i = 1:1:size(abs_q)(2)
    if(abs_q(i) <= min_2&& abs_q(i) > min_1)
      min_2 = abs_q(i);
   #   min_1 = abs_q(i);
   #   min_1_pos = i;
    endif
  endfor
  [im,jm]=size(abs_q);
  for i = 1:1:size(abs_q)(2)
    if(abs_q(jm-i+1) == min_1)
      #min_2 = min_1;
      #min_1 = abs_q(i);
       min_1_pos = jm-i+1;
    endif
  endfor
endfunction

