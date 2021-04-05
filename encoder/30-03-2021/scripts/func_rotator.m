function rotated = func_rotator(list, rotateamount, dir)
  if(rotateamount==0)
    rotated = list;
  else
    if(dir=='L')
      rotated = [list(1,rotateamount+1:end),list(1,1:rotateamount)];
    else
      rotated = [list(1,end-(rotateamount-1):end),list(1,1:end-rotateamount)];
    end
  end
end
