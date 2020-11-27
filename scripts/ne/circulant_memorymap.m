%circulant mareix partitioning to vectorised memory
clc
clear all
close all
%-----------------------%

%make 15x15 circulant of weight 2
offset1=0
offset2=6
M=15
circmat1=makecirculant([zeros(1,offset1),1,zeros(1,(M-offset1)-1)],M);
circmat2=makecirculant([zeros(1,offset2),1,zeros(1,(M-offset2)-1)],M);
circmat3=circmat1+circmat2;
offset1=4;
offset2=11;
circmat4=makecirculant([zeros(1,offset1),1,zeros(1,(M-offset1)-1)],M);
circmat5=makecirculant([zeros(1,offset2),1,zeros(1,(M-offset2)-1)],M);
circmat6=circmat4+circmat5;
circmat=[circmat3;circmat6];
[r,c] = size(circmat);
p=5;
Pdivcirc=ceil(M/p);
wccirc = sum(circmat(1,:)~=0);
circloc=zeros(r,wccirc);
for i=1:r%M
  circloc(i,:) = find(circmat(i,:)~=0);
end
diagloc=[];
for ri=1:r/M
  roi=((ri-1)*M)+1;
  firstrow=find(circmat(roi,:)~=0);
  diagloc=[diagloc;firstrow];
  for i=2:M%M
    colval=mod(firstrow+i-1,M);
    colval(colval==0) = M;
    diagloc = [diagloc;colval];
  end
end
ycirc1=zeros(p,wccirc,Pdivcirc);
rosetmat=[];
for j=1:Pdivcirc
  roset=[];
  ycirctemp=[];
  for i=1:p
    rowi=i+(j-1)*p;
    roset=[roset,rowi];
    if(rowi<=M)
      ycirctemp=[ycirctemp;circloc(rowi,:)];
    else
      ycirctemp=[ycirctemp;zeros(1,wccirc)];
    end
  end
  ycirc1(:,:,j)=ycirctemp;
  rosetmat=[rosetmat;roset];
end
ycirc2=zeros(p,wccirc,Pdivcirc);
rosetmat=[];
for j=1:Pdivcirc
  roset=[];
  ycirctemp=[];
  for i=1:p
    rowi=i+(j-1)*p+M;
    roset=[roset,rowi];
    if(rowi<=2*M)
      ycirctemp=[ycirctemp;circloc(rowi,:)];
    else
      ycirctemp=[ycirctemp;zeros(1,wccirc)];
    end
  end
  ycirc2(:,:,j)=ycirctemp;
  rosetmat=[rosetmat;roset];
end

row1=0;[row1,mod(([[1,177,257,433],[100,472,356,217]]-1)+row1,511)];
row1=40;[row1,mod(([[1,177,257,433],[100,472,356,217]]-1)+row1,511)];

%---Mem Map-----------------%
K=5; %p
memdepth1=ceil(15/K);%Pdivcirc
mem1 = zeros(memdepth1,K);

%taking circmat1, offset1
offset=6;
makecirculant([zeros(1,offset),1,zeros(1,(M-offset)-1)],M);
c=1 %starting row, no iterative order change

%parsing L[k] : L0 L1 till L14
for k=1:M
%k=1
%row= ( (k-c-offset) mod M )/K, col=( ( (k-c-offset)mod M) mod K)
addr_row = mod(((k-1)-(c-1)-offset),M);
%addr_row(addr_row==0) = M%correction
addr_row = floor(addr_row/K)+1;

addr_col = mod(((k-1)-(c-1)-offset),M);
%addr_col(addr_col==0) = M%correction
addr_col = mod(addr_col,K)+1;
%addr_col(addr_col==0) = K%correction
mem1(addr_row,addr_col) = k;
end
mem1;
%----------------%

%---Mem Map 4x4 circulant-----------------%
K=1; %p
M=4;
WT=2;
memdepth1=ceil(4/K);%Pdivcirc
mem2 = zeros(memdepth1,K,WT);
offsetlist=[0,2];
%taking circmat1, offset1
for wti=1:length(offsetlist)
offset=offsetlist(wti);%0
makecirculant([zeros(1,offset),1,zeros(1,(M-offset)-1)],M);
c=1; %starting row, no iterative order change

%parsing L[k] : L0 L1 till L3
for k=1:M
%k=1
%row= ( (k-c-offset) mod M )/K, col=( ( (k-c-offset)mod M) mod K)
addr_row = mod(((k-1)-(c-1)-offset),M);
%addr_row(addr_row==0) = M%correction
addr_row = floor(addr_row/K)+1;

addr_col = mod(((k-1)-(c-1)-offset),M);
%addr_col(addr_col==0) = M%correction
addr_col = mod(addr_col,K)+1;
%addr_col(addr_col==0) = K%correction
mem2(addr_row,addr_col,wti) = k-1;
end%kloop

end%wtiloop
mem2(:,:,:);
%----------------%

%making address trace for each cycle
Pdiv=26;%4;%8;%26;%7;
%for Pdiv = 4:73;
z=511;
p=ceil(z/Pdiv);%73;%cycles
firstrow = [1,177];
%mat = func_makecirculantlocations(firstrow,z,z);
[h,hloc] = func_makeHNE_LOC(z);
Wc=sum(hloc(1,:)~=0);
lyr1= hloc(1,:)-1;
lyr2=hloc(512,:)-1;
L2wr=mod(lyr1-lyr2,511);
L1wr=mod(lyr2-lyr1,511);

%-------------------------%
firstplyr1=[];%ylyr1
firstplyr2=[];%ylyr2
lastplyr1=[];%zlyr1
lastplyr2=[];%zlyr2
list=[1:Pdiv:511, 512:Pdiv:1022];
for i=list%1:p:1022
  if(i<=511)
    firstplyr1=[firstplyr1;hloc(i,:)-1];
    if(i==((p-1)*Pdiv)+1)
      lastplyr1=[lastplyr1;hloc(i+((z-1)-((p-1)*Pdiv)),:)-1];
      prte=0;
      prte=0;
    else
      lastplyr1=[lastplyr1;hloc(i+Pdiv-1,:)-1];
    end
  else
    firstplyr2=[firstplyr2;hloc(i,:)-1];
    if(i==512+((p-1)*Pdiv))
      lastplyr2=[lastplyr2;hloc(i+((z-1)-((p-1)*Pdiv)),:)-1];
    else
      lastplyr2=[lastplyr2;hloc(i+Pdiv-1,:)-1];
    end    
  end
end
%-------------------------%
%-------------------------%
ylyr1cycles=zeros(Pdiv,Wc,p);

rosetmat=[];
for j=1:p
  roset=[];
  ytemp=[];
  for i=1:Pdiv
    rowi=i+(j-1)*Pdiv;
    roset=[roset,rowi];
    if(rowi<=z)
      %ytemp=[ytemp;hloc(rowi,:)];
      ytemp=[ytemp;hloc(rowi,:)-1];
    else
      ytemp=[ytemp;zeros(1,Wc)];
    end
  end
  ylyr1cycles(:,:,j)=ytemp;
  rosetmat=[rosetmat;roset];
end

ylyr2cycles=zeros(Pdiv,Wc,p);
rosetmat=[];
for j=1:p
  roset=[];
  ytemp=[];
  for i=1:Pdiv
    rowi=i+(j-1)*Pdiv+z;
    roset=[roset,rowi];
    if(rowi<=2*z)
      %ytemp=[ytemp;hloc(rowi,:)];
      ytemp=[ytemp;hloc(rowi,:)-1];
    else
      ytemp=[ytemp;zeros(1,Wc)];
    end
  end
  ylyr2cycles(:,:,j)=ytemp;
  rosetmat=[rosetmat;roset];
end

%--------------------------%
%LYR 1 Case
%first col L2 wr : 
%Data is in a pattern according to first circulant offset of Lyr1 
%Write it in pattern according to first circulant offset of Lyr2
partlyr1Wc=zeros(p,6,Wc);
indiceslyr1Wc=zeros(p,6,Wc);
col=3;
for col=1:Wc
partlyr1=(-1)*ones(p,6);
indiceslyr1=(-1)*ones(p,6);
i=13;
for i=1:p%20
addrloc = floor(L2wr(1,col)/Pdiv)+1;
temp1=firstplyr1(i,col);
j=1;
partlyr1(i,j) = temp1;
indiceslyr1(i,j) = 0;
i1=i;
repeat=0;
inc=0;
while(repeat~=3)
  %lyr2i = mod((i1-1)+addrloc-1,p)+1; 
  for jp=1:p   
    if(length(find(partlyr1(i,j) == transpose(ylyr2cycles(:,col,jp))))~=0)
      lyr2i = jp;
      break;
    end   
  end  
  temp2 = firstplyr2(lyr2i,col);
  x1 = lastplyr1(i,col);
  x2 = lastplyr2(lyr2i,col);
  prte=0;
  prte=0;
  if(length(find(x1==transpose(ylyr2cycles(:,col,lyr2i))))~=0)
  %if(x2>x1) %if x1 is present in temp2 to x2 list.
    if(j==1)
      partlyr1(i,j+1) = x1;
      prte=0;
      prte=0;      
    else
      partlyr1(i,j+1) = x1;%[mod(partlyr1(i,j-1)+1,z),x1];
      prte=0;
      prte=0;      
    end
     prte=0;
      prte=0; 
  else if(j==1)  %if x1 is NOT present in temp2 to x2 list.
         partlyr1(i,j+1) = x2;%[temp1,x2];
         prte=0;
         prte=0;
       else
         partlyr1(i,j+1) = x2;%[mod(partlyr1(i,j-1)+1,z),x2];
         prte=0;
         prte=0;
       end
         prte=0;
         prte=0;       
  end
  indiceslyr1(i,j+1) = mod(partlyr1(i,j+1)-partlyr1(i,1),z);
  if(mod(partlyr1(i,j+1)-partlyr1(i,1),z)~=mod(x1-temp1,z))
    j=j+2;
     partlyr1(i,j)=mod(partlyr1(i,j-1)+1,z);
     indiceslyr1(i,j)=mod(partlyr1(i,j)-partlyr1(i,1),z);
    repeat=repeat+1;
    i1=mod((i1-1)+1,p)+1;
    prte=0;
    prte=0;
  else
    repeat=3;
    prte=0;
    prte=0;
  end
end
end%for i
partlyr1Wc(:,:,col) = partlyr1;
indiceslyr1Wc(:,:,col) = indiceslyr1;
%[transpose([1:p]),firstplyr1(:,col),lastplyr1(:,col),firstplyr2(:,col),lastplyr2(:,col),partlyr1,indiceslyr1]
end%for col

%[transpose([1:p]),firstplyr1(:,col),lastplyr1(:,col),firstplyr2(:,col),lastplyr2(:,col),partlyr1Wc(:,:,col),indiceslyr1Wc(:,:,col)]

%------------------------------%
%LYR2 Case
%first col L2 wr
partlyr2Wc=zeros(p,6,Wc);
indiceslyr2Wc=zeros(p,6,Wc);
col=3;
for col=1:Wc
partlyr2=(-1)*ones(p,6);
indiceslyr2=(-1)*ones(p,6);
i=13;
for i=1:p%20
addrloc = floor(L1wr(1,col)/Pdiv)+1;
temp1=firstplyr2(i,col);
j=1;
partlyr2(i,j) = temp1;
indiceslyr2(i,j) = 0;
i1=i;
repeat=0;
inc=0;
while(repeat~=3)
  %lyr1i = mod((i1-1)+addrloc-1,p)+1; 
  for jp=1:p   
    if(length(find(partlyr2(i,j) == transpose(ylyr1cycles(:,col,jp))))~=0)
      lyr1i = jp;
      break;
    end   
  end  
  temp2 = firstplyr1(lyr1i,col);
  x1 = lastplyr2(i,col);
  x2 = lastplyr1(lyr1i,col);
  prte=0;
  prte=0;
  if(length(find(x1==transpose(ylyr1cycles(:,col,lyr1i))))~=0)
  %if(x2>x1) %if x1 is present in temp2 to x2 list.
    if(j==1)
      partlyr2(i,j+1) = x1;
      prte=0;
      prte=0;      
    else
      partlyr2(i,j+1) = x1;%[mod(partlyr2(i,j-1)+1,z),x1];
      prte=0;
      prte=0;      
    end
     prte=0;
      prte=0; 
  else if(j==1)  %if x1 is NOT present in temp2 to x2 list.
         partlyr2(i,j+1) = x2;%[temp1,x2];
         prte=0;
         prte=0;
       else
         partlyr2(i,j+1) = x2;%[mod(partlyr1(i,j-1)+1,z),x2];
         prte=0;
         prte=0;
       end
         prte=0;
         prte=0;       
  end
  indiceslyr2(i,j+1) = mod(partlyr2(i,j+1)-partlyr2(i,1),z);
  if(mod(partlyr2(i,j+1)-partlyr2(i,1),z)~=mod(x1-temp1,z))
    j=j+2;
     partlyr2(i,j)=mod(partlyr2(i,j-1)+1,z);
     indiceslyr2(i,j)=mod(partlyr2(i,j)-partlyr2(i,1),z);
    repeat=repeat+1;
    i1=mod((i1-1)+1,p)+1;
    prte=0;
    prte=0;
  else
    repeat=3;
    prte=0;
    prte=0;
  end
end
end%for i
partlyr2Wc(:,:,col) = partlyr2;
indiceslyr2Wc(:,:,col) = indiceslyr2;
%[transpose([1:p]),firstplyr2(:,col),lastplyr2(:,col),firstplyr1(:,col),lastplyr1(:,col),partlyr2,indiceslyr2]
end%for col

%[transpose([1:p]),firstplyr1(:,col),lastplyr1(:,col),firstplyr2(:,col),lastplyr2(:,col),partlyr1Wc(:,:,col),partlyr2Wc(:,:,col)]

%---------L2WR Index Table for Verilog --------%
lyr2wrWc=(-1)*ones(p,6,Wc);
lyr2wr_row=zeros(p,1,Wc);
col=1;
addrloc = floor(L2wr(1,col)/Pdiv)+1
i=1;
for i=1:p
  i1=i;

  for j=1:6
  
    if(partlyr1Wc(i,j,col)~=-1)
      chkelem=partlyr1Wc(i,j,col);
      prte=0;
      prte=0;
      for jp=1:p
        if(length(find(chkelem==partlyr2Wc(jp,:,col)))~=0)
         %if chkelem is in the partlyr2Wc(jp, :) list.
          jp;
          lyr2i=mod((jp-1)-(addrloc-1),p)+1;
          lyr2wrWc(lyr2i,find(chkelem==partlyr2Wc(jp,:,col)),col)=mod(partlyr1Wc(i,j,col)-partlyr1Wc(i,1,col),z);
          lyr2wr_row(lyr2i,:,col)=jp;
          j=j+1;
          break;
        end
      end
      prte=0;
      prte=0;
    end%if-1
    prte=0;
    prte=0;
  end%for j
prte=0;
prte=0;
end%for i=1:p

%--------------------------------%
%printing Case verilog
col=1;
d_disable=0; %some cases only have reg1 and reg2 no d.

file2open = sprintf("./outputs/wr_dataaligner_%d.v",col-1);
fid = fopen(file2open,'wt'); 
  printtxt=sprintf('`timescale 1ns / 1ps\n');
  fprintf(fid,'%c',transpose(printtxt));  

prt=sprintf("wire rd;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("wire [(COLADDRBITS)-1:0] rd_row;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("wire wr;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("wire [(COLADDRBITS)-1:0] wr_row;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("wire [(26*W)-1:0] out;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("reg [(26*W)-1:0] reg1, nreg1;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("reg [(26*W)-1:0] reg2, nreg2;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("reg [(26*W)-1:0] regd, nregd;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("reg secondwrreg, nsecondwrreg;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("reg [(COLADDRBITS)-1:0] secondrd_rowreg, nsecondrd_rowreg;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("reg [(COLADDRBITS)-1:0] rd_row_lutin, rd_rowreg1;\n")
fprintf(fid,'%c',transpose(prt));  

prt=sprintf("always@(posedge clk) begin\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("  if(!rst)\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("    rd_rowreg1<=0;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("  else\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("    rd_rowreg1<=rd_row;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("end\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("\n")
fprintf(fid,'%c',transpose(prt));  

prt=sprintf("always@(*) begin\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("  if((rd_rowreg1 == 19)&&(secondwrreg==1)) \n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("    rd_row_lutin=secondrd_rowreg;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("  else\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("    rd_row_lutin=rd_row;\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("end\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("\n")
fprintf(fid,'%c',transpose(prt));  

prt=sprintf(" assign wr = rd | secondwrreg;\n")
fprintf(fid,'%c',transpose(prt));  

prt=sprintf("always@(*) begin\n")
fprintf(fid,'%c',transpose(prt));  
prt= sprintf("case(rd_row_lutin)\n")
fprintf(fid,'%c',transpose(prt));  

rd_row=1;%1:p
for rd_row=1:20%[1,2,5,6]
  
wr_row = lyr2wr_row(rd_row)-1;
lyr2wrWc_flipped=transpose(flip(transpose(lyr2wrWc(:,:,col))));

prt=sprintf("  %d: begin\n", rd_row-1)
fprintf(fid,'%c',transpose(prt));  

validpositionslist=find(lyr2wrWc_flipped(rd_row,:)~=-1);
if(length(validpositionslist) == 4)
  if(d_disable==0)
  dst = lyr2wrWc_flipped(rd_row,validpositionslist(1),col);
  dend =  lyr2wrWc_flipped(rd_row,validpositionslist(2),col);
  reg1st = lyr2wrWc_flipped(rd_row,validpositionslist(3),col);
  reg1end =  lyr2wrWc_flipped(rd_row,validpositionslist(4),col);
    prt=sprintf("       out = {d[((%d+1)*W)-1:(%d*W)], reg1[((%d+1)*W)-1:(%d*W)]};\n",dst,dend,reg1st,reg1end)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nreg1 = d;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nreg2 = reg2;\n")        
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nregd = regd;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       wr_row = %d;\n", wr_row)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nsecondrd_rowreg = secondrd_rowreg;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nsecondwrreg = secondwrreg;\n")     
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("     end\n")  
    fprintf(fid,'%c',transpose(prt));  
  else %case for only reg1 and reg2 and no d.
    reg1st = lyr2wrWc_flipped(rd_row,validpositionslist(1),col);
    reg1end =  lyr2wrWc_flipped(rd_row,validpositionslist(2),col);
    reg2st = lyr2wrWc_flipped(rd_row,validpositionslist(3),col);
    reg2end =  lyr2wrWc_flipped(rd_row,validpositionslist(4),col);
    prt=sprintf("       out = {reg1[((%d+1)*W)-1:(%d*W)], reg2[((%d+1)*W)-1:(%d*W)]};\n",reg1st,reg1end,reg2st,reg2end)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nreg1 = d;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nreg2 = reg1;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nregd = regd;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       wr_row = %d;\n", wr_row)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nsecondrd_rowreg = secondrd_rowreg;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nsecondwrreg = secondwrreg;\n")     
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("     end\n")      
    fprintf(fid,'%c',transpose(prt));  
  end
else
  if(length(validpositionslist) == 6)
    firstvalid=find(lyr2wrWc_flipped(rd_row,:)~=-1,2);
    dst = lyr2wrWc_flipped(rd_row,firstvalid(1),col);
    dend =  lyr2wrWc_flipped(rd_row,firstvalid(2),col);
    diff=dst-dend;%bigendian
    zeroscount= 26-(diff+1);
    %if d_disable = 1
    regdst = lyr2wrWc_flipped(rd_row,validpositionslist(1),col);
    regdend =  lyr2wrWc_flipped(rd_row,validpositionslist(2),col);
    reg1st = lyr2wrWc_flipped(rd_row,validpositionslist(3),col);
    reg1end =  lyr2wrWc_flipped(rd_row,validpositionslist(4),col);
    reg2st = lyr2wrWc_flipped(rd_row,validpositionslist(5),col);
    reg2end =  lyr2wrWc_flipped(rd_row,validpositionslist(6),col);    

    prt=sprintf("       if(secondwrreg==0) begin\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         out = {d[((%d+1)*W)-1:(%d*W)],{(%d){1'b0}} };\n",dst,dend,zeroscount)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nreg1 = d;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nreg2 = reg2;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nregd = d;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         wr_row = %d;\n", wr_row)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nsecondrd_rowreg = %d;\n", rd_row-1)    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nsecondwrreg = 1;\n")  
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       end//if\n")      
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       else begin\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         out = {regd[((%d+1)*W)-1:(%d*W)],reg1[((%d+1)*W)-1:(%d*W)],reg2[((%d+1)*W)-1:(%d*W)]};\n",regdst,regdend,reg1st,reg1end,reg2st,reg2end)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nreg1 = 0;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nreg2 = 0;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nregd = 0;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         wr_row = %d;\n", wr_row) 
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nsecondrd_rowreg = 0;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("         nsecondwrreg = 0;\n")      
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       end//else\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("     end//case\n")
    fprintf(fid,'%c',transpose(prt));  

  else %if length is 2
    firstvalid=find(lyr2wrWc_flipped(rd_row,:)~=-1,2);
    reg1st = lyr2wrWc_flipped(rd_row,firstvalid(1),col);
    reg1end =  lyr2wrWc_flipped(rd_row,firstvalid(2),col);
    diff=reg1st-reg1end;%bigendian
    zeroscount= 26-(diff+1);
    prt=sprintf("       out = {reg1[((%d+1)*W)-1:(%d*W)],{(%d){1'b0}} };\n",reg1st,reg1end,zeroscount)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nreg1 = d;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nreg2 = reg1;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nregd = regd;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       wr_row = %d;\n", wr_row)
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nsecondrd_rowreg = secondrd_rowreg;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       nsecondwrreg = secondwrreg;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("     end\n")
    fprintf(fid,'%c',transpose(prt));  
    
    d_disable=1;
  end    
    
end

end%for rd_row
prt=sprintf("  default: begin\n")
fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             out = 0;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             nreg1 = reg1;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             nreg2 = reg2;\n")        
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             nregd = regd;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             wr_row = 0;\n")
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             nsecondrd_rowreg = 0;\n")    
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("             nsecondwrreg = 0;\n")     
    fprintf(fid,'%c',transpose(prt));  
    prt=sprintf("       end\n")  
    fprintf(fid,'%c',transpose(prt));  
prt=sprintf("endcase\n")
fprintf(fid,'%c',transpose(prt));  
prt=sprintf("end//always\n")
fprintf(fid,'%c',transpose(prt));  
fclose(fid);
%-------------------Verilogcode end----------------%
%------------------addrconflict analysis wt0 to wt1---------%
for i=1:p
  for j=1:16
    col= 2*j-1;
    list = mod([firstplyr1(i,col+1):1:lastplyr1(i,col+1)],511);
    prte=0;
    prte=0;
    if(length(find(list(1,:)==lastplyr1(i,col)))~=0)
      prte=sprintf("at i=%d, col=%d, 2 addr same Conflict",i,col)
      break;
    end
  end
end
%--------------------------------------%
circ=2;col=(2*circ)-1;
table1 = [transpose([1:p]),firstplyr1(:,col),lastplyr1(:,col),firstplyr1(:,col+1),lastplyr1(:,col+1),firstplyr2(:,col),lastplyr2(:,col),firstplyr2(:,col+1),lastplyr2(:,col+1)]
%-%--------MEM MAP 511-----------%
%LYR=2
%WT=2
%K=4 %Pdiv
%memdepth1=ceil(z/K)%p%cycles
%firstrow=[1,177;100,472]
%mem1 = zeros(memdepth1,K,WT,LYR);
%
%for lyr=1:LYR
%for wt=1:WT
%  %taking circmat1, offset1
%  offset=firstrow(lyr,wt)-1%0
%  %starting row, no iterative order change
%  if(lyr==2) 
%    c=78;
%  else 
%    c=1;
%  end
%   
%  %parsing L[k] : L0 L1 till L510
%  for k=1:z%M
%    addr_row = mod(((k-1)-(c-1)-offset),z);
%    addr_row = floor(addr_row/K)+1;
%
%    addr_col = mod(((k-1)-(c-1)-offset),z);
%    addr_col = mod(addr_col,K)+1;
%    mem1(addr_row,addr_col,wt,lyr) = k;
%  end
%  mem1(:,:,wt,lyr)
%end%wt
%end%lyr
%
%[mem1(1:3,:,1,1),mem1(48:50,:,2,1)],[mem1(59:61,:,1,2),mem1(6:8,:,2,2)]
%[mem1(1:3,:,1,1),mem1(1:3,:,2,1)],[mem1(6:8,:,1,2),mem1(6:8,:,2,2)]
%[mem1(1:3,:,1,1),mem1(1:3,:,2,1)],[mem1(1:3,:,1,2),mem1(1:3,:,2,2)]
%--%---------------------------%

%--%--------------------------%
%prt = sprintf("\n Banked Memory Direct address Trace Analysis ")
%ylyr1=ylyr1cycles(:,:,1);
%ylyr2=ylyr2cycles(:,:,1);
%addrrange = zeros(16,Pdiv*2*2);
%circtrace = zeros(16,Pdiv*2*2);
%minsizecirc=[];
%maxsizecirc=[];
%replicacirc=zeros(16,150);
%for circ = 1:16
%  diag1 = 2*circ-1;%first diagonal offset1
%  diag2 = 2*circ;%second diagonal offset2
%  tracelist = [];
%  lyr1trace = [];
%  lyr2trace = [];
%  Pdivylyr = size(ylyr1,1);
%  for p_i = 1:Pdivylyr
%    lyr1trace = [lyr1trace,ylyr1(p_i,diag1:diag2)];
%  end
%  for p_i = 1:Pdivylyr
%    lyr2trace = [lyr2trace,ylyr2(p_i,diag1:diag2)];
%  end
%
%  sortedlyr1 = sort(lyr1trace);
%  sortedlyr2 = sort(lyr2trace);
%  sortedlyr2fin = sortedlyr2;
%  xciend = length(sortedlyr1);
%  for xci = 1:xciend
%    sortedlyr2fin(sortedlyr2fin==sortedlyr1(xci))=[];
%  end
%  tracelist = [sortedlyr1,sortedlyr2fin];
%  %tracelist = [lyr1trace,lyr2trace];
%  sortedtracelist = sort(tracelist);
%  diff=[];
%  difft=[];
%  replicalyr1=[];
%  replicalyr2=[];
%  replica=[];
%  
%  %Finding Replica Offsets in each layer
%  sortedtrace = sortedlyr1;%sortedtracelist;
%  for i=2:length(sortedtrace)
%    dtemp = sortedtrace(i) - sortedtrace(i-1);
%    %difft=[difft,dtemp];
%    if(dtemp == 0) 
%      %dtemp = sortedtrace(i)*10000+9999; %mark of replica
%      replica = [replica,sortedtrace(i)];
%    end
%    %diff = [diff,dtemp];
%  end
%  moddtemp = mod(sortedtrace(1) - sortedtrace(end),z);
%  %difft=[difft,moddtemp];
%  if(moddtemp == 0) 
%    %moddtemp = sortedtrace(end)*10000+9999; %mark of replica
%    replica=[replica,moddtemp];
%  end
%  %diff = [diff,moddtemp];
%  %Layer2
%  sortedtrace = sortedlyr2;%sortedtracelist;
%  for i=2:length(sortedtrace)
%    dtemp = sortedtrace(i) - sortedtrace(i-1);
%    %difft=[difft,dtemp];
%    if(dtemp == 0) 
%    %  dtemp = sortedtrace(i)*10000+9999; %mark of replica
%      replica = [replica,sortedtrace(i)];
%    end
%    %diff = [diff,dtemp];
%  end
%  moddtemp = mod(sortedtrace(1) - sortedtrace(end),z);
%  %difft=[difft,moddtemp];
%  if(moddtemp == 0) 
%    %moddtemp = sortedtrace(end)*10000+9999; %mark of replica
%    replica=[replica,moddtemp];
%  end
%  %diff = [diff,moddtemp];
%  replicacirc(circ,1:length(replica)) = replica;
%  %replicalist
%    
%  % finding size of Memsubunit range
%  sortedtrace = sortedtracelist;
%  for i=2:length(sortedtrace)
%    dtemp = sortedtrace(i) - sortedtrace(i-1);
%    difft=[difft,dtemp];
%    if(dtemp == 0) 
%       if(find(replica == sortedtrace(i)))  
%         dtemp = sortedtrace(i)*10000+9999; %mark of replica to ignore in min calc
%         prt=sprintf("found in replica at i=%d",i)
%       else 
%         prt=sprintf("notfound in i=%d",i);
%       end
%    end
%    diff = [diff,dtemp];
%  end
%  moddtemp = mod(sortedtrace(1) - sortedtrace(end),z);
%  difft=[difft,moddtemp];
%  if(moddtemp == 0) 
%       if(find(replica == sortedtrace(end)))  
%         moddtemp = sortedtrace(end)*10000+9999; %mark of replica to ignore in min calc
%       else 
%         prt=sprintf("notfound in list end or first") 
%       end    
%  end
%  diff = [diff,moddtemp];
%  %
%  minsizecirc=[minsizecirc;min(diff)];
%  maxsizecirc=[maxsizecirc;max(difft)];
%  circtrace(circ,1:length(sortedtracelist)) = sortedtracelist;
%  addrrange(circ,1:length(diff)) = diff;
%end
%circtrace
%addrrange
%
%"min of addr range of banks for the 16 Subunits"
%transpose(minsizecirc)
%"min of above for the 16 Subunits"
%min(transpose(minsizecirc))
%"max of addr range of banks for the 16 Subunits"
%transpose(maxsizecirc)
%"max of above for the 16 Subunits"
%max(transpose(maxsizecirc))
%"replicas per curculant subunit"
% sum(transpose(replicacirc)~=0)
%"max number of replicas"
%max(sum(transpose(replicacirc)~=0))
%--%-------------------------------------%