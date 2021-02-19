function retval = bin2str (q)
  retval = "";
  for i = q
    retval = strcat(retval,num2str(i));
  endfor
endfunction