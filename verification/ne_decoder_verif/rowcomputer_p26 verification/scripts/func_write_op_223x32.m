
function retval = func_write_op_223x32 (c1)
  c2 = c1(19:7154);
  max(c2)
  min(c2)
  c2(c2>=0) = 0;
  c2(c2<0) = 1;
  
  assert(size(c2)(2),7136);
  
  fid = fopen("./outputs/op_223x32.txt","wt");
  for i = 1:32:7105
    c3 = c2(i:i+32-1);
    assert(size(c3)(2),32);
    for j = size( c3 )(2):-1:1
      fprintf(fid,"%s", num2str(c3(j)));
    endfor
    fprintf(fid,"\n");
  endfor
  fflush(fid);
  fclose(fid);
  retval = 1;
endfunction
