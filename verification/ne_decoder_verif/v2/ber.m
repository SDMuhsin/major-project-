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

lys = 2;
Wc = 32;
z = 511;
p = 26;
blocks = 16;
max_slices = ceil(z/p);
cd_length = z*blocks; 

k = n-m;
RateActual = k/n  
Rateforchannel = 7136/8160;
Rate = Rateforchannel;

alphalist=[0.75]
alpha = alphalist;
attenf = 2;

max_iterations = [1,10,20];
snr_db = [0.1,3,5]; % dB
EbNo = 10.^(snr_db/10);
ber_mat = zeros( size(alpha)(2), size(max_iterations)(2), size(snr_db)(2));
err_mat = zeros( size(alpha)(2), size(max_iterations)(2), size(snr_db)(2));

#------ Make a message and encode START -------#
ksys = 7136;
Ggf = gf(func_NE_makeG(),1);
[msgksys,code,codetx,cword,s] = func_make_rand_cdwrd (ksys=7136,Ggf);
#------ Make a message and encode  END  -------#

quanton = 1;
ber_on = 1;
sim_iterations = 10;
for alpha_i = 1:1:size(alpha)(2)
  
  for max_iterations_i = 1:1:size(max_iterations)(2)
    for snr_i = 1:1:size(EbNo)(2)
      fprintf(" Running for alpha = %d, max_iterations = %d, snr (dB)= %d\n", alpha(alpha_i),max_iterations(max_iterations_i),snr_db(snr_i));
      
      for sim = 1:1:sim_iterations
        fprintf("Sim iteration = %d\n",sim);
        [msgksys,code,codetx,cword,s] = func_make_rand_cdwrd (ksys=7136,Ggf);        
        # -- Add noise
        sigma = sqrt(1/(2*Rate* EbNo(snr_i) ));
        noisesig = sigma * randn(1,size(s)(2));
        r = s + noisesig;
        
               
        # -- Receiver
        %receiver: make 8160 to 8176 code.
        max18 = [(maxinf*ones(1,18))];
        r_unpunc = [max18,r(1,1:end-2)];
        %Attenuation(if attenf<1)/Amplification(if attenf>1)
        %attenf = 2;%
        r_atten = attenf*r_unpunc;
        r_unpunc = r_atten;
        err_mat(alpha_i,max_iterations_i,snr_i) = sum( msgksys~= r_unpunc(19:19+ksys-1) < 0); # Just checking whether alg is doing anything useful
        
        %quantization procedure
        if(quanton)
        
          r_unpunc = func_quantizer(r_unpunc,limit(2),limit(1),resolution);
        endif
        
        
        % SOFT DECODING
        L = r_unpunc;%r; %total belief
        assert(size(L)(2),8176);
        [hlut,E,L_decoded,D] = func_full_run ( L, max_iterations(max_iterations_i), 0);
        
        % Hard decision
        syspart = L(19:19+ksys-1);
        msg_cap = syspart < 0; %decision
        
        errs = sum(msg_cap ~= msgksys);
        %Counting errors
        ber_mat( alpha_i, max_iterations_i, snr_i) += errs;
        fprintf(" alpha = %d | max_iterations = %d | snr = %d || errors in sim %d = %d ", alpha(alpha_i),max_iterations(max_iterations_i), EbNo(snr_i), sim,errs);
      endfor # End simulation loop      
      
      #ber_mat contains number of errors, convert to rate
      ber_mat(alpha_i,max_iterations_i,snr_i) = ber_mat(alpha_i,max_iterations_i,snr_i)
      
    endfor
  endfor
endfor
fname = sprintf('./test/ber.txt');
fid = fopen(fname,'w+');
fprintf(fid,mat2str(ber_mat));
fprintf(fid,mat2str(err_mat));
fclose(fid);