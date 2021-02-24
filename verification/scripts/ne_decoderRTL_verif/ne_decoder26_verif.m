%Near Earth Decoder Verification Reference Model
%Prints the intermediate results to file in ./outputs/ iff file_printing_en=1
%hex_en=0,bin_en=1 : Prints binary bits of each symbol in each line in a file
%hex_en=1, bin_en=1 : Prints Hex char of each symbol in each line in a file
%hex_en=1, bin_en=0 : Concatenates all symbols to one list and prints in Hex in single line in a file
%Option to selectively print results for ITR2CHK (1 to MaxItrs), LYR2CHK (1 to 2), SLICE2CHK (1 to 20)
clc
clear all
close all
%--------------------------------------%
%if using matlab to run this script make this var 1
matlab_on=0
if(matlab_on==0)
%% octave compatibility line
pkg load communications
end
%------------------------------%
%Quantization parameters
  num_bits = 6%log2(64)
  maxvalue = 8; 
  inprange = [-maxvalue,maxvalue];
  totrange = 2*maxvalue;
  totlevels = 2^num_bits; %total inprange split into these many levels
  maxqlevels_S = 2^(num_bits-1);%magnitude levels
  integlimits = [-(maxqlevels_S),(maxqlevels_S)-1];
  resolution = maxvalue/maxqlevels_S
  limit = resolution.*integlimits%integlimits%
  integpart = log2(maxvalue)
  fracpart = abs(log2(resolution))
  quanton=1; %1: Enable quantisation
%Decoder/receiver parameters:  
  asmbits=64
  alpha=0.75%[0.75]
  ampf=2;%2;%2;%1;%0.75;
  MaxItrs =2;%25;%20;%12;%20;
  maxinf = (100) %after wuatisation operation it is same as same as maxval
%Channel parameter:
  snr=4.2; 
  EbNoreflist=[3.3,3.5,3.7,3.9,4.1,4.2];%SNR Reference values as per CCSDS BER plots
% Verification print Parameters: 
  ITR2CHK=1;%2;
  LYR2CHK=1;%2;
  SLICE2CHK=1;%20;
  file_printing_en=1;%0;
%---------------NE matrix--------------%
%Circulant size(z)
z=511;
Ggf = gf(func_NE_makeG(),1);
hmatNE = func_makeHNE(z);
[m,n] = size(hmatNE);
Wc = 32;
mb=m/z; %layers

%Making hmatstorage
hlut = zeros(m,Wc);
maxval=0;

for i=1:m
  hlut(i,:) = find(hmatNE(i,:) ~= 0);
end

k = n-m;
RateActual = k/n  
Rateforchannel = 7136/8160
Rate = Rateforchannel;

%-------------Re-Access map---------------%
  writtensymblist_mat=(-1)*ones(m,Wc);
  updllrDsymblist_mat=(-1)*ones(m,Wc);
  Dsymbtowritelist_mat= (-1)*ones(m,Wc);
  wclistloc_mat = (-1)*ones(m,Wc);
      for lyr = 1:mb                      
              writtensymblist=[];
              index=0;
        for irow = (lyr-1)*z+1:lyr*z %irow can take values 1 to 511 to 1022. 
            index=index+1;
            %Find Reaccess : find if written previously
            symblist = hlut(irow,:);
            Dsymbtowritelist = symblist;
            updllrDsymblist = [];
            wclistloc=(-1)*ones(1,32);%[];
            if(irow>(lyr-1)*z+1)
              %correct symblist
              for symb = symblist
                if(length(find(writtensymblist==symb))!=0) %if symb found in written lists
                   wclistloc(1,find(symblist==symb))=find(symblist==symb);
                   Dsymbtowritelist(1,find(Dsymbtowritelist==symb)) = -1;
                   updllrDsymblist=[updllrDsymblist,symb];     
                else
                   updllrDsymblist=[updllrDsymblist,-1];     
                end
              end             
              writtensymblist =[writtensymblist;Dsymbtowritelist];
            else
              updllrDsymblist = (-1)*ones(1,32);
              writtensymblist = [writtensymblist;Dsymbtowritelist];
            end
            writtensymblist_mat(irow,:) = writtensymblist(index,:);
            updllrDsymblist_mat(irow,:) = updllrDsymblist;
            Dsymbtowritelist_mat(irow,:) = Dsymbtowritelist;
            wclistloc_mat(irow,:) = wclistloc;
        end  %row for        
      end %lyr for    

%------Encoding and Channel Noise Addition and Receiver------------%
    EbNodB=snr
    EbNo = 10^(EbNodB/10);
    sigma = sqrt(1/(2*Rate*EbNo));

    %noisesig = sigma * randn(1,8160); %AWGN channel I %n is 8160
    noisesig = sigma * randn(1,8160+asmbits); %AWGN channel I %n is 8160 
	  %Encoding 
    %generate random ksys-bit message
     ksys=7136;
     msgksys = randi([0 1],1,ksys);
    %make k=7154-bit msg frm ksys=7136-bit msg;
     msg = [zeros(1,18),msgksys]; 
     msggf = gf([zeros(1,18),msgksys],1);
    %generating 8160 code frm 8176 code.
     code = msggf*Ggf;
     codetx = [code(19:end),gf(zeros(1,2),1)];
     cword = gf2toint(codetx);
    
%    s = 1 - 2 * cword; %BPSK bit to symbol conversion 
%    %noisesig = sigma * randn(1,n); %AWGN channel I
%    r = s + noisesig; %s;% 
%
%  %receiver: make 8160 to 8176 code.
%     max18 = [(maxinf*ones(1,18))];
%     r_unpunc = [max18,r(1,1:end-2)];
%
%    
%    %Amplification
%    %ampf = 2;%
%    r_atten = ampf*r_unpunc;
%    r_unpunc = r_atten;
%    
%    %quantization procedure
%    if(quanton==1)
%    rq = resolution*floor(r_unpunc/resolution);%floor(r_unpunc/resolution);%
%    rq(rq>limit(2)) = limit(2);
%    rq(rq<limit(1)) = limit(1); 
%    r_unpunc=rq;
%    end
%    
%    %Soft-decision, iterative message-passing layered decoding 
%
%    L = r_unpunc;%r; %total belief

   % Attaching 64 bit ASM marker
     asm_marker = randi([0 1],1,asmbits);
     cword_tx = [asm_marker, cword];
    %transmitted BPSK = s
    s = 1 - 2 * cword_tx; %BPSK bit to symbol conversion 
    
    %received code=r = Tx BPSK + Channel Noise addition
    r = s + noisesig; %s;% %AWGN channel I

    %reciever Amplification and Quantisation:
    r_short=ampf*r; 
    if(quanton==1)
      rq = resolution*floor(r_short/resolution);
      rq(rq>limit(2)) = limit(2);
      rq(rq<limit(1)) = limit(1); 
      r_short=rq;
    end
  
  %input interface: remove asm part and make 8160 to 8176 code.
     max18 = [(maxinf*ones(1,18))];
     r_unshort = [max18,r_short(1,asmbits+1:end-2)];
    
  %decoder input
    L = r_unshort;%total belief
    
%--------Decoder P26-----------% 
    itr = 0; %iteration number
    Rwc = zeros(m,Wc);%Bug Here: these were not zero initialized for new code.
    Lout = zeros(1,n);
 
startrows_lyr1=[1:26:511];
stoprows_lyr1=[26:26:511,511];
startrows_lyr2=[512:26:1022];
stoprows_lyr2=[512+26-1:26:1022,1022];
while itr < MaxItrs  
 for lyr = 1:2  
 %--------RCU + Lmem + Dmem operations--------%
  Dout = zeros(1,n);
  for sliceaddress=1:20
    if(lyr==1)
      startrow=startrows_lyr1(1,sliceaddress);
      stoprow=stoprows_lyr1(1,sliceaddress);
    else
      startrow=startrows_lyr2(1,sliceaddress);
      stoprow=stoprows_lyr2(1,sliceaddress);
    end
    rowlist = [startrow:1:stoprow];
    pidx=0;
    %---Verification: 26 symbol lists to collect results and print to file-----%
    Lwclist=[];
    Eprevlist=[];
    Qwclist=[];
    absLwclist=[];
    Enewlist=[];
    Dlist=[];
    Dreaccesslist=[];
    updLwclist=[];
    for irow=rowlist
      pidx=pidx+1;%1 to 26
           Lwc(1,:) = L(1,[hlut(irow,:)]);
           E_prev = Rwc(irow,:);           
           Qwc(1,:) = Lwc(1,:) - Rwc(irow,:); %Subtraction Step           
           %quantization limiter
           if(quanton==1)
             Pq = resolution*floor(Qwc(1,:)/resolution);%L((col-1)*z+1:col*z);%
             prte=0;
             Pq(Pq>limit(2)) = limit(2);
             Pq(Pq<limit(1)) = limit(1);
             Qwc(1,:) = Pq;  
             prte=0;
           end
  %---------Print Qwc as Sub output------------% 
           %new Rwc or new E for the row is estimated.
           absLwcq = abs(Qwc); 
           absLwcqalpha = alpha*(absLwcq);
           absLwcq = absLwcq;
              %quantization limiter
              if(quanton==1)
                absLwcq_quant = resolution*floor(absLwcq/resolution);%absQ;
                absLwcq_quant(absLwcq_quant>limit(2)) = limit(2);
                absLwcq=absLwcq_quant;
              end           
  %---------Print absLwcq as Abs+Norm outputs------------%
            [min1,pos] = min(absLwcq); %first minimum
            min2 = min(absLwcq(1,[1:pos-1 pos+1:end])); %second minimum                     
            S = 2*(Qwc>=0)-1;
            parity = prod(S);            
            Rwc(irow,:) = min1; %absolute value for all
            Rwc(irow,pos) = min2; %absolute value for min1 position
            Rwc(irow,:) = parity*S.*Rwc(irow,:); %assign signs
            E_new = Rwc(irow,:);
  %---------Print E_new as Recovered Minfinder output results------------%
            
            %Finding D 
            D = E_new - E_prev;
            %quantization limiter
            if(quanton==1)
               Dq = resolution*floor(D/resolution);
               Dq(Dq>limit(2)) = limit(2);
               Dq(Dq<limit(1)) = limit(1);
               D = Dq;               
               prte=0;    
            end   
 
            %Find Reaccess : find if written previously
            Dsymbtowritelist = Dsymbtowritelist_mat(irow,:);%symblist;
            updllrDsymblist = updllrDsymblist_mat(irow,(updllrDsymblist_mat(irow,:)!=-1));%[];
            wclistloc=wclistloc_mat(irow,:);%(-1)*ones(1,32);%[];
            
            %selective update LLR
            updLwc=L(1,[hlut(irow,:)]);
            DreaccessWc = (limit(2))*ones(1,32);
            DreaccessWc(1,[wclistloc(wclistloc!=-1)])= Dout(1,[updllrDsymblist]);
            updLwc(1,[wclistloc(wclistloc!=-1)]) = Qwc(1,[wclistloc(wclistloc!=-1)])+Rwc(irow,[wclistloc(wclistloc!=-1)])+Dout(1,[updllrDsymblist]);  
            %quantization limiter
            if(quanton==1)
               Lq = resolution*floor(updLwc(1,:)/resolution);
               Lq(Lq>limit(2)) = limit(2);
               Lq(Lq<limit(1)) = limit(1);
               updLwc(1,:) = Lq;               
               prte=0;    
            end            

            %selectively write D symbols and updlLR(Lout) symbols
            Dout(1,[Dsymbtowritelist(1,Dsymbtowritelist!=-1)]) = D(1,[find(wclistloc==-1)]);                
            Lout(1,[updllrDsymblist]) = updLwc(1,[wclistloc(wclistloc!=-1)]);
  %--------Print Lout as Adder3in output results (Mainly verify the updated part (updllrDsymblist) only)--------------%
  %---------Print Dout as SubD output results (Mainly verify the first access (Dsymbtowritelist) results only)------------%
%------Collecting the symbols for the row---------%  
    #fprintf(" [COLLECTING STUFF TO PRINT] slice = %d ",sliceaddress);
    Lwclist=[Lwclist,Lwc];
    Eprevlist=[Eprevlist,E_prev];
    Qwclist=[Qwclist,Qwc];
    absLwclist=[absLwclist,absLwcq];
    Enewlist=[Enewlist,E_new];
    Dlist=[Dlist,D];
    Dreaccesslist=[Dreaccesslist,DreaccessWc];
    updLwclist=[updLwclist,updLwc];   
    
      prte=0;
    end%irow for

%----one 26 set of 32 symbols are collected in the lists: now print them to file.---%    
   if(file_printing_en)
    if((itr==ITR2CHK-1)&&(lyr==LYR2CHK)&&(sliceaddress==SLICE2CHK))
      abs_en=0;print_en=1;hex_en=0;bin_en=1; %print one long hex characters of all symbols in first line.
      %abs_en=0;print_en=1;hex_en=0;bin_en=1; %print binary bits of each symbol in each line
      size(Lwclist)
      fprintf("[ PRINT] size(Lwclist");
      prte=0;
    else
      abs_en=0;print_en=0;hex_en=0;bin_en=0;
    end
    
    filename=sprintf("Lwclist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,Lwclist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    
    filename=sprintf("Eprevlist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,Eprevlist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    
    filename=sprintf("Qwclist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,Qwclist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    
    abs_en=1;
    filename=sprintf("absLwclist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,absLwclist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    abs_en=0;
    
    filename=sprintf("Enewlist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,Enewlist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    
    filename=sprintf("Dlist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,Dlist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    
    filename=sprintf("Dreaccesslist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,Dreaccesslist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
    
    filename=sprintf("updLwclist_itr%d_lyr%d_slice%d.txt",itr+1,lyr,sliceaddress);
    prt=function_fprint_LLR_ne(filename,updLwclist,resolution,num_bits,abs_en,print_en,hex_en,bin_en);
   end
    
  end%sliceaddress for
   %Update layerwise, LLR with new LLR:
   L = Lout;
   Lout = zeros(1,n);  
 end%lyr for         

itr = itr + 1;      
syspart = L(19:19+ksys-1);
msg_cap = syspart < 0; %decision
%Counting errors
%Nerrs = sum(msgksys ~= msg_cap);
%prte=sprintf("itr=%d, Nerrs=%d",itr,Nerrs)

end%while itr
%--------Decoder 26-----------%

    syspart = L(19:19+ksys-1);
    msg_cap = syspart < 0; %decision
    %Counting errors
    %msgint = gf2toint(msg);
    %Nerrs = sum(msgksys ~= msg_cap);
      
