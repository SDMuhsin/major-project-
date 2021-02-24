
function retval = func_write_unload_17x448 (c1)
  m = unloadRequestMap_mymod(1);
  for i = 2:1:14
      mt = unloadRequestMap_mymod(i);
      mt(mt<=0) =  - 8177;
      m = [m,mt+(i-1)*511];
  endfor
  m(m<=0) = -1;
  retval = m;
  
  mc = zeros(size(m));
  for i = 1:1:size(m)(1)
      for j = 1:1:size(m)(2)
        
        if(m(i,j) == -1)
          mc(i,j) = 0;
        else
          if( c1( m(i,j) ) >= 0)
            mc(i,j) = 0;
          else
            mc(i,j) = 1;
          endif
          
        endif
        
      endfor
  endfor
  
  mc = flip(mc,2);
  fid = fopen("./outputs/unload_17x448.txt","wt");
  for i = 1:1:size(m)(1)
    for j = 1:1:size(m)(2)
      fprintf(fid,"%s", num2str(mc(i,j)));
    endfor
    fprintf(fid,"\n");
  endfor
  fclose(fid);
endfunction
