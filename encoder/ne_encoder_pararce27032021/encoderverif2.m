%Near earth Para RCE Encoder Validation
%for 16 prepend zeros removed case:
clc
clear all
close all
pkg load communications
%
Z=511
KB=14
Lm=16
k=7136
zprepend=18
zcompressprepend=2%18

znum=Lm*(ceil(Z/Lm)) -Z %num of zeros to append
seq=func_getparityshiftsequence(Z,Lm)+1;

%generate G matrix parity part for Near earth:
Gne= func_NE_makeG();
Gne_p= Gne(:,KB*Z + 1:end); 

MB = size(Gne_p)(2)/Z
%generate random msg:
mZ=gf([zeros(1,zcompressprepend),randi([0,1],1,k)],1);

%initialize:
pr=gf(zeros(MB,Z),1);

%Do parallel RCE mul for each circulant:
for blkcol = 1:MB
  GZ = Gne_p(:,(1+(blkcol-1)*Z):(blkcol*Z));
for circ=1:KB

  
  %Fetch the circ row and shift right
  %by 2 for counteracting parity register shift. for zerocompressprepend=18
  circrow = GZ((1+(circ-1)*Z),:);
  %circrow = func_rotator(circrow,Z-2,'R');
  if(circ==1)
    circrow = func_rotator(circrow,0,'R'); %circ=1, line510 is 2=(circ+1) left shifts
  else
    circrow = func_rotator(circrow,Lm+1,'R'); %circ=2, line 509 is 3=(circ+1) left shifts
  end
  
  %Further to correct shift for zero insertions at boundaries,
  %right shift by 'circ-1':  for zerocompressprepend=18.
  circrow = func_rotator(circrow,(circ-1),'R');
  
  %Feed the circulant bits to Lm row MAC network (i.e. a left rotated matrix):
  mac_circ = func_makemacLm(circrow,Lm);
  
  %append zeros to Z-bit block of msg mZ
  if(circ==1)
    %1 to 511-16 = 1 to 495
    st=1;
    en=(Z-(zprepend-zcompressprepend));%495
    m_circz = gf([mZ(st:en),zeros(1,znum)],1);
  else
    %495+1 to 495+1+511-1, 495+1+511 to 495+1+511+511-1, ... 
    st=Z-(zprepend-zcompressprepend)+1+(circ-2)*Z;
    en=Z-(zprepend-zcompressprepend)+(circ-1)*Z;
    m_circz = gf([mZ(st:en),zeros(1,znum)],1);
  end
  %bit reverse the message to feed MSB first:
  m_circz = flip(m_circz);
  
  %Divide zero appended, bitreversed msg into Lm sections:
  mLm=[];
  for i=1:Lm:size(m_circz)(2)
    mLm = [mLm;m_circz(1,i:i+(Lm-1))];  
  end
  %mLm
  %Multiply msg with circulant bits in the MAC network to get u for all the cycles:
  u_circ = mLm*mac_circ;
  
  %manual for loop MAC-mul is same as above matrix based MAC-mul.
%  u_circ=gf(zeros(size(mZLm_circ)(1),Z),1);
%  for i=1:size(mZLm_circ)(1)
%    for j=1:Lm
%      u_circ(i,:) = u_circ(i,:)+ mZLm_circ(i,j)*mac_circ(j,:);
%    end
%  end
%  u_circ
  
  %Shift and add u based on Rule2 (parity shift seq) based on Addition Rule:
  for i=1:size(u_circ)(1)
    pr(blkcol,:) = func_rotator(pr(blkcol,:),Lm,'R')+u_circ(i,:);
  end
  
  %pr = pr(1,seq)
  %pr = func_rotator(pr,1,'R')
  bkp=0;
  bkp=0;
end %blkrow/circ for

%Check Match for parity results
blkcol
pExpected = [zeros(1,18-zcompressprepend),mZ]*GZ;
pObserved  = pr(blkcol,:);
%pObserved = func_rotator(pr(blkcol,:),2,'R');
matched=isequal(pExpected,pObserved)
expones = sum(pExpected==1)
obsones = sum(pObserved==1)

if(matched==0)
  %search:
  for shift=1:Z-1
    chk_pr = func_rotator(pr(blkcol,:),shift,'R');
    matched=isequal(pExpected,chk_pr);
    if(matched)
      prt = sprintf(" blkcol=%d, Matched at rightshift=%d\n",blkcol,shift)
      break;
      bkp=0;
      bkp=0;
    end
  end
  if(matched==0)
    prt = sprintf(" blkcol=%d,Not matched at any right shift\n",blkcol)
  end
end


end %blkcol for

prconcatenate = [pr(1,:),pr(2,:)];
%Check Match for parity results
pExpected = [zeros(1,18-zcompressprepend),mZ]*Gne_p;
%pObserved = [pr(1,seq),pr(2,seq)]
%pObserved = [func_rotator(pr(1,:),2,'R'),func_rotator(pr(2,:),2,'R')];
pObserved = prconcatenate;
matchedtotalparity=isequal(pExpected,pObserved)
expones = sum(pExpected==1)
obsones = sum(pObserved==1)
%matched=isequal(expones,obsones)

bkp=0;
bkp=0;