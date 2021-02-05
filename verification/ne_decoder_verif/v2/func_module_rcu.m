function [l_out,e_out,d_out] = func_module_rcu ( l_in, e_in, d_in)
  
  # Inputs
  #   e_in : [ min_1 1x1, min_2 1x1, min_1_pos 1x1, signs (1x32) ]
  #   l_in : 1x32 int
  #   d_in : 1x32 int
  
  # Outputs
  #   e_out : same as above
  #   l_out :      "
  #   d_out :      "
  
  fname = ""
  
  rec_1_out = func_module_recover(e_in);
  q = func_saturate( l_in - rec_1_out)
  [ abs_q, sign_q] = func_module_absoluter(q);
  [m1,m2,m1_pos] = func_module_minfinder(abs_q);
  e_out = [m1,m2,m1_pos,sign_q];
  rec_2_out = func_module_recover(e_out);
  l_out = func_saturate( rec_2_out + d_in + q);
  d_out = func_saturate( rec_2_out - rec_1_out);
  
endfunction
