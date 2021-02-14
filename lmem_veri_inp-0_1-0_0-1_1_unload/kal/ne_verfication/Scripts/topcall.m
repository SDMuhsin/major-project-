
MODE = 0

if(MODE == 0)
  c1 = randi(1,1,8176) -1;
  c1 = func_saturate( func_quantizer(c1 + 2*randn(1,8176)));
  c1(1:18) = 7.75 * ones(1,18);
  
  rowcomputer_verif;
else
  clear flip;
  comp;
endif