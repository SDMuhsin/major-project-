function alt_deg = chkapproxtriangle(givmat5)
  count1=0;
for kw = length(givmat5(1,:)):-1:1
  if(givmat5(1,kw) == 0)
    count1 = count1+1;
  else
    break;
  end
end
count1;
  for ri2 = 2:rows(givmat5)
    
   if(count1 >=1)
      givrow2 = givmat5(ri2,:);
      givrow2(1,(end-count1+1):end);
      eye(1,count1);
      if(givrow2(1,(end-count1+1):end) == eye(1,count1))
         trdeg2 = 0;
      else
         trdeg2 = -(nnz(givrow2(1,(end-count1+1):end)));
      end
      alt_deg(ri2,1) = trdeg2;
   end
   count1 = count1 - 1;
 end   
end