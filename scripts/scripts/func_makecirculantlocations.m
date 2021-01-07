function ones_location_matrix = func_makecirculantlocations(firstrowlocations,circulantsize,num_rows)  
   %inputs
##   num_rows=z;
##   circulantsize=z;   
   shiftlist =firstrowlocations;
   
   numshifts = length(shiftlist); 
   %output
   mat1 = zeros(num_rows,numshifts);
   
   for ij=1:numshifts
      coltemp=mod([shiftlist(ij):1:circulantsize+shiftlist(ij)-1],circulantsize);
      coltemp(coltemp==0)=circulantsize;
      mat1(:,ij) = transpose(coltemp);
   end
   ones_location_matrix = mat1;
end