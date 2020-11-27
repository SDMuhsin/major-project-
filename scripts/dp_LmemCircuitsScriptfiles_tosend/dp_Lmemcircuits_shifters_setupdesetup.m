%Deep Space AR4JA H-matrix LUT printing
clc
clear all
close all

%Making hdp and hbase
%submatrixsize 
M4by5 = 128;
M1by2 = 512;
Msub=M4by5;%M1by2;
hdp = func_makeHmatrixar4ja(Msub, "4by5");
z=Msub/4
hbase = func_makebasematrix(hdp,z);
[M,N] = size(hbase)%[12,44]
Nb=N;
Wc=max(sum(transpose(hbase~=-1)))
%Make offset value Wc-Base Matrix
hWcbase=(-1)*ones(M,Wc);
for i=1:M
  loctemp = hbase(i,[find(hbase(i,:)~=-1)]);
  hWcbase(i,:) = [(-1)*ones(1,Wc-length(loctemp)),loctemp];
end
hWcbase
%Make hexpandloc
hexpandloc=zeros(M,N);
memmap2=[];
for i=1:M
  for j=1:N
    if(hbase(i,j)~=-1)
      hexpandloc(i,j) = j;
    else
      hexpandloc(i,j) = 0;
    end
  end
  memmap2=[memmap2;hexpandloc(i,:);zeros(1,N)];
end
hexpandloc
%Make hbaseloc
hbaseloc=hbase; 
hbaseloc(hbaseloc~=-1) = 1;
hbaseloc(hbaseloc==-1)=0;
Wc=max(sum(transpose(hbaseloc)))
hbaselocWc=zeros(M,Wc);
%memmap=[];
for i=1:M
  loctemp=find(hbaseloc(i,:)~=0);
  hbaselocWc(i,:)=[zeros(1,Wc-length(loctemp)),loctemp];
  %memmap=[memmap;hbaselocWc(i,:);hbaselocWc(i,:);zeros(1,Wc)];
end
hbaselocWc
%---------Printing Shifters--------------------%
%   %Add below options later 
%  %if itr==0, shift==base matrix shift
%  %if unload_en, shift= mod(0 - lastshift,32)
%z=32;
%W=6;%quantisation bits
%Wc=18; %Max weight of row.
%Nb=44; %num of blk columns
%LYRWIDTH=4; %2^4= 16 > 12.
%ITRWIDTH=4; %2^4 = 16 > 10.
%col=2;%range 1 to Nb=44
%for col=1:Nb
%file2open = sprintf("./outputs/shifter_%d.v",col-1);
%fid = fopen(file2open,'wt'); 
%  printtxt=sprintf('`timescale 1ns / 1ps\n');
%  fprintf(fid,'%c',transpose(printtxt));  
%
%  printtxt=sprintf("module shifter_%d(dout32vec,din32vec,lyraddress,itr,unload_en);\n",col-1);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter W=%d;\n",W);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter LYRWIDTH=%d;//2^4 = 16 > 12 Layers\n",LYRWIDTH);
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("parameter ITRWIDTH=%d;//2^4 = 16 > 10 MaxItrs\n",ITRWIDTH);
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("parameter Z=%d;\n",z);
%  fprintf(fid,'%c',transpose(printtxt));     
%  printtxt=sprintf("output reg[(Z*W)-1:0] dout32vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("input[(Z*W)-1:0] din32vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("input[(LYRWIDTH)-1:0] lyraddress;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("input[(ITRWIDTH)-1:0] itr;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("input unload_en;\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  %printtxt=sprintf("wire[W-1:0] din32arr[Z-1:0];\n");
%  %fprintf(fid,'%c',transpose(printtxt)); 
%  %printtxt=sprintf("genvar zj;\n");
%  %fprintf(fid,'%c',transpose(printtxt)); 
%  %printtxt=sprintf("generate for(zj=0;zj<=Z-1;zj=zj+1) begin: z_loop\n");
%  %fprintf(fid,'%c',transpose(printtxt));   
%  %printtxt=sprintf("  assign din32arr[zj] = din32vec[((zj+1)*W)-1:(zj*W)];\n");
%  %fprintf(fid,'%c',transpose(printtxt));   
%  
%  %printtxt=sprintf("end\n");
%  %fprintf(fid,'%c',transpose(printtxt));  
%  %printtxt=sprintf("endgenerate\n");
%  %fprintf(fid,'%c',transpose(printtxt));   
%  
%  printtxt=sprintf('always@(*)\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf('begin\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%col
%x=find(hbase(:,col)~=-1);
%y=[x(end),transpose(x)]
%yshift=transpose(hbase([y],col))
%  lyr=y(2)-1;
%  printtxt=sprintf("if((unload_en==0)&&(itr==0)&&(lyraddress==%d))\n",lyr)
%  fprintf(fid,'%c',transpose(printtxt)); 
%  shiftdiff=yshift(2)
%  part1end=mod(shiftdiff-1,z);%mod(z-shiftdiff-1,z);
%  part2strt=mod(shiftdiff,z);%mod(z-shiftdiff,z);
%  if(shiftdiff!=0)
%    printtxt=sprintf("  dout32vec= { din32vec[((%d+1)*W)-1:(0*W)],din32vec[((Z)*W)-1:(%d*W)]};\n",part1end,part2strt)
%  else
%    printtxt=sprintf("  dout32vec= din32vec;\n")
%  end
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("else if(unload_en==1)\n")
%  fprintf(fid,'%c',transpose(printtxt));  
%  shiftprev = yshift(end)
%  shiftcurr = 0;
%  shiftdiff= mod(shiftcurr-shiftprev,z)
%  % y=[x(1,6-off+1:5+1),x(1,0+1:6-off-1+1)] %rightshift
%  % y=[x(1,off+1:5+1),x(1,0+1:off-1+1)] %required leftshift
%  part1end=mod(shiftdiff-1,z);%mod(z-shiftdiff-1,z);
%  part2strt=mod(shiftdiff,z);%mod(z-shiftdiff,z);
%  if(shiftdiff!=0)
%    printtxt=sprintf("  dout32vec= { din32vec[((%d+1)*W)-1:(0*W)],din32vec[((Z)*W)-1:(%d*W)]};\n",part1end,part2strt)
%    %printtxt=sprintf("  dout32vec= { din32arr[%d:0],din32arr[Z-1:%d]};\n",part1end,part2strt)
%  else
%    printtxt=sprintf("  dout32vec= din32vec;\n")
%  end
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("else\n")
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("begin\n")
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("case (lyraddress) \n")
%  fprintf(fid,'%c',transpose(printtxt)); 
%  
%for i=1:(length(y)-1)
%  lyr = y(i+1)-1;
%  printtxt=sprintf("5'd%d: begin\n",lyr)
%  fprintf(fid,'%c',transpose(printtxt)); 
%  shiftprev = yshift(i)
%  shiftcurr = yshift(i+1)
%  shiftdiff= mod(shiftcurr-shiftprev,z)
%  % y=[x(1,6-off+1:5+1),x(1,0+1:6-off-1+1)] %rightshift
%  % y=[x(1,off+1:5+1),x(1,0+1:off-1+1)] %required leftshift
%  part1end=mod(shiftdiff-1,z);%mod(z-shiftdiff-1,z);
%  part2strt=mod(shiftdiff,z);%mod(z-shiftdiff,z);
%  if(shiftdiff!=0)
%    printtxt=sprintf("         dout32vec= { din32vec[((%d+1)*W)-1:(0*W)],din32vec[((Z)*W)-1:(%d*W)]};\n",part1end,part2strt)
%    %printtxt=sprintf("         dout32vec= { din32arr[%d:0],din32arr[Z-1:%d]};\n",part1end,part2strt)
%  else
%    printtxt=sprintf("         dout32vec= din32vec;\n")
%  end
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("       end\n",i)
%  fprintf(fid,'%c',transpose(printtxt)); 
%end
%  printtxt=sprintf("default: begin\n",lyr);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("           dout32vec= {(Z*W){1'b0}};\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("       end\n",i);
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("endcase\n",i);
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("end//if_end\n",i);%if end
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("end//always_end\n",i);%always end
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("endmodule\n",i);
%  fprintf(fid,'%c',transpose(printtxt));  
%fclose(fid);
%prte=0;
%prte=0;
%end%for 1to Nb=44
%
%Nb=44;
%file2open = sprintf("./outputs/shifter_instances.v");
%fid = fopen(file2open,'wt'); 
%for col=1:Nb
%  printtxt=sprintf("defparam shift%d.W=W,shift%d.Z=Z,shift%d.LYRWIDTH=LYRWIDTH,shift%d.ITRWIDTH=ITRWIDTH;\n",col-1,col-1,col-1,col-1);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("shifter_%d shift%d(dout32vec[%d],din32vec[%d],lyraddress,itr,unload_en);\n",col-1,col-1,col-1,col-1);
%  fprintf(fid,'%c',transpose(printtxt)); 
%end
%fclose(fid);

%-----------Printing Shifters------------------%

%%%-----------Printing Setup44to18.v Verilog----------%%
%W=6;%quantisation bits
%Wc=18; %Max weight of row.
%Nb=44; %num of blk columns
%LYRWIDTH=4; %2^4= 16 > 12.
%file2open = sprintf('./outputs/setup44to18.v');
%fid = fopen(file2open,'wt'); 
%  printtxt=sprintf('`timescale 1ns / 1ps\n');
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf('module setup44to18(dvalid18vec_regout,dout18vec_regout,din44vec,lyraddress,en,clk,rst);\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter W=%d;\n",W);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter LYRWIDTH=%d;//2^4 = 16 > 12 Layers\n",LYRWIDTH);
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("parameter Wc=%d;\n",Wc);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter Nb=%d;\n",Nb);
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("output reg[Wc-1:0] dvalid18vec_regout;\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("output reg[(Wc*W)-1:0] dout18vec_regout;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("input[(Nb*W)-1:0] din44vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("input[(LYRWIDTH)-1:0] lyraddress;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("input en;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("input clk, rst;\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("//---Regd inputs and outputs --//\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("reg[Wc-1:0] dvalid18vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("reg[(Wc*W)-1:0] dout18vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("always@(posedge clk)\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("begin\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("  if(!rst)\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("  begin\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dvalid18vec_regout<=0;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dout18vec_regout<=0;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("  end\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("  else\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("  begin\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dvalid18vec_regout<=dvalid18vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dout18vec_regout<=dout18vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("  end\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("end\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("//---------------//\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("wire[(LYRWIDTH)-1:0] lyraddress_case;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("wire[W-1:0] din44arr[Nb-1:0];\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("genvar nbj;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("generate for(nbj=0;nbj<=Nb-1;nbj=nbj+1) begin: nb_loop\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("  assign din44arr[nbj] = din44vec[((nbj+1)*W)-1:(nbj*W)];\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  
%  printtxt=sprintf("end\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("endgenerate\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%
%  printtxt=sprintf("assign lyraddress_case = en ? lyraddress : 4'd15; //if en==0, make lyr invalid value \n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%
%  
%  printtxt=sprintf('always@(*)\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf('begin\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("case (lyraddress_case) \n")
%  fprintf(fid,'%c',transpose(printtxt)); 
%for i=1:M
%  loctemp=find(hbaseloc(i,:)~=0);
%##  arrloc = [zeros(1,Wc-length(loctemp)),loctemp];
%##  %prt=sprintf("4''d0: begin dout18 = {}; valid18={}; end") 
%##  dvalid=[zeros(1,Wc-length(loctemp)),ones(1,length(loctemp))];
%  printtxt=sprintf("4'd%d: begin \n",i-1) 
%    fprintf(fid,'%c',transpose(printtxt)); 
%    
%  %printing dout18vec
%  printtxt=sprintf("         dout18vec={") 
%  fprintf(fid,'%c',transpose(printtxt));
%%  if(length(loctemp)!=Wc)
%%    printtxt=sprintf("{(%d*W){1'b0}},",Wc-length(loctemp))
%%    fprintf(fid,'%c',transpose(printtxt));
%%  end
%    for j=length(loctemp):-1:1%1:length(loctemp)
%         printtxt=sprintf("din44arr[%d]",loctemp(1,j)-1)
%         fprintf(fid,'%c',transpose(printtxt));
%       if(j!=1)%(j!=length(loctemp(1,:)))
%         printtxt=sprintf(",")
%         fprintf(fid,'%c',transpose(printtxt));
%       else
%         if(length(loctemp)!=Wc)
%           printtxt=sprintf(",{(%d*W){1'b0}}",Wc-length(loctemp))
%           fprintf(fid,'%c',transpose(printtxt));
%         end
%         printtxt=sprintf("};\n")
%         fprintf(fid,'%c',transpose(printtxt));
%       end
%    end%for j
%  
%  %printing dvalid18vec
%  printtxt=sprintf("         dvalid18vec={") 
%  fprintf(fid,'%c',transpose(printtxt));
%%  if(length(loctemp)!=Wc)
%%    printtxt=sprintf("{(%d){1'b0}},",Wc-length(loctemp))
%%    fprintf(fid,'%c',transpose(printtxt));
%%  end
%    printtxt=sprintf("{(%d){1'b1}}",length(loctemp))
%    fprintf(fid,'%c',transpose(printtxt));
%  if(length(loctemp)!=Wc)
%    printtxt=sprintf(",{(%d){1'b0}}",Wc-length(loctemp))
%    fprintf(fid,'%c',transpose(printtxt));
%  end    
%    printtxt=sprintf("};\n")
%    fprintf(fid,'%c',transpose(printtxt));
%  
%    printtxt=sprintf("end \n") 
%    fprintf(fid,'%c',transpose(printtxt)); 
%end
%
%  printtxt=sprintf('default: begin dout18vec = 0; dvalid18vec=0; end\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf('endcase\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("end\n")
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("endmodule\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  
%fclose(fid);
%%%----------setup44to18.v printing--------%%

h18to44 = zeros(M,N);
for i=1:M
  for j=1:Wc
    if(hbaselocWc(i,j)!=0)
     h18to44(i,hbaselocWc(i,j))=j;
    end
  end
end
h18to44

%%%-----------Printing Desetup18to44.v Verilog----------%%
%W=6;%quantisation bits
%Wc=18; %Max weight of row.
%Nb=44; %num of blk columns
%LYRWIDTH=4; %2^4= 16 > 12.
%file2open = sprintf('./outputs/Desetup18to44.v');
%fid = fopen(file2open,'wt'); 
%  printtxt=sprintf('`timescale 1ns / 1ps\n');
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf('module desetup18to44(dvalid44vec_regout,dout44vec_regout,din18vec,lyraddress,en,clk,rst);\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter W=%d;\n",W);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter LYRWIDTH=%d;//2^4 = 16 > 12 Layers\n",LYRWIDTH);
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("parameter Wc=%d;\n",Wc);
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("parameter Nb=%d;\n",Nb);
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("output reg[Nb-1:0] dvalid44vec_regout;\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("output reg[(Nb*W)-1:0] dout44vec_regout;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("input[(Wc*W)-1:0] din18vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("input[(LYRWIDTH)-1:0] lyraddress;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
% printtxt=sprintf("input en;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("input clk, rst;\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("//---Regd inputs and outputs --//\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("reg[Nb-1:0] dvalid44vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("reg[(Nb*W)-1:0] dout44vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("always@(posedge clk)\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("begin\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("  if(!rst)\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("  begin\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dvalid44vec_regout<=0;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dout44vec_regout<=0;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("  end\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("  else\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("  begin\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dvalid44vec_regout<=dvalid44vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("    dout44vec_regout<=dout44vec;\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("  end\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("end\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("//---------------//\n");
%  fprintf(fid,'%c',transpose(printtxt));
%  printtxt=sprintf("\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("wire[(LYRWIDTH)-1:0] lyraddress_case;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("wire[W-1:0] din18arr[Wc-1:0];\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("genvar wcj;\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("generate for(wcj=0;wcj<=Wc-1;wcj=wcj+1) begin: wc_loop\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  printtxt=sprintf("  assign din18arr[wcj] = din18vec[((wcj+1)*W)-1:(wcj*W)];\n");
%  fprintf(fid,'%c',transpose(printtxt));   
%  
%  printtxt=sprintf("end\n");
%  fprintf(fid,'%c',transpose(printtxt));  
%  printtxt=sprintf("endgenerate\n");
%  fprintf(fid,'%c',transpose(printtxt));   
% 
%  printtxt=sprintf("assign lyraddress_case = en ? lyraddress : 4'd15; //if en==0, make lyr invalid value \n");
%  fprintf(fid,'%c',transpose(printtxt)); 
% 
%  printtxt=sprintf('always@(*)\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf('begin\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("case (lyraddress_case) \n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%for i=1:M
%  
%  loctemp=h18to44(i,:);%find(hbaseloc(i,:)~=0);
%##  arrloc = [zeros(1,Wc-length(loctemp)),loctemp];
%##  %prt=sprintf("4''d0: begin dout18 = {}; valid18={}; end") 
%##  dvalid=[zeros(1,Wc-length(loctemp)),ones(1,length(loctemp))];
%  printtxt=sprintf("4'd%d: begin \n",i-1) ;
%    fprintf(fid,'%c',transpose(printtxt)); 
%    
%  %printing dout44vec
%  printtxt=sprintf("         dout44vec={") ;
%  fprintf(fid,'%c',transpose(printtxt));
%    for j=length(loctemp):-1:1%1:length(loctemp)
%      if(loctemp(1,j)==0)
%        printtxt=sprintf("{W{1'b0}}");
%        fprintf(fid,'%c',transpose(printtxt));
%      else
%        printtxt=sprintf("din18arr[%d]",loctemp(1,j)-1);
%        fprintf(fid,'%c',transpose(printtxt));
%      end
%       if(j!=1)%(j!=length(loctemp(1,:)))
%         printtxt=sprintf(",");
%         fprintf(fid,'%c',transpose(printtxt));
%       else
%         printtxt=sprintf("};\n");
%         fprintf(fid,'%c',transpose(printtxt));
%       end
%    end%for j
%  
%  %printing dvalid44vec
%  printtxt=sprintf("         dvalid44vec={") ;
%  fprintf(fid,'%c',transpose(printtxt));
%    for j=length(loctemp):-1:1%1:length(loctemp)
%      if(loctemp(1,j)==0)
%        printtxt=sprintf("1'b0");
%        fprintf(fid,'%c',transpose(printtxt));
%      else
%        printtxt=sprintf("1'b1");
%        fprintf(fid,'%c',transpose(printtxt));
%      end
%       if(j!=1)%(j!=length(loctemp(1,:)))
%         printtxt=sprintf(",");
%         fprintf(fid,'%c',transpose(printtxt));
%       else
%         printtxt=sprintf("};\n");
%         fprintf(fid,'%c',transpose(printtxt));
%       end
%    end%for j
%
%  
%    printtxt=sprintf("end \n") ;
%    fprintf(fid,'%c',transpose(printtxt)); 
%end
%
%  printtxt=sprintf('default: begin dout44vec = 0; dvalid44vec=0; end\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf('endcase\n');
%  fprintf(fid,'%c',transpose(printtxt)); 
%  printtxt=sprintf("end\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  
%  printtxt=sprintf("endmodule\n");
%  fprintf(fid,'%c',transpose(printtxt)); 
%  
%fclose(fid);
%%%----------Desetup18to44.v printing--------%%