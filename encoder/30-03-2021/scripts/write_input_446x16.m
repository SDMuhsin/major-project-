function retval = write_input_446x16 ( a, Lm = 16)
  assert( floor(size(a)(2)/Lm), ceil(size(a)(2)/Lm));
  as = bin2str(a);
  
  fid = fopen("outputs/inp_446x16.txt","wt");
  
  for i = 1:Lm:size(a)(2)
    as(i:i+Lm-1)
    fprintf(fid, "%s\n", flip( as(i:i+Lm-1) , 2 ) );
  endfor
  
  fclose(fid);
endfunction