
function r = func_saturate(r,u=7.75,l=-8)
  
  r(r>u) = u;
  r(r<l) = l;
endfunction
