m = unloadRequestMap_mymod(1);
for i = 2:1:14
    mt = unloadRequestMap_mymod(i);
    mt(mt<=0) =  - 8177;
    m = [m,mt+(i-1)*511];
endfor
m = flip(m,2);