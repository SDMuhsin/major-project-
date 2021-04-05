function outmat = gf2toint(mat)
%  "in gf2toint"
    for i=1:size(mat,1)
        for j=1:size(mat,2)
           if(mat(i,j) == 0)
               outmat(i,j) = 0;
           else
               outmat(i,j) =1;
           end
        end
    end
%    "exit gf2toint"
end