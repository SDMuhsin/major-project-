function mat = makecirculant(firstrow,num_rows);
   %circulantsize: size of circulant say 32x32, then 32.
   rowtemp =firstrow; %32by32 subcirculant's first row
   circulantsize = length(firstrow);
   mat1=zeros(num_rows,circulantsize);
   mat1(1,:) = rowtemp;
   for ij=2:num_rows
      rowtemp = [rowtemp(1,circulantsize),rowtemp(1,1:(circulantsize-1))];
      mat1(ij,:) = rowtemp;
   end
   mat = mat1;
end