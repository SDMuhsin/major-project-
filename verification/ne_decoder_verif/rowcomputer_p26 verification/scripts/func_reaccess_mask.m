
function reaccess_mask = func_reaccess_mask (hlut)
    # Input : 1022 x 32
    # Output: 1022 x 32 with 1s for first access, 2s for second access
    
    symbol_list = zeros(1,8176);
    #Partition hlut by layers
    hlut_l1 = hlut(1:511,:);
    hlut_l2 = hlut(1+511:511+511,:);
    hlut_partitioned = zeros( 511, 32,2);
    
    hlut_partitioned(:,:,1) = hlut_l1;
    hlut_partitioned(:,:,2) = hlut_l2;
    
    hlutp = hlut_partitioned;
    
    size(hlut_partitioned)
    reaccess_mask = zeros(size(hlutp));
    
    for ly = 1:1:size(hlutp)(3)
       symbol_access_count = zeros(1,511*16);
       for r = 1:1:size(hlutp)(1)
         for c = 1:1:size(hlutp)(2)
          if( symbol_access_count(hlutp(r,c,ly)) == 0)
            symbol_access_count(hlutp(r,c,ly)) = 1;
            reaccess_mask(r,c,ly) = 1;
          else
            symbol_access_count(hlutp(r,c,ly)) = 2;
            reaccess_mask(r,c,ly) = 2;
          endif
          
         endfor
       endfor
    endfor
    r = zeros(511*2,32);
    r(1:511,:) = reaccess_mask(:,:,1);
    r(1+511:511+511,:) = reaccess_mask(:,:,2);
    reaccess_mask = r;
    
endfunction
