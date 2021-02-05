function [hlut,E,L,D] = func_full_run ( cdwrd, max_iterns, wr_en)
  #cdwrd : 1 x 8176
  
  #-------------------------
  lys = 2;
  Wc = 32;
  z = 511;
  p = 26;
  blocks = 16;
  max_slices = ceil(z/p);
  #-------------------------
  
  #--------------------------
  #H matrix and reaccess mask
  hmat_ne = func_makeHNE(z);
  [m,n] = size(hmat_ne);
  
  hlut = zeros(m,Wc); # stores positions of 1s
  for i=1:m
    hlut(i,:) = find(hmat_ne(i,:) ~= 0); 
  end
  reaccess_mask = func_reaccess_mask(hlut);
  size(reaccess_mask);
  #--------------------------

  
  # for iter
    # for ly
      # for slice
        # for row
  
  L = cdwrd;
  E = zeros( lys*z , 1 + 1 + 1 + Wc);
  E(1:end,3) = 1; # Matlab index from 1->32 changed to 0->31 later
  
  D = zeros( 1, blocks * z);
  

  for iteration = 1:1:max_iterns
    if(wr_en)
     filename = sprintf("./test/test.txt");
     fid = fopen(filename,"wt");
     endif
     # At the beginning of an iteration, we have :
     # L : 1x8176
     # E : 1022 x 35
     # D : 1x8176
     
    
     
     for ly = 1:1:lys
      
      fprintf("start of layer = %d, min(L) = %d, max(L) = %d max of D = %d\n", ly,min(L),max(L),max(max(D))); 
      
      if(wr_en)
      # -- OPEN FILES -- #
      # These are printed for every slice or for every row #
      fname_Lin = sprintf('./outputs/L_in_iter%d_ly%d.txt',iteration,ly);
      fid_Lin = fopen(fname_Lin,'w+');
      fname_Ein = sprintf('./outputs/E_in_iter%d_ly%d.txt',iteration,ly);
      fid_Ein = fopen(fname_Ein,'w+');
      fname_Din = sprintf('./outputs/D_in_iter%d_ly%d.txt',iteration,ly);
      fid_Din = fopen(fname_Din,'w+');
      
      fname_Lout = sprintf('./outputs/L_out_iter%d_ly%d.txt',iteration,ly);
      fid_Lout = fopen(fname_Lout,'w+');
      fname_Eout = sprintf('./outputs/E_out_iter%d_ly%d.txt',iteration,ly);
      fid_Eout = fopen(fname_Eout,'w+');
      fname_Dout = sprintf('./outputs/D_out_iter%d_ly%d.txt',iteration,ly);
      fid_Dout = fopen(fname_Dout,'w+');
      endif
      # -Intermediate lists to be printed
      
      # ---------------- #
      
      for slice = 1:1:max_slices
        #Gather all rows involved in this slice
        row_start = (slice-1)*p + 1;
        row_end = slice * p;
        if(row_end > z)
          row_end = z;
        endif
        rows = row_start :1:row_end;
        rows_global = (ly-1)*z .+ rows;
        
        # Outputs of p RCUs
        # Update a certain ammount of symbols of L, max 26 x 32 symbols
        # E -> update a 26 x 32 chunk
        
        
        for row = rows_global
          
          symbol_indices = hlut(row,:);
          symbols = L(symbol_indices);
          
          # Begin Row calculation
          # Every row updates a row of E
          # If a symbol out of 32 is post second access, it's L is updated
          # If a symbol out of 32 is post first access, it generates D
          # All rows generate E ( also D, but not all Ds are valid)
          
          # RCU algorithm
          # 1. E = recover(E)
          # 2. Q = L - E
          # 3. Q_abs = abs(Q), Q_sign = sign(Q)
          # 4. m1,m2,pos = minfind( Q_abs)
          # 5. E_out  = [m1,m2,pos, flipped(Q_sign)]
          # 6. L_out = Q + Recover(E_out) + D_in
          # 7. D_out = Recover(E_out) - E
          
         
          E_in = E(row,:); # 1 x (1 + 1 + 1 + 32)
          L_in = func_saturate(symbols);
          assert(size(L_in)(2),32);
          D_in = func_saturate(D(symbol_indices));
          
          if(wr_en)
          printtxt=sprintf('%s\n', bin2hex(L_in));
          fprintf(fid,'%c',transpose(printtxt));
          endif
          
          rec_1_out = func_module_recover(E_in); # 1 x 32
          
          Q = func_saturate(L_in - rec_1_out);
          
          [Q_abs,Q_sign] = func_module_absoluter(Q);
          
          [m1,m2,m1_psn] = func_module_minfinder(Q_abs);
          
          E_out = [m1,m2,m1_psn,Q_sign];
          
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
               L(symbol_indices(i)) = L_out(i);
            else
              fprintf("This shouldn't happen, reaccess_mask");
            endif
            
          endfor
          
          #Update E
          E(row,:) = E_out;
            

          if( row > 2009 ||  size(E_out) ~= 35 || size(E_in) ~= 35  ) 
            fprintf("iteration = %d ; row = %d \n", iteration, row);
            
            assert(size(D_in)(2),32)
            assert( size ( func_conv_symbol2bin( D_in ) )(2), 192);

            
          endif
                    # TEMP stuff
          if(iteration == 100 && ly == 1 && row == 1)
            fprintf("row = %d",row);
            fprintf("----\n");
            L_in
            E_in
            rec_1_out
            D_in
            
            fprintf("---\n");
            Q
            E_out
            rec_2_out
            D_out
            L_out
            fprintf("---\n");

          endif
          
          if(wr_en)
          # -- print to file, per row -- #
          fprintf(fid_Lin,"%s\n", func_conv_symbol2bin( L_in ));
          fprintf(fid_Ein,"%s\n", func_conv_etobin(E_in) );
          fprintf(fid_Din,"%s\n", func_conv_symbol2bin( D_in ));
          
          fprintf(fid_Lout,"%s\n", func_conv_symbol2bin( L_out ));
          fprintf(fid_Eout,"%s\n", func_conv_etobin(E_out));
          fprintf(fid_Dout,"%s\n", func_conv_symbol2bin( D_out ));
          
          fflush(fid);     
          fflush(fid_Din);
          fflush(fid_Lin);
          fflush(fid_Ein);
          fflush(fid_Dout);
          fflush(fid_Lout);
          fflush(fid_Eout);
          endif
          # ---------------------------- #

        endfor # row end

      endfor #slice end
     endfor#layer end
     
     # -- Close files -- #
     if(wr_en)
     fclose(fid);
     fclose(fid_Lin);
     fclose(fid_Ein);
     fclose(fid_Din);
     fclose(fid_Lout);
     fclose(fid_Eout);
     fclose(fid_Dout);
     endif
     # ----------------- #
  endfor#iteration end
  
endfunction
