function basematrix = func_makebasematrix(hmatrix, circulantsize)
  [mb,nb] = size(hmatrix);
  b = circulantsize;
  M = mb/b;
  N = nb/b;
  basematrix = zeros(M,N);
  for rowindex = 1:M
    for colindex = 1:N
      submat = hmatrix((rowindex-1)*b+1:(rowindex*b),(colindex-1)*b+1:(colindex*b));
      
      if(submat == zeros(b,b)) %check if null matrix.
        shiftvalue = -1;
      else
        shiftvalue = find(submat(1,:))-1;
      end
      basematrix(rowindex,colindex) = shiftvalue;
    endfor
  endfor
  
endfunction
