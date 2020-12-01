circSize = 511;
filename = sprintf("DMem%dScripted.txt",circSize);
fid = fopen (filename, "a");
fprintf(fid,sprintf("module LMem%dScripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t reaccessAddress,\n\t\t clk,rst \n );\n",circSize));


M= 511;
%h=zeros(2*M,16*M);
%table from ccsds for nearearthLDPC
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
%H matrix construction
ro=0;
h=[];
hloc=[];
for h_row=1:2
  hlyr = [];
  hlyrloc=[];
  for h_col=1:16
    ro = ro+1;
    firstrow = zeros(1,M);
    firstrow(1,circulantsLUT(ro,1)+1) = 1;
    firstrow(1,circulantsLUT(ro,2)+1) = 1;
    A = makecirculant(firstrow,M);
    hlyr = [hlyr,A];
    %Location finding
    Aloc = func_makecirculantlocations((circulantsLUT(ro,1:2)+1),M,M);
    hlyrloc=[hlyrloc,Aloc];      
  end
  h = [h;hlyr];
  %Locations
  hloc = [hloc;hlyrloc];
end

%exact loc adding 511 offsets
h_exactloc = zeros(size(hloc));
for lyr=1:2
  for irow=1+(lyr-1)*511:511+(lyr-1)*511
    for circ=1:16
      wtc1 = 2*circ - 1;
      wtc2 = 2*circ;
      offset=511*(circ-1);
      h_exactloc(irow,wtc1)=hloc(irow,wtc1)+offset;
      h_exactloc(irow,wtc2)=hloc(irow,wtc2)+offset;
    end
  end
end

p = 26;
rowsPerLayer = 511;
layersCount = 2;
blocksCount = 16;
offsetsPerCircCount = 2;

% -- GENERATE ADDRESS TABLE -- %
%addressTableRows = layersCount * ceil( M / p);
%addressTableColumns = blocksCount * offsetsPerCircCount * p;

%addressTable = zeros(addressTableRows,addressTableColumns);
%for ly = 1:layersCount
%  hl = h( (ly-1) * M  + 1: ly*M , :);
%  for slice = 1:1:addressTableRows/2
%    
%    sliceStart = 1 + p*(slice -1);
%    sliceEnd = slice * p;
%    
%    if sliceEnd > 511
%      sliceEnd = 511;  
%    endif
%    addressTable( (ly-1)*addressTableRows/2 + slice, :) = iloc(hl(sliceStart:sliceEnd,:),p,blocksCount,1);
%    
%  endfor
%endfor

%layer_1=addressTable(1:20,:);
%layer_2=addressTable(21:40,:);

%------------addressTable------------------------------------------%
diagloc=[];
M=511;
P=26;
for i=1:1022
  diagloc = [diagloc;(find(h(i,:)!=0))];
end
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


%-------------------------------------------------------------------%
%layer 0
[im,jm]=size(layer_1);
second_re=[];

for j = 1:1:jm
for i = 1:1:im
    for k = i+1:1:im
      if(length(find(layer_1(i,j)==layer_1(k,:)))!=0)
        second_re(i,j)=-1;
        break
      else
        second_re(i,j)=layer_1(i,j);
      end
    endfor
endfor
endfor
second_re(20,:)=layer_1(20,:);

%layer 1
second_re_1=[];

for j = 1:1:jm
for i = 1:1:im
    for k = i+1:1:im
      if(length(find(layer_2(i,j)==layer_2(k,:)))!=0)
      second_re_1(i,j)=-1;
      break
    else
      second_re_1(i,j)=layer_2(i,j);
    end
    endfor
endfor
endfor

second_re_1(20,:)=layer_2(20,:);

fid = fopen("lmem_write.txt",'a'); 
printtxt=sprintf('`timescale 1ns / 1ps\n');
fprintf(fid,'%c',transpose(printtxt));  


printtxt=sprintf('module project_17(lwren,lin,lout,load_din,siso_lout,wren,load_en,wraddress,wrlayer);\n');
fprintf(fid,'%c',transpose(printtxt));  
prt=sprintf("parameter W=6;\n");
fprintf(fid,'%c',transpose(prt)); 
prt=sprintf("output reg lwren;\n");
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("output reg [(8176*W)-1:0] lin;\n");
fprintf(fid,'%c',transpose(prt)); 
prt=sprintf("\n");
fprintf(fid,'%c',transpose(prt));
 
prt=sprintf("input [(8176*W)-1:0] lout;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("input [(8176*W)-1:0] load_din;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("input [(832*W)-1:0] siso_lout;\n");
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("input wren,load_en;\n");
fprintf(fid,'%c',transpose(prt));   
prt=sprintf("input [4:0]wraddress;\n");
fprintf(fid,'%c',transpose(prt)); 
prt=sprintf("input wrlayer;\n");
fprintf(fid,'%c',transpose(prt));

prt=sprintf("reg [4:0]lwraddresscase;\n");
fprintf(fid,'%c',transpose(prt)); 
prt=sprintf("reg lwrlayercase;\n");
fprintf(fid,'%c',transpose(prt)); 

prt=sprintf("always@(*) begin\n");
fprintf(fid,'%c',transpose(prt)); 
prt=sprintf(" if(load_en)\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("begin\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf(" lwrlayercase=1'b0;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf(" lwraddresscase=5'b11111;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf(" end\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("else\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("begin\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf(" lwrlayercase=wrlayer;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf(" lwraddresscase=wraddress;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf(" end\n");
fprintf(fid,'%c',transpose(prt));

prt= sprintf("case({lwrlayercase,lwraddresscase})\n");
fprintf(fid,'%c',transpose(prt));

%case layer 0
for cycles=1:1:20
  rd_address=dec2bin(cycles-1,5);
  prt= sprintf("6'b%c%s:",'0',rd_address);
  fprintf(fid,'%c',transpose(prt));
  prt=sprintf("begin\n");
  fprintf(fid,'%c',transpose(prt));
  for row=1:1:8176
    if(length(find(row==second_re(cycles,:)))!=0)
  %script
  ind=find(row==second_re(cycles,:));
  prt= sprintf("lin[%d*W-1:%d*W]=siso_lout[%d*W-1:%d*W];\n",row,row-1,ind,ind-1);
  fprintf(fid,'%c',transpose(prt));
  lin(row)=0;%26x2x16 values..llrout(find(row==second_re(cycles,:)))
    else
  %script
  prt= sprintf("lin[%d*W-1:%d*W]=lout[%d*W-1:%d*W];\n",row,row-1,row,row-1);
  fprintf(fid,'%c',transpose(prt));
  lin(row)=-1;%lout(row);
    end
  endfor
  prt=sprintf("lwren=wren;\n");
  fprintf(fid,'%c',transpose(prt));
  prt=sprintf("end\n");
  fprintf(fid,'%c',transpose(prt));
endfor


prt= sprintf("6'b011111:");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("begin\n");
fprintf(fid,'%c',transpose(prt));
prt= sprintf("lin=load_din;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("lwren=load_en;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("end\n");
fprintf(fid,'%c',transpose(prt));
  
  
%case layer 1
for cycles=1:1:20
  rd_address=dec2bin(cycles-1,5);
  prt= sprintf("6'b%c%s:",'1',rd_address);
  fprintf(fid,'%c',transpose(prt));
  prt=sprintf("begin\n");
  fprintf(fid,'%c',transpose(prt));
  for row=1:1:8176
    if(length(find(row==second_re_1(cycles,:)))!=0)
  %script
  ind=find(row==second_re_1(cycles,:));
  prt= sprintf("lin[%d*W-1:%d*W]=siso_lout[%d*W-1:%d*W];\n",row,row-1,ind,ind-1);
  fprintf(fid,'%c',transpose(prt));
      lin(row)=0;%26x2 values..llrout(find(row==second_re_1(cycles,:)))
    else
  %script
  prt= sprintf("lin[%d*W-1:%d*W]=lout[%d*W-1:%d*W];\n",row,row-1,row,row-1);
  fprintf(fid,'%c',transpose(prt));
      lin(row)=-1;%lout(row);
    end
  endfor
  prt=sprintf("lwren=wren;\n");
  fprintf(fid,'%c',transpose(prt));
  prt=sprintf("end\n");
  fprintf(fid,'%c',transpose(prt));
endfor

prt= sprintf("default:");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("begin\n");
fprintf(fid,'%c',transpose(prt));
prt= sprintf("lin=0;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("lwren=0;\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("end\n");
fprintf(fid,'%c',transpose(prt));

prt=sprintf("endcase\n");
fprintf(fid,'%c',transpose(prt));
prt=sprintf("end\n");
fprintf(fid,'%c',transpose(prt));

printtxt=sprintf('endmodule\n');
fprintf(fid,'%c',transpose(printtxt));  
fclose(fid);
