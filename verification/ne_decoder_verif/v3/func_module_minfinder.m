function [min_1,min_2,min_1_pos] = func_module_minfinder (abs_q)
  # Input : 1 x 32 positive integers
  # Output : min_1, min_2, min_1_pos : All integers
  
  min_1 = min(abs_q);
  min_2 = 99;
  min_1_pos = -1;
  
  a = [];
  flag = 0;
  for i = 1:1:size(abs_q)(2)
    if(abs_q(i) == min_1 && ~flag)
      min_1_pos = i;
      flag = 1;
    else 
      a = [ a, abs_q(i)];
    endif
  endfor
  assert(size(a)(2),size(abs_q)(2)-1);
  min_2 = min(a);
endfunction

