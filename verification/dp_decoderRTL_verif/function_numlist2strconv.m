function str = function_numlist2strconv(numlist)
  str=[];
  for i=1:length(numlist) 
    if(numlist(i)==0) 
      str=[str,'0']; 
    else 
      str=[str,'1'] ;
    end 
  end
  
end
