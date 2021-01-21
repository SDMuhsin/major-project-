function outmat = gf2toint(givmatzxc)
##  "in gf2toint"
    for i=1:size(givmatzxc,1)
        for j=1:size(givmatzxc,2)
           if(givmatzxc(i,j) == 0)
               outmat(i,j) = 0;
           else
               outmat(i,j) =1;
           end
        end
    end
##    "exit gf2toint"
end