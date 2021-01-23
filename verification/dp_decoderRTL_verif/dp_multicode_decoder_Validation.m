% program to generate codeword, intermediate outputs 
%for DP Decoder Validation.
%----------------------------------------------------%
clc
clear all
close all

pkg load communications
%---------------DP matrix--------------%
%submatrixsize 
Ratetxt="4by5"
Msub=128 %if k=1024, r=4/5
har4ja = func_makeHmatrixar4ja(Msub, Ratetxt);
%Making ALT matrix for encoding
foundrows_dp = [2*Msub+1:3*Msub,Msub+1:2*Msub,1:Msub];
[Adp, B12, Cdp, Edp, X_12inv, X_22] = func_preprocess_for_ru_encoder(Msub,har4ja,foundrows_dp);

%MAKE G, in gf2, size(G) = 1024,1280 
%gar4ja_gf2 = func_makeGdeepspace("gf");

%circulantsize 
z=Msub/4
B = func_makebasematrix(har4ja,z);
[mb,nb] = size(B)
k = 1024 %(nb-mb)*z %number of message bits
n = 1280%nb*z %number of codeword bits
Rate = k/n  
%-----------DP H matrix---------%

%------------------------------%
%Quantization parameters
  num_bits = 12%log2(64)
  maxvalue = 256;  
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
  alphalist=[0.75]
  msoffset=0%-0.1%-0.5;
  n_offset_on=0;%adds with min1 and min2 ln(2)-0.5*abs(Q)
  attenf=2;%2;%1;%0.75;
  MaxItrs =2;%25;%20;%12;%20;
%------------------------------%  

alpha=alphalist

EbNolist = [5];%[3:0.5:5];
NoiseBlocks=1;
Nblocks=2;%1;
LAYER2CHECK = 11;%0;%0 to 11, 12 layer indices
ITER2CHECK = 1;%0;

% Save msg and cword at initial run, then do loading at subsequent runs
for codeidx = 0:1:Nblocks-1 %verilog numbering
save_en=1;
if(save_en)
%for
EbNodB = EbNolist
EbNo = 10^(EbNodB/10);
sigma = sqrt(1/(2*Rate*EbNo));

  noisesig = sigma * randn(1,n); %AWGN channel I %n is 1280
  filename = sprintf('./outputs/dp_NoiseSigfrmMatlabsave_codeidx%d.txt',codeidx);
  save(filename,'noisesig');

  %Random msg
   msg = randi([0 1],1,k); %generate random k-bit message
   filename = sprintf('./outputs/dp_MsgfrmMatlabsave_codeidx%d.txt',codeidx);
   save(filename,'msg');
        hex_en=1;bin_en=0;print_en=1;
filename = sprintf('dp_msg_frame_Input_codeidx%d.txt',codeidx);%sprintf('Linwc_data.txt');
msg_input_printed = function_fprint_LLR_dp(filename,msg,1,1,0,print_en,hex_en,bin_en);
          
	%Encoding 
    cwordunpunc = func_ru_encoder(Msub,msg, Adp, B12, Cdp, Edp, X_12inv, X_22);
    cword = cwordunpunc(1,1:n);
   filename = sprintf('./outputs/dp_CodewordfrmMatlabsave_codeidx%d.txt',codeidx);
   save(filename,'cword');   
    s = 1 - 2 * cword; %BPSK bit to symbol conversion 
    %noisesig = sigma * randn(1,n); %AWGN channel I
    r = s + noisesig; %s;% 
    
    r_unpunc = [r,zeros(1,1408-1280)];
    
    %Attenuation
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
    

    L = r_unpunc;%r; %total belief
    
    hex_en=0;bin_en=1;
    filename = sprintf('./outputs/dp_LdatafrmMatlabsave_codeidx%d.txt',codeidx);
 save(filename,'L');
 filename = sprintf('dp_L_data_symbols_codeidx%d.txt',codeidx);
  Linprinted = function_fprint_LLR(filename,L,resolution,num_bits,0,1,hex_en,bin_en);
    hex_en=1;bin_en=0;
    filename = sprintf('dp_L_data_frame_codeidx%d.txt',codeidx);
  Linprinted2 = function_fprint_LLR_dp(filename,L,resolution,num_bits,0,1,hex_en,bin_en);

  else  
  filename = sprintf('./outputs/dp_NoiseSigfrmMatlabsave_codeidx%d.txt',codeidx);
  load(filename,'noisesig');
  filename = sprintf('./outputs/dp_MsgfrmMatlabsave_codeidx%d.txt',codeidx);
  load(filename,'msg');
  filename = sprintf('./outputs/dp_CodewordfrmMatlabsave_codeidx%d.txt',codeidx);
  load(filename,'cword');
  %Soft-decision, iterative message-passing layered decoding 
  filename = sprintf('./outputs/dp_LdatafrmMatlabsave_codeidx%d.txt',codeidx);
  load(filename,'L');   
end

   %Soft-decision, iterative message-passing layered decoding 
    Slen = sum(B(:)~=-1); %number of non -1 in B
    treg = zeros(max(sum(B ~= -1,2)),z); %register storage for minsum
    
 print_en=0;hex_en=0; bin_en=0;
    itr = 0; %iteration number
    R = zeros(Slen,z); %storage for row processing
    %for printing Lmem ram dout
    updLLR_Lmem_ramdout=L;    
    while itr < MaxItrs
        Ri = 0;       
        for lyr = 1:mb
            ti = 0; %number of non -1 in row=lyr 
 
            %Enabling print condition
            if((itr == ITER2CHECK)&&(lyr==LAYER2CHECK+1))%&&(irow==1022))
              print_en=1;hex_en=0;bin_en=1;
            else
              print_en=0;hex_en=0;bin_en=0;
            end 
            %Enabling Debug condition
            %if((itr == 1)&&(lyr==2))%&&(irow==1022))
            %  debug=0;
            %else
            %  debug=0;
            %end            
            %print_en=0;                        
            
            
            Lin_tosiso=zeros(1,44*z);
            Euncompin_tosiso=zeros(z,18);
            Euncompin_tosiso_hex=zeros(1,z*18);
            idxoffset=0;
            Lin44tosiso=zeros(z,44);
            Lin44tosiso_hex=zeros(1,44*z);
            L_44to18_setup=zeros(z,18);
            L_44to18_setup_hex=zeros(1,z*18);
            Lvalid_44to18_setup = zeros(z,18);
            Q_18=zeros(z,18);
            Q_18_hex=zeros(1,z*18);
            
            collist=find(B(lyr,:) ~= -1);
            wt= length(collist);
            for col = collist%find(B(lyr,:) ~= -1)
                   ti = ti + 1;
                   Ri = Ri + 1; 
                   %For printing 
                   %1. Lmem+shifter output
                   Lin_tosiso((col-1)*z+1:col*z) =  mul_sh(L((col-1)*z+1:col*z),B(lyr,col));
                   %2. Setup circuit
                   idxoffset=idxoffset+1;
                   loc = 18-wt + idxoffset;
                   Lin44tosiso(:,col) = (transpose(Lin_tosiso((col-1)*z+1:col*z)));
                   L_44to18_setup(:,loc)=(transpose(Lin_tosiso((col-1)*z+1:col*z)));
                   Lvalid_44to18_setup(:,loc)=(ones(z,1));       
                   %3. Euncomp used for Sub
                   Rshifted = mul_sh(R(Ri,:),B(lyr,col));
                   Euncompin_tosiso(:,loc)=(transpose(Rshifted));
       
                   %Subtraction
                   L((col-1)*z+1:col*z) = L((col-1)*z+1:col*z)-R(Ri,:);
                 
                   %quantization limiter
                   if(quanton==1)
                   Pq = resolution*floor(L((col-1)*z+1:col*z)/resolution);%L((col-1)*z+1:col*z);%
                   prte=0;
                   Pq(Pq>limit(2)) = limit(2);
                   Pq(Pq<limit(1)) = limit(1);
                   L((col-1)*z+1:col*z) = Pq;   
                   prte=0;
                   end
                   %Row alignment and store in treg
                   treg(ti,:) = mul_sh(L((col-1)*z+1:col*z),B(lyr,col)); 
                   
                   %For printing
                   %4. Sub output Q
                   Q_18(:,loc)=(transpose(treg(ti,:)));
            end
            
            for zi=1:z
              Lin44tosiso_hex(1,(zi-1)*44+1:zi*44) = Lin44tosiso(zi,:);
              L_44to18_setup_hex(1,(zi-1)*18+1:zi*18) = L_44to18_setup(zi,:);
              Euncompin_tosiso_hex(1,(zi-1)*18+1:zi*18)=Euncompin_tosiso(zi,:);
              Q_18_hex(1,(zi-1)*18+1:zi*18)=Q_18(zi,:);
            end
     prte=0;
     prte=0;     
filename = sprintf('L_ramdout_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
L_ramdout_printed = function_fprint_LLR_dp(filename,updLLR_Lmem_ramdout,resolution,num_bits,0,print_en,1,0);          
     
filename = sprintf('Lin_tosiso_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);%sprintf('Linwc_data.txt');
Lin_tosisohex_printed = function_fprint_LLR_dp(filename,Lin_tosiso,resolution,num_bits,0,print_en,1,0);          

filename = sprintf('Lin44tosisohex_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
Lin44tosisohex_allrows_printed = function_fprint_LLR_dp(filename,Lin44tosiso_hex,resolution,num_bits,0,print_en,1,0);          

filename = sprintf('L_44to18_setup_hex_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
L_44to18_setup_hex_allrows_printed = function_fprint_LLR_dp(filename,L_44to18_setup_hex,resolution,num_bits,0,print_en,1,0);          

filename = sprintf('Euncompinhex_allrows_data_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
euncompinhex_allrows_printed = function_fprint_LLR_dp(filename,Euncompin_tosiso_hex,resolution,num_bits,0,print_en,1,0);          

filename = sprintf('Qhex_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
Qhex_allrows_printed = function_fprint_LLR_dp(filename,Q_18_hex,resolution,num_bits,0,print_en,1,0);          
             
            %Row Parsing: minsum on treg: ti x z
            normQ_18=zeros(z,18);
            normQ_18_hex=zeros(1,z*18);
            newEuncomp=zeros(z,18);
            newEuncomp_hex=zeros(1,z*18);
            
            for i1 = 1:z %treg(1:ti,i1)
                absQ = abs(treg(1:ti,i1));%absQ has size (1:ti, 1)
                absQalpha = (absQ+msoffset)*alpha;               
                absQ = absQalpha;
                %quantization limiter
                if(quanton==1)
                absQq = resolution*floor(absQ/resolution);%absQ;
                absQq(absQq>limit(2)) = limit(2);
                absQ=absQq;
                end
                     
                %For printing
                %5. Normaliser output =alpha* abs of Q
                normQ_18(i1,:) = [zeros(1,18-length(absQ)), transpose(absQ)]; 
                normQ_18_hex(1,(i1-1)*18+1:i1*18)=normQ_18(i1,:);      
                prte=0;
                
                %Minfind
                [min1,pos] = min(absQ); %first minimum
                min2 = min(absQ([1:pos-1 pos+1:ti],1)); %second minimum

                S = 2*(treg(1:ti,i1)>=0)-1;
                parity = prod(S);
                prte=0;  

                treg(1:ti,i1) = min1; %absolute value for all
                treg(pos,i1) = min2; %absolute value for min1 position
                treg(1:ti,i1);


                treg(1:ti,i1) = parity*S.*treg(1:ti,i1); %assign signs
                
                %For printing
                %6. new Euncomp
                newEuncomp(i1,:)=[min1*ones(1,18-length(absQ)), transpose(treg(1:ti,i1))];
                newEuncomp_hex(1,(i1-1)*18+1:i1*18)=newEuncomp(i1,:);  
            end

            prte=0;
            prte=0;
%            if(debug==1)
%              for i=[17,70,71,214]
%                for i1=1:z
%                  chk1=[(i1-1)*18+1:i1*18];
%                  chk2=find(chk1==i+1);
%                  if(length(chk2)!=0)%if found
%                     txt=sprintf("Found i+1=%d, in i1=%d at chk2=%d",i+1,i1,chk2)
%                     normQ_18(i1,:)
%                     txt=sprintf("newEuncomp(i1,chk2)=%d\n",newEuncomp(i1,chk2))
%                  end
%                end%i1=1:zloop
%                %txt=sprintf("i+1=%d, newEuncomp_hex[1,i+1]=%d\n",i+1,newEuncomp_hex(1,i+1))
%              end%i=list loop               
%            end
filename = sprintf('normQ_18hex_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
normQ_18hex_allrows_printed = function_fprint_LLR_dp(filename,normQ_18_hex,resolution,num_bits-1,0,print_en,1,0);          

filename = sprintf('newEuncomphex_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);
newEuncomp_hex_allrows_printed = function_fprint_LLR_dp(filename,newEuncomp_hex,resolution,num_bits,0,print_en,1,0);          
            
            %column alignment, addition and store in R
            updLLR_18=zeros(z,18);
            updLLR_18_hex=zeros(1,z*18);
            updLLR_18to44_desetup=zeros(z,44);
            updLLR_18to44_desetup_hex=zeros(1,z*44);
            updLLR_Lmem_in=zeros(1,44*z);
            idxoffset=0;
            
            Ri = Ri - ti; %reset the storage counter
            ti = 0;
            for col = collist%find(B(lyr,:) ~= -1)
                    Ri = Ri + 1;
                    ti = ti + 1;
                    %Column alignment
                    R(Ri,:) = mul_sh(treg(ti,:),z-B(lyr,col));
                    %Addition
                    L((col-1)*z+1:col*z) = L((col-1)*z+1:col*z)+R(Ri,:);

                    %quantization limiter
                    if(quanton==1)
                    Lq = resolution*floor(L((col-1)*z+1:col*z)/resolution);%L((col-1)*z+1:col*z);%
                    Lq(Lq>limit(2)) = limit(2);
                    Lq(Lq<limit(1)) = limit(1);
                    L((col-1)*z+1:col*z) = Lq;               
                    prte=0;    
                    end
                  
                  %For printing
                  %7. Add output
                  idxoffset=idxoffset+1;
                  loc= 18-wt + idxoffset;
                  updLLR_18(:,loc) = transpose( mul_sh(L((col-1)*z+1:col*z),B(lyr,col)) );
                  
                  %8. Desetup output
                  updLLR_18to44_desetup(:,col)=transpose( mul_sh(L((col-1)*z+1:col*z),B(lyr,col)) );
                  %9. updLLR to Lmem input
                  updLLR_Lmem_in(1,(col-1)*z+1:col*z) = mul_sh(L((col-1)*z+1:col*z),B(lyr,col));
                  %10. Save Ramdout to print in next layer/iter:
                  updLLR_Lmem_ramdout(1,(col-1)*z+1:col*z) = mul_sh(L((col-1)*z+1:col*z),B(lyr,col));
                  prte=0;
                  prte=0; 
            end
            
            for zi=1:z
              updLLR_18_hex(1,(zi-1)*18+1:zi*18)=updLLR_18(zi,:);
              updLLR_18to44_desetup_hex(1,(zi-1)*44+1:zi*44)=updLLR_18to44_desetup(zi,:);
            end
            lyr
            prte=0;
            prte=0;
            
filename = sprintf('updLLR_18_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);%sprintf('Linwc_data.txt');
updLLR_18_allrows_printed = function_fprint_LLR_dp(filename,updLLR_18_hex,resolution,num_bits,0,print_en,1,0);  

filename = sprintf('updLLR_18to44_desetup_allrows_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);%sprintf('Linwc_data.txt');
updLLR_18to44_desetup_allrows_printed = function_fprint_LLR_dp(filename,updLLR_18to44_desetup_hex,resolution,num_bits,0,print_en,1,0);  

filename = sprintf('updLLR_Lmem_inhex_lyr%d_itr%d_codeidx%d.txt',lyr,itr,codeidx);%sprintf('Linwc_data.txt');
updLLR_Lmem_inhex_printed = function_fprint_LLR_dp(filename,updLLR_Lmem_in,resolution,num_bits,0,print_en,1,0);          

        end %lyr for
        
        %For printing 10. msg frame output at each iteration
        if(itr==MaxItrs-1) 
          msg_cap = L(1:k) < 0; %decision
            hex_en=1;bin_en=0;print_en=1;
            %print_en=0;
filename = sprintf('dp_msg_frame_itr%d_codeidx%d.txt',itr,codeidx);%sprintf('Linwc_data.txt');
msg_cap_printed = function_fprint_LLR_dp(filename,msg_cap,1,1,0,print_en,hex_en,bin_en);
       end
    
      itr=itr+1
      prte=0;
      prte=0;
      
    end% itr while
    
end %codeidx for loop  
%--------------DP matrix----------------%