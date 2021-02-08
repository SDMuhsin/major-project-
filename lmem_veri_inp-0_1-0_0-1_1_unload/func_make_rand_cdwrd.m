
function c = func_make_rand_cdwrd (len)
  c= ones(1,len);
  c(randi(len,1,len)) = -1;
  c(c~= -1) = 1;
  
endfunction
