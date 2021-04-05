%ne encoder parallel rce network analysis
% analyse and create pattern for parity shift part
clc
clear all
close all

Z=5%511;
Lm=3%73;
x=[0:1:Z-1]
%%xmat=zeros(Z,Z);
%%xmat(1,:)=x
%%for i=2:1:Z
%%  xmat(i,:)=circshift(xmat(i-1,:),Lm)
%%end
%%
%%%then pattern for connecting parity registers:
%%parityconnectpattern=[];
%%for i=1:Z
%%  parityconnectpattern=[parityconnectpattern, find(xmat(i,:)==0)-1]
%%end

%or simply:
parityconnectpattern_simple=mod([0:Lm:(Lm*Z)-1],Z);
%for Z and Lm factors case:
if(mod(Z,Lm)==0)
temp1=parityconnectpattern_simple(1:(Z/Lm));
for i=1:length(x)
  if(length(find(temp1==x(i)))==0)
    j=x(i);
    temp=mod([j:Lm:(Lm*Z)-1],Z);
    temp1=[temp1;temp(1,1:(Z/Lm))];
  end
end
parityconnectpattern_simple=temp1;
end
parityconnectpattern_simple

parityshiftseq=func_getparityshiftsequence(Z,Lm)

%The output parity bits {p0,p1,p2,p3,p4} is
% obtained from parity registers R={R0,R1,R2,R3,R4}
% based on shift value of vector 'f' (f_v) used in the last row of parallel network
% for example, Lm=2, Z=5: 
% first row = f_v = {f0,f1,f2,f3,f4}
% second row= leftshift(f_v,1)
% then {P0,P1,P2,P3,P4}= rightshift({R0,R1,R2,R3,R4}, 1)
% if first row= leftshift(f_v,1) ; last circulant row.
% second row = leftshift(f_v,2) ;second last row
% then {P0,P1,P2,P3,P4}= rightshift({R0,R1,R2,R3,R4}, 2)

%bit serial architecture: u0,u1,...,uz-1
%circulant bits: f0,f1,f2,...,fz-1
%Based on Lm
%n changes to k, 
Z=5;

Lm=3;
for k=0:1:Z-1%ceil(Z/Lm)-1
[mod(Lm*k,Z), mod((Lm*k)+(Lm-1),Z)]
end