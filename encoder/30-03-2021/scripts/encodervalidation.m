%Near earth Para RCE Encoder Validation
% Validation Successful for 18 zero prepended case.
clc
clear all
close all
pkg load communications
%
Z=511
KB=14
Lm=16
k=7136

znum=Lm*(ceil(Z/Lm)) -Z %num of zeros to append
seq=func_getparityshiftsequence(Z,Lm)+1;

%generate G matrix parity part for Near earth:
Gne= func_NE_makeG();
Gne_p= Gne(:,KB*Z + 1:end); 

MB = size(Gne_p)(2)/Z
%generate random msg:
msg = randi([0,1],1,k);

write_input_446x16(msg);
mZ=gf([zeros(1,18),msg],1);

%O> initialize for every new msg:
pr=gf(zeros(MB,Z),1);

%Do parallel RCE mul for each circulant:
for blkcol = 1:MB
  GZ = Gne_p(:,(1+(blkcol-1)*Z):(blkcol*Z));
for circ=1:KB
  
  %I> Fetch the circ row of G parity part :
  circrow = GZ((1+(circ-1)*Z),:);  
  %shift right by 2 for compensating parity register shift:
  circrow = func_rotator(circrow,2,'R');  
  %and shift it by 'circ-1' right due to zero insertions:
  circrow = func_rotator(circrow,circ-1,'R');
  
  %Make left shift MAC network (i.e. a left rotated matrix):
  mac_circ = func_makemacLm(circrow,Lm);
  
  %II> Fetch Z bit msg blocks: Input Memory to Feeder operations:
  %1.append zeros to boundaries
  m_circz = gf([mZ(1+(circ-1)*Z:circ*Z),zeros(1,znum)],1);
  
  %2.bit reverse the message to feed MSB first:
  m_circz = flip(m_circz);
  %3.Divide zero appended, bitreversed msg into Lm sections:
  mZLm_circ=[];
  for i=1:Lm:size(m_circz)(2)
    mZLm_circ = [mZLm_circ;m_circz(1,i:i+(Lm-1))];  
  end
  %mZLm_circ
  
  %III> MAC operations:
  %Multiply msg with circulant bits in the MAC network to get u for all the cycles:
  u_circ = mZLm_circ*mac_circ;
  
  %IV> Parity Shift and Add logic: Simplified using Addition rule:
  for i=1:size(u_circ)(1)
    pr(blkcol,:) = func_rotator(pr(blkcol,:),Lm,'R')+u_circ(i,:);
  end
  
  %pr = pr(1,seq)
  %pr = func_rotator(pr,1,'R')

end %blkrow/circ for

%Check Match for parity results
blkcol
pExpected = mZ*GZ;
pObserved  = pr(blkcol,:);
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

%V> Output loading Operations: Directly concatenate
% and parallle load to output shift reg.
prconcatenate = [pr(1,:),pr(2,:)];
%Check Match for parity results
pExpected = mZ*Gne_p;
write_op_511x16( [mZ.x, pExpected.x]);

%pObserved = [pr(1,seq),pr(2,seq)]
%pObserved = [func_rotator(pr(1,:),2,'R'),func_rotator(pr(2,:),2,'R')]; %make this shift correction in f
pObserved = prconcatenate;
matchedtotalparity=isequal(pExpected,pObserved)
expones = sum(pExpected==1)
obsones= sum(pObserved==1)
%matched=isequal(expones,obsones)

bkp=0;
bkp=0;