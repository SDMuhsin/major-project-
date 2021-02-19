  #cdwrd : 1 x 8176
  
  #-------------------------
  len=8176;

  #c= randi(16,1,len-18)-9;
  #c1=[7.75*ones(1,18),c];
  #c1=randi([-6 7],1,len);
  blocks=16;
  func_write_l10_input_32x16 (c1);
  func_write_rcu_layer0_52xn (c1);
  
  #-------------------------
  max_iterns=2;
  lys = 2;
  Wc = 32;
  z = 511;
  p = 26;
  blocks = 16;
  max_slices = ceil(z/p);
  #-------------------------
  
  #-------------------------
  #H matrix and reaccess mask
  #hmat_ne = func_makeHNE(z);
  #[m,n] = size(hmat_ne);
  offset_indices=func_makeaddtable();
  [second_acc(:,:,1),second_acc(:,:,2)]=reaccess_slice();
  #hlut = zeros(m,Wc); # stores positions of 1s
  #for i=1:m
  #  hlut(i,:) = find(hmat_ne(i,:) ~= 0); 
  #end
  #size(hlut)
  reaccess_mask = func_reaccess_mask(offset_indices);
  #size(reaccess_mask)
  #--------------------------
  
  #L = cdwrd;
  L=c1;
  E = zeros( lys*z , 1 + 1 + 1 + Wc);
  D = zeros( 1, blocks * z);
  ly=2;
  iteration=2;
    Lin_array_slice=[];
    L_array_slice=[]; 
  for iteration=1:1:2
  for ly = 1:1:lys

    # -- OPEN FILES -- #
      # These are printed for every slice or for every row #
      fname_Lin = sprintf('./outputs/L%d_iter%d_in_scripted.txt',ly-1,iteration);
      fid_Lin = fopen(fname_Lin,'wt');
      fname_Ein = sprintf('./outputs/E%d_iter%d_in_scripted.txt',ly-1,iteration);
      fid_Ein = fopen(fname_Ein,'wt');
      fname_Din = sprintf('./outputs/D%d_iter%d_in_scripted.txt',ly-1,iteration);
      fid_Din = fopen(fname_Din,'wt');
      
      fname_Lout = sprintf('./outputs/L%d_iter%d_out_scripted.txt',ly-1,iteration);
      fid_Lout = fopen(fname_Lout,'wt');
      fname_Eout = sprintf('./outputs/E%d_iter%d_out_scripted.txt',ly-1,iteration);
      fid_Eout = fopen(fname_Eout,'wt');
      fname_Dout = sprintf('./outputs/D%d_iter%d_out_scripted.txt',ly-1,iteration);
      fid_Dout = fopen(fname_Dout,'wt');
  # ---------------- #
    #slice=11;
    for slice = 1:1:max_slices
        #Gather all rows involved in this slice
        #slice=1;
        row_start = (slice-1)*p + 1;
        row_end = slice * p;
        if(row_end > z)
          row_end = z;
        endif
        rows = row_start :1:row_end;
        rows_global = (ly-1)*z .+ rows;
        Lin_array=[];
        Ein_array=[];
        Din_array=[];
        L_array=[];
        E_array=[];
        D_array=[];
        # Outputs of p RCUs
        # Update a certain ammount of symbols of L, max 26 x 32 symbols
        # E -> update a 26 x 32 chunk
        #row=10;
        for row = rows_global
        #for row = 1:1:26
          
          symbol_indices = offset_indices(row,:);
          symbols = L(symbol_indices);
          #symbols=symbol_row(row,:);
          E_in = E(row,:); # 1 x (1 + 1 + 1 + 32)
          
          Ein_write(1:5)=func_conv_symbol2bin_abs(E_in(1));
          Ein_write(6:10)=func_conv_symbol2bin_abs(E_in(2));
          if(iteration==2)
          Ein_write(11:15)=dec2bin(32-E_in(3),5);
        else
          Ein_write(11:15)=dec2bin(E_in(3),5);
        endif
          Ein_write(16:47)=fliplr(E_in(4:35))+48;      
          
          L_in = func_saturate(symbols);
          D_in = func_saturate(D(symbol_indices));
          Lin_array=[Lin_array L_in];
          Ein_array=[Ein_array E_in];
          Din_array=[Din_array D_in];
          #printtxt=sprintf('%s\n', bin2hex(L_in));
  
          
          rec_1_out = func_module_recover(E_in); # 1 x 32
          
          Q = func_saturate(L_in - rec_1_out);
          
          [Q_abs,sign_q] = func_module_absoluter(Q);
          
          flip = sign_q(1);
          for i = 2:1:size(sign_q)(2)
             flip = xor(flip,sign_q(i));
          endfor
          
          if(flip)
            Q_sign = xor(sign_q,1);
          else
            Q_sign=sign_q;
          endif
          
          Q_abs_quant=func_quantizer(Q_abs*0.75);
          
          [m1,m2,m1_psn] = func_module_minfinder(Q_abs_quant);
          
          E_out = [m1,m2,m1_psn,Q_sign];
          
          m1_write = func_conv_symbol2bin_abs(m1);
          
          m2_write = func_conv_symbol2bin_abs(m2);
          
          m1_psn_wr = dec2bin(m1_psn-1,5);
          
          sign_write = Q_sign + 48;
          
          E_write = [m1_write,m2_write,m1_psn_wr,fliplr(sign_write)];
          
          #fprintf(" --Q = %d, min(Q) = %d, m1 = %d, E_out = %d \n",Q_abs(1),min(Q_abs),m1,E_out(1));
          rec_2_out = func_module_recover(E_out);
          L_out = func_saturate( Q + rec_2_out + D_in );
          D_out = func_saturate( rec_2_out - rec_1_out);

          # Update to global L 1x8176, global E 1022x32, global D 1x8176
          # Iterate accross all 32 symbols
          for i = 1:1:size(symbol_indices)(2)
            #fprintf("i=%d,",i);
            #Check if symbol is first access or reacess
            if(reaccess_mask(row,i) == 1) #First access
               #Update D
               D(symbol_indices(i)) = D_out(i);
               #Dont update L
            elseif(reaccess_mask(row,i) == 2) #Second access
               #Dont update D, infact, clear D
               D(symbol_indices(i)) = 0;
               #Update L
               #L(symbol_indices(i)) = L_out(i);
            else
              fprintf("This shouldn't happen, reaccess_mask");
            endif
            
          endfor
          
          #Update E
          E(row,:) = E_out;
          L_array=[L_array L_out];
          E_array=[E_array E_out];
          D_array=[D_array D_out];  
          
          #rec_2_out_flip=fliplr(rec_2_out);
          #rec_1_out_flip=fliplr(rec_1_out);
          
          #E_write=func_conv_symbol2bin(rec_2_out);
          #Ein_write=func_conv_symbol2bin(rec_1_out);
          
          fprintf(fid_Eout,sprintf(E_write));
          fprintf(fid_Eout,sprintf("\n"));
          fprintf(fid_Ein,sprintf(Ein_write));
          fprintf(fid_Ein,sprintf("\n"));

          #if( row > 2009 ||  size(E_out) ~= 35 || size(E_in) ~= 35  ) 
            #fprintf("iteration = %d ; row = %d \n", iteration, row);
            
           # assert(size(D_in)(2),32)
           # assert( size ( func_conv_symbol2bin( D_in ) )(2), 192);

            
          #endif
        endfor
        
        for i = 1:1:size(L_array)(2)
            #fprintf("i=%d,",i);
            #Check if symbol is first access or reacess
            if(second_acc(slice,i,ly) > 0) #Second access
              L(second_acc(slice,i,ly))=L_array(i); 
            endif
            
        endfor
        
        L_array=fliplr(L_array);
        Lin_array=fliplr(Lin_array);
        E_array=fliplr(E_array);
        Ein_array=fliplr(Ein_array);
        D_array=fliplr(D_array); 
        Din_array=fliplr(Din_array); 
        #L_write=[];
        #for m=1:1:size(L_array)(2)
          #L_write=[L_write func_conv_symbol2bin(L_array(m))];
          #fprintf(fid_Lout,sprintf(L_write(m)));
          L_write=func_conv_symbol2bin(L_array);
          Lin_write=func_conv_symbol2bin(Lin_array);
          #E_write=func_conv_symbol2bin(E_array);
          #Ein_write=func_conv_symbol2bin(Ein_array);
          D_write=func_conv_symbol2bin(D_array);
          Din_write=func_conv_symbol2bin(Din_array);
          #fprintf(fid_Lout,sprintf(L_write));
        #endfor
        
        #for m=1:1:size(E_array)(2)
        #  E_write=func_conv_symbol2bin(E_array(m));
        #  fprintf(fid_Eout,sprintf(E_write));
        #endfor
        
        #for m=1:1:size(D_array)(2)
        #  D_write=func_conv_symbol2bin(D_array(m));
        #  fprintf(fid_Dout,sprintf(D_write));
        #endfor
        
        fprintf(fid_Lout,sprintf(L_write));
        fprintf(fid_Lout,sprintf("\n"));
        fprintf(fid_Lin,sprintf(Lin_write));
        fprintf(fid_Lin,sprintf("\n"));
        
        #fprintf(fid_Eout,sprintf(E_write));
        #fprintf(fid_Eout,sprintf("\n"));
        #fprintf(fid_Ein,sprintf(Ein_write));
        #fprintf(fid_Ein,sprintf("\n"));
        
        fprintf(fid_Dout,sprintf(D_write));
        fprintf(fid_Dout,sprintf("\n"));
        fprintf(fid_Din,sprintf(Din_write));
        fprintf(fid_Din,sprintf("\n"));
        
        #fprintf(fid_Eout,sprintf("\n"));
        #fprintf(fid_Dout,sprintf("\n"));
        if(slice<20)
        Lin_array_slice=[Lin_array_slice;Lin_array];
        L_array_slice=[L_array_slice;L_array];
        endif
      endfor
    endfor
    endfor
    #fprintf(fid_Lout,sprintf(L_array_slice));
    fclose(fid_Lin);
    fclose(fid_Lout);
    fclose(fid_Ein);
    fclose(fid_Eout);
    fclose(fid_Din);
    fclose(fid_Dout);