#{
function retval = func_write_rcu_output_52xn (cdwrd,blocks = 16)
  
 # Print ly0 pattern, one line = 1x(26*2*16) 6 bit symbols
  ly = 1;
  p = layerAddressMap_mymod(1)(:,:,ly);
  size(p)

  #layerAddressMap_mymod(layerAddressMap_mymod<0)=-8176;
  for i = 2:1:blocks
    f=layerAddressMap_mymod(i)(:,:,ly);
    f(f<=0)=-8176;
    p = [p, f+(i-1)*511];
  endfor
  
  

  pattern = p;
  # address to symbols
  symbols = zeros(size(pattern));
  for r = 1:1:size(pattern)(1)
      
      for c = 1:1:size(pattern)(2)
        if((pattern(r,c) > 0))
          symbols(r,c) = cdwrd(pattern(r,c));
        else
          symbols(r,c) = 7.75;
 
        endif
      endfor
  endfor
    symbols=flip(symbols,2);
  # Write this to file in structure 20x(26*2*16)
  filename = sprintf("./outputs/output_codeword_20x26x2x16_t2.txt");
  fiddd = fopen(filename,"wt");  
  for s = 1:1:size(symbols)(1)
      symbols_to_write = symbols(s,:);
      symbols_in_bin_str = func_conv_symbol2bin(symbols_to_write);
      fprintf(fiddd,"%s\n",symbols_in_bin_str);
      

  endfor
  fclose(fiddd);
endfunction
#}
function [pattern,symbols] = func_write_rcu_output_52xn (cdwrd,blocks = 16)
  
circSize=511;
circulantsLUT=[0, 176 0, 176;
12, 239 523, 750;
0, 352 1022, 1374;
24, 431 1557, 1964;
0, 392 2044, 2436;
151, 409 2706, 2964;
0, 351 3066, 3417;
9, 359 3586, 3936;
0, 307 4088, 4395;
53, 329 4652, 4928;
0, 207 5110, 5317;
18, 281 5639, 5902;
0, 399 6132, 6531;
202, 457 6845, 7100;
0, 247 7154, 7401;
36, 261 7701, 7926;
99, 471 99, 471;
130, 473 641, 984;
198, 435 1220, 1457;
260, 478 1793, 2011;
215, 420 2259, 2464;
282, 481 2837, 3036;
48, 396 3114, 3462;
193, 445 3770, 4022;
273, 430 4361, 4518;
302, 451 4901, 5050;
96, 379 5206, 5489;
191, 386 5812, 6007;
244, 467 6376, 6599;
364, 470 7007, 7113;
51, 382 7205, 7536;
192, 414 7857, 8079];

offsets=circulantsLUT(:,3:4);
offsets=offsets+1;
off_re=reshape(offsets,[64,1])';
off_re_1=reshape(offsets,[32,2])';
off_re_2=reshape(off_re_1,[64,1]);
off_arr=[];
off_arr_fin=[];
cir=1;
for col=1:1:32
%  for off=1:1:2
    for ro=1:1:511
      off_arr=[off_arr;(mod(off_re_2(col)+ro-1,511)+(cir-1)*511)];
    endfor
%  endfor
  off_arr_fin=[off_arr_fin,off_arr];
  off_arr=[];
  if(mod(col,2)==0)
    cir=cir+1;
  endif
endfor

M=511;
P=26;
diagloc=off_arr_fin;
address = transpose([1:ceil(M/P)]-1);
[im,jm]=size(diagloc);
re=diagloc(1:511,:);
%re_2=diagloc(512:1022,:);
%diag_=[];
layer_1=[];
%layer_2=[];
if(mod(M,P)!=0)
for i=1:1:9
  re=[re;repmat(0,[1 32])];
  %re_2=[re_2;repmat(0,[1 32])];
end
end


for k=1:1:ceil(M/P)
  layer_1(k,:)=reshape(re((k-1)*P+1:k*P,:)',[1,jm*P]);
  %layer_2(k,:)=reshape(re_2((k-1)*P+1:k*P,:)',[1,jm*P]);
end

[im,jm]=size(layer_1);
second_re=[];

pattern=layer_1;
  
  
  
  
  # address to symbols
  symbols = zeros(size(pattern));
  for r = 1:1:size(pattern)(1)
      
      for c = 1:1:size(pattern)(2)
        if(pattern(r,c) > 0)
          symbols(r,c) = cdwrd(pattern(r,c));
        elseif
          symbols(r,c) = 7.75;
        endif
      endfor
  endfor
    symbols=flip(symbols,2);
  # Write this to file in structure 20x(26*2*16)
  filename = sprintf("./outputs/output_codeword_20x26x2x16.txt");
  fid = fopen(filename,"wt");  
  for s = 1:1:size(symbols)(1)
      
      symbols_to_write = symbols(s,:);
      symbols_in_bin_str = func_conv_symbol2bin(symbols_to_write);
      fprintf(fid,"%s\n",symbols_in_bin_str);
      

  endfor
  fclose(fid);
endfunction
