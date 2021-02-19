function [second_acc0,second_acc1]=reaccess_slice()
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
for col=1:1:32  %1:1:32 for layer_0,33:1:64 for layer_1
%  for off=1:1:2
    for ro=1:1:511
      if(mod(off_re_2(col)+ro-1,511)!=0)
      off_arr=[off_arr;(mod(off_re_2(col)+ro-1,511)+(cir-1)*511)];
    else
      off_arr=[off_arr;((cir)*511)];
    endif
    
    endfor
%  endfor
  off_arr_fin=[off_arr_fin,off_arr];
  off_arr=[];
  if(mod(col,2)==0)
    cir=cir+1;
  endif
endfor

off_arr=[];
off_arr_fin_2=[];
cir=1;
for col=33:1:64 %1:1:32 for layer_0,33:1:64 for layer_1
%  for off=1:1:2
    for ro=1:1:511
      if(mod(off_re_2(col)+ro-1,511)!=0)
      off_arr=[off_arr;(mod(off_re_2(col)+ro-1,511)+(cir-1)*511)];
    else
      off_arr=[off_arr;((cir)*511)];
    endif
    
    endfor
%  endfor
  off_arr_fin_2=[off_arr_fin_2,off_arr];
  off_arr=[];
  if(mod(col,2)==0)
    cir=cir+1;
  endif
endfor
offset_indices=[off_arr_fin;off_arr_fin_2];

M=511;
P=26;
diagloc=offset_indices;
address = transpose([1:ceil(M/P)]-1);
[im,jm]=size(diagloc);
re=diagloc(1:511,:);
re_2=diagloc(512:1022,:);
%diag_=[];
layer_1=[];
layer_2=[];
if(mod(M,P)!=0)
for i=1:1:9
  re=[re;repmat(0,[1 32])];
  re_2=[re_2;repmat(0,[1 32])];
end
end


for k=1:1:ceil(M/P)
  layer_1(k,:)=reshape(re((k-1)*P+1:k*P,:)',[1,jm*P]);
  layer_2(k,:)=reshape(re_2((k-1)*P+1:k*P,:)',[1,jm*P]);
end

[im,jm]=size(layer_1);
second_acc0=[];

for j = 1:1:jm
for i = 1:1:im
    for k = i+1:1:im
      if(length(find(layer_1(i,j)==layer_1(k,:)))!=0)
        second_acc0(i,j)=-1;
        break
      else
        second_acc0(i,j)=layer_1(i,j);
      end
    endfor
endfor
endfor
second_acc0(20,:)=layer_1(20,:);

[im,jm]=size(layer_2);
second_acc1=[];

for j = 1:1:jm
for i = 1:1:im
    for k = i+1:1:im
      if(length(find(layer_2(i,j)==layer_2(k,:)))!=0)
        second_acc1(i,j)=-1;
        break
      else
        second_acc1(i,j)=layer_2(i,j);
      end
    endfor
endfor
endfor
second_acc1(20,:)=layer_2(20,:);
endfunction