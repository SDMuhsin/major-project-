% Near earth encoder using Prallel RCE
% Input and Output buffer circuit Patterns
clc
clear all
close all

%%------- Interface circuit patterns ---------%%
K=7136 %systematic part bits
Shortenedpart=18 %shortened number of bits at the beginning
Kunshort=7154 %unshortened systematic part
Z=511 %circulant size or block size
Kb=Kunshort/Z %blocks of systematic part
Lm=16 %parallelism parameter
%making bit indices for verilog array indexing.
msg = [1:K]-1;
fifowritepattern=[];
for i=1:Lm:K
  fifowritepattern=[fifowritepattern;msg(1,[i:1:i+Lm-1])];
end

%zerofilling
%in fiforead pattern, -1 entries: the msg values for these bits should be zero.
%when feeding to MAC network of para RCE.
msg2=[];
for j=1:Kb
  msg2 = [msg2,[[1+(j-1)*Z:Z+(j-1)*Z]-Shortenedpart,0]-1];
end
msg2(1,[1:Shortenedpart]) = -1;
msg2([1:Lm]) = []; %remove first Lm=16 msg bits since they are zeros, no need to multiply.

fiforeadpattern=[];
for i=1:Lm:length(msg2)
  fiforeadpattern=[fiforeadpattern;msg2(1,[i:1:i+Lm-1])];
end

%Output interface: 
%fifo sending pattern is same as fifowritepattern, i.e Lm=16 bits at a time.
%as soon as the input bits are received you can directly start sending.
%it takes K/Lm = 7136/16= 446 cycles to complete the sending of systematic part
% by this time, parity should be ready to send in parts of Lm=16. i.e. encodecycles < 446.
fifotransmitpattern = fifowritepattern;

%%------- Interface circuit patterns ---------%%