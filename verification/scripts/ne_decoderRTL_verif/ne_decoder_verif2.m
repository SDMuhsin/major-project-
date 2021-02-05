% BER plotting for Near Earth vs CCSDS
%current comparison: berlist_ccsds_sim10iter
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
%---------------NE matrix--------------%
%submatrixsize 
z=511;
Ggf = gf(func_NE_makeG(),1);
hmatNE = func_makeHNE(z);
[m,n] = size(hmatNE);
Wc = 32;

%Making hmatstorage
hlut = zeros(m,Wc);
maxval=0;

for i=1:m
  hlut(i,:) = find(hmatNE(i,:) ~= 0);
end

%--------------NE matrix----------------%

k = n-m;
RateActual = k/n  
Rateforchannel = 7136/8160
Rate = Rateforchannel;
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
  quanton=1;
  alphalist=[0.75]%[0.75]
  attenf=2;%2;%2;%1;%0.75;
  MaxItrs =2;%25;%20;%12;%20;
  maxinf = (100) %maxval

%-------------Re-Access map---------------%
  mb=m/z; %layers
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
%--------------Re-Access Map-------------------%      

%Looping for various EbNo values
%EbNodB = 2;
%EbNolist = [4 4.2 4.5 5];
alpha = alphalist;
snr=5; %to plot BER Vs Iterations
EbNoreflist=[3.3,3.5,3.7,3.9,4.1,4.2];%to plot BER Vs Iterations
EbNolist = [snr]%[3.3,3.5,3.7,3.9,4.1,4.2];%snr;

EbNodB=snr
EbNo = 10^(EbNodB/10);
sigma = sqrt(1/(2*Rate*EbNo));
Nbiterrs = 0; Nblkerrs = 0; 
Nbiterrs_itr = zeros(1,MaxItrs);
 noisesig = sigma * randn(1,8160); %AWGN channel I %n is 8160
  
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
    
    s = 1 - 2 * cword; %BPSK bit to symbol conversion 
    %noisesig = sigma * randn(1,n); %AWGN channel I
    r = s + noisesig; %s;% 

  %receiver: make 8160 to 8176 code.
     max18 = [(maxinf*ones(1,18))];
     r_unpunc = [max18,r(1,1:end-2)];

    
    %Attenuation(if attenf<1)/Amplification(if attenf>1)
    %attenf = 2;%
    r_atten = attenf*r_unpunc;
    r_unpunc = r_atten;
    
    %quantization procedure
    if(quanton==1)
    rq = resolution*floor(r_unpunc/resolution);%floor(r_unpunc/resolution);%
    rq(rq>limit(2)) = limit(2);
    rq(rq<limit(1)) = limit(1); 
    r_unpunc=rq;
    end
    
    %Soft-decision, iterative message-passing layered decoding 

    L = r_unpunc;%r; %total belief
    
    itr = 0; %iteration number
    Rwc = zeros(m,Wc);%Bug Here: these were not zero initialized for new code.
    Lout = zeros(1,n);
    
   
     while itr < MaxItrs  
      for lyr = 1:2              
%--------RCU + Lmem + Dmem operations--------%
            Dout = zeros(1,n);
        for irow = (lyr-1)*z+1:lyr*z %irow can take values 1 to 511 to 1022. 
           Lwc(1,:) = L(1,[hlut(irow,:)]);
           E_prev = Rwc(irow,:);           
           Lwc(1,:) = Lwc(1,:) - Rwc(irow,:); %Subtraction Step
           
           %quantization limiter
           if(quanton==1)
             Pq = resolution*floor(Lwc(1,:)/resolution);%L((col-1)*z+1:col*z);%
             prte=0;
             Pq(Pq>limit(2)) = limit(2);
             Pq(Pq<limit(1)) = limit(1);
             Lwc(1,:) = Pq;  
             prte=0;
           end
  %---------Print Lwc as Sub output------------% 
            
           %new Rwc or new E for the row is estimated.
           absLwcq = abs(Lwc); 
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
            S = 2*(Lwc>=0)-1;
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
            Lwc(1,[wclistloc(wclistloc!=-1)]) = Lwc(1,[wclistloc(wclistloc!=-1)])+Rwc(irow,[wclistloc(wclistloc!=-1)])+Dout(1,[updllrDsymblist]);  
               
            %quantization limiter
            if(quanton==1)
               Lq = resolution*floor(Lwc(1,:)/resolution);
               Lq(Lq>limit(2)) = limit(2);
               Lq(Lq<limit(1)) = limit(1);
               Lwc(1,:) = Lq;               
               prte=0;    
            end            

  
            %selectively write D symbols and updlLR(Lout) symbols
            
            Dout(1,[Dsymbtowritelist(1,Dsymbtowritelist!=-1)]) = D(1,[find(wclistloc==-1)]);                
            Lout(1,[updllrDsymblist]) = Lwc(1,[wclistloc(wclistloc!=-1)]);
            
  %--------Print Lout as Adder3in output results (Mainly verify the updated part (updllrDsymblist) only)--------------%
  %---------Print Dout as SubD output results (Mainly verify the first access (Dsymbtowritelist) results only)------------%            
              
        end  %row for
        %Update layerwise, LLR with new LLR:
        L = Lout;
        Lout = zeros(1,n);
%--------RCU + Lmem + Dmem operations--------%
        
      end %lyr for  
      
        syspart = L(19:19+ksys-1);
        msg_cap = syspart < 0; %decision
        %Counting errors
        Nerrs = sum(msgksys ~= msg_cap);
        
        itr = itr + 1;

        if Nerrs > 0
		      Nbiterrs_itr(1,itr) = Nbiterrs_itr(1,itr) + Nerrs;
        end
        prte=sprintf("itr=%d, Nerrs=%d",itr,Nerrs)

    end% itr for
    
    
    
    syspart = L(19:19+ksys-1);
    msg_cap = syspart < 0; %decision
    %Counting errors
    %msgint = gf2toint(msg);
    Nerrs = sum(msgksys ~= msg_cap);
    