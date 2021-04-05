function retval = bin2str (a)
  s = "";
  as = num2str(a);
  for i = 1:1:size(as)(2)
    s = strcat(s,as(i));
  endfor
  
  retval = s;
endfunction
