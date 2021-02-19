function q = func_quantizer (r,u=7.75,l=-8,step=0.25)
  q = step * floor(r/step);
  q(q>u) = u;
  q(q<l) = l;
endfunction
