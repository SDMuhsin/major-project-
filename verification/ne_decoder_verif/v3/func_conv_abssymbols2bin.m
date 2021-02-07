function retval = func_conv_abssymbols2bin (e)
  e_2 = zeros(size(e));
  # 0 -> 7.75
  # 00000 -> 11111 : 0 to 32
  #fprintf("e before = %d %d ",e(1),e(2));
  a = 0:0.25:7.75;
  b = 0:1:31;
  assert(size(a)(2),size(b)(2));
  for i = 1:1:size(e)(2)
    for j = 1:1:size(a)(2)
      if(e(i) == a(j))
        e_2(i) = b(j);
      endif
    endfor
  endfor
  
  retval = "";
  
  for i = e_2
    
    retval =  strcat(retval,dec2bin(i,5));  
  endfor
  #fprintf(" e = %d %d  %s\n",e_2(1),e_2(2),retval);
endfunction
