%near earth encoder using parallel RCE
%functionality ref model
clc
clear all
close all
pkg load communications
%
% Reference multiplication with zero append and without zero append
Z=5;
G5 = [makecirculant(randi([0,1],1,5), 5); makecirculant(randi([0,1],1,5), 5); makecirculant(randi([0,1],1,5), 5)]%[makecirculant([1,1,0,0,1], 5); makecirculant([1,0,1,0,1], 5); makecirculant([1,0,1,1,1], 5)]
G5z = [makecirculant(randi([0,1],1,5), 5); zeros(1,5); makecirculant(randi([0,1],1,5), 5); zeros(1,5); makecirculant(randi([0,1],1,5), 5); zeros(1,5)]
%G5z = [makecirculant([1,1,0,0,1], 5); zeros(1,5); makecirculant([1,0,1,0,1], 5); zeros(1,5); makecirculant([1,0,1,1,1], 5); zeros(1,5)]
G5gf=gf(G5,1);
G5zgf=gf(G5z,1);
m5=randi([0,1],1,15)%[1,0,1,0,0,0,1,0,0,1]%randi([0,1],1,10)%[1,1,1,1,1,1,1,1,1,1]%[1,0,0,1,0,1,1,1,0,1]%[0,0,0,1,1,1,0,0,0,1]%
m5z=[m5(1:Z),zeros(1,1),m5(Z+1:2*Z),zeros(1,1),m5(2*Z+1:end),zeros(1,1)]
m5gf = gf(m5,1);
m5zgf= gf(m5z,1);

p5gf1 = m5gf(1:Z)*G5gf(1:Z,:)
p5gf2 = m5gf(1:2*Z)*G5gf(1:2*Z,:)
p5gf = m5gf*G5gf %Reference parity result.
p5zgf = m5zgf*G5zgf

%removing first 2 rows of G
%G5compress= G5(3:end,:);
%G5compressgf=gf(G5compress,1)
%m5compressgf = gf([m5(3:Z),m5(Z+1:end)],1)
%p5compressgf = m5compressgf*G5compressgf

%G5compressz= G5z(3:end,:);
%G5compresszgf=gf(G5compressz,1)
%m5compresszgf = gf([m5(3:Z),zeros(1,1),m5(Z+1:end),zeros(1,1)],1)
%p5compresszgf = m5compresszgf*G5compresszgf  

%para rce circuit ref model, without input bitreversing.
Lm=2;
m_circ1z = gf([m5(1:Z),0],1)
m_circ1z_compress= (m_circ1z(1,1:end))%flip(m_circ1z(1,3:end))
m_circ1z_compress = (m_circ1z_compress)
m_circ2z = gf([m5(Z+1:2*Z),0],1)
m_circ2z = (m_circ2z)%flip(gf([m5(Z+1:end),0],1))
m_circ3z = gf([m5(2*Z+1:end),0],1)
m_circ3z = (m_circ3z)%flip(gf([m5(Z+1:end),0],1))

seq = [0,2,4,1,3]+1;
mac_circ1 = func_makemacLm(G5(1,:),Lm)%[G5z(1,:);G5z(5,:)]%[G5z(2,:);G5z(1,:)]%[G5z(1,:);G5z(5,:)]%[G5z(5,:);G5z(4,:)]
m5Lm_circ1=[];
for i=1:Lm:size(m_circ1z_compress)(2)
  m5Lm_circ1 = [m5Lm_circ1;m_circ1z_compress(1,i:i+(Lm-1))];
  %m5Lm_circ1 = gf([0,1;1,0],1)
end
%m5Lm_circ1 = [m_circ1z_compress(6),m_circ1z_compress(5);m_circ1z_compress(4),m_circ1z_compress(3);m_circ1z_compress(2),m_circ1z_compress(1)]
u_circ1 = m5Lm_circ1*mac_circ1

%pr_circ1 = [u_circ1(1,seq)]
%0->2->4->1->3
%Shift and add
pr=gf(zeros(1,Z),1);

%circ1
for i=1:size(u_circ1)(1)
%  pr=[pr(1,end),pr(1,1:end-1)]  %right shift
%  u_circ1(i,seq)
%  pr=[u_circ1(i,seq)] + pr %add
%  
  pr = [pr(1,end),pr(1,1:end-1)]+u_circ1(i,seq);
end

%Obtained Parity result from ParaRCE
pr1 = pr(1,seq) %seq removal
%pr1=[pr1(1,2:end),pr1(1,1)] %1 left shift
%pr1=[pr1(1,end),pr1(1,1:end-1)] %1 right shift
%pr1=func_rotator(pr1, 2, 'R')%[pr1(1,3:end),pr1(1,1:2)] %2 left shifts

%Check Match for 1 circ case
p5gf1
match_circ1=isequal(p5gf1,pr1)

mac_circ2 = func_makemacLm(G5(8,:),Lm)%func_makemacLm(G5(8,:),Lm)%[G5z(7,:);G5z(11,:)]%[G5z(8,:);G5z(7,:)]%[G5z(7,:);G5z(11,:)]%[G5z(11,:);G5z(10,:)]
m5Lm_circ2=[];
for i=1:Lm:size(m_circ2z)(2)
  m5Lm_circ2 = [m5Lm_circ2;m_circ2z(1,i:i+(Lm-1))];
  %m5Lm_circ2 = gf([0,1;0,0;0,1],1)
end
m5Lm_circ2

u_circ2 =  m5Lm_circ2*mac_circ2

%pr_circ2 = [u_circ2(1,seq)]
%0->2->4->1->3

%Shift and add
%for circ2
for i=1:size(u_circ2)(1)
  % pr=[pr(1,end),pr(1,1:end-1)]  %right shift  
  % u_circ2(i,seq)
  % pr=u_circ2(i,seq)+pr %add
  
  pr = [pr(1,end),pr(1,1:end-1)]+u_circ2(i,seq);
end
%Obtained Parity result from ParaRCE
%parity = [pr_circ1(1,end),pr_circ1(1,1:end-1)] + pr_circ2
%parity = [parity(1,end),parity(1,1:end-1)]
pr2 = pr(1,seq)  %seq removal

%pr=[pr(1,2:end),pr(1,1)]%[pr(1,3:end),pr(1,1:2)]
parity=pr2%[pr(1,end),pr(1,1:end-1)] % no shift

%Check Match for acc of both circ
p5gf2
match_circ2=isequal(p5gf2,parity)

%circ3
mac_circ3 = func_makemacLm(G5(11,:),Lm)%
m5Lm_circ3=[];
for i=1:Lm:size(m_circ3z)(2)
  m5Lm_circ3 = [m5Lm_circ3;m_circ3z(1,i:i+(Lm-1))];
end
u_circ3 = m5Lm_circ3*mac_circ3
%Shift and add
%for circ3
for i=1:size(u_circ3)(1)
  pr = [pr(1,end),pr(1,1:end-1)]+u_circ3(i,seq);
end
%Obtained Parity result from ParaRCE
pr = pr(1,seq) %seq removal
parity=pr%func_rotator(pr1, 1, 'R')%[pr(1,end),pr(1,1:end-1)] %1 right shift

%Check Match for acc of both circ
p5gf
match_circ3=isequal(p5gf,parity)

gf2toint([p5gf1, func_rotator(pr1,1,'R') , match_circ1;  p5gf2, pr2 , match_circ2;  p5gf, pr , match_circ3])

%------Random msg and circulants check for any Z and Lm-----%
clc
clear all
close all
pkg load communications
%General:
Z=11
KB=2
Lm=5

znum=Lm*(ceil(Z/Lm)) -Z %num of zeros to append
seq = [0,2,4,1,3]+1;
seq=func_getparityshiftsequence(Z,Lm)+1

%initialise check loop param
proceed=0;%1;
timeout=0;
%Check loop:
while(proceed)
timeout=timeout+1;

%initialize:
GZ=gf(zeros(KB*Z,Z),1);
pr=gf(zeros(1,Z),1);

%generate random msg:
mZ=gf(randi([0,1],1,KB*Z),1);

%generate G matrix using circulants:
for circ=1:KB
  GZ(1+(circ-1)*Z:circ*Z,:) = makecirculant(randi([0,1],1,Z), Z);
end

%Do parallel RCE mul for each circulant:
for circ=1:KB
  %append zeros to Z-bit block of msg mZ
  m_circz = gf([mZ(1+(circ-1)*Z:circ*Z),zeros(1,znum)],1)
  
  %bit reverse the message to feed MSB first:
  m_circz = flip(m_circz)
  
  %Feed the circulant bits to Lm row MAC network (left rotated matrix):
  mac_circ = func_makemacLm(GZ((1+(circ-1)*Z),:),Lm)
  
  %Divide zero appended, bitreversed msg into Lm sections:
  mZLm_circ=[];
  for i=1:Lm:size(m_circz)(2)
    mZLm_circ = [mZLm_circ;m_circz(1,i:i+(Lm-1))];  
  end
  mZLm_circ
  %Multiply msg with circulant bits in the MAC network to get u for all the cycles:
  u_circ = mZLm_circ*mac_circ
  
  %manual for loop MAC-mul is same as above matrix based MAC-mul.
%  u_circ=gf(zeros(size(mZLm_circ)(1),Z),1);
%  for i=1:size(mZLm_circ)(1)
%    for j=1:Lm
%      u_circ(i,:) = u_circ(i,:)+ mZLm_circ(i,j)*mac_circ(j,:);
%    end
%  end
%  u_circ
  
  %Shift and add u in 'seq' pattern with previous parity bits in convolution shifting network:
  for i=1:size(u_circ)(1)
    pr = func_rotator(pr,Lm,'R')+u_circ(i,:);
  end
  
  %pr = pr(1,seq)
  %pr = func_rotator(pr,1,'R')

end

%Check Match for parity results
GZ
mZ
pExpected = mZ*GZ
%pObserved = pr(1,seq)
%pObserved = func_rotator(pObserved,2,'L')
pObserved = func_rotator(pr,Lm-1,'R')
%pObserved = pr
matched=isequal(pExpected,pObserved)
expones = sum(pExpected==1)
obsones = sum(pObserved==1)
%matched=isequal(expones,obsones)

bkp=0;
bkp=0;
%while termination condition
if(matched==0)
  proceed=0;
else
  if(timeout>1000)
    proceed=0;
  else
    proceed=1;
  end
end

end
timeout

%We need not check for all possible G. Make G constant, vary msg, and Check Validity.