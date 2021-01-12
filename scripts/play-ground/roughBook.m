
clc;
clear all;

offsets = [0 176; 99 471];
circ_size = 511;
p = 26;

# Offset-seperated address table 20 x 26 x 2
address_table_ly1 = generateIsolatedAddressTables(offsets(1,:),circ_size,p);
address_table_ly2 = generateIsolatedAddressTables(offsets(2,:),circ_size,p);
  
# Make access mask : 20 x 26 x 2 : (i,j,k) = 1 => first access; = 2 => second access
access_mask_ly1 = generateAccessMask(address_table_ly1,circ_size);
access_mask_ly2 = generateAccessMask(address_table_ly2,circ_size);

# Find out from which rows of ly1_a and ly1_b reaccess begins
ly1_re_begins = getReIndicesFromMask(access_mask_ly1);
#Find out at which rows of ly2_a and ly2_b, first access ends
ly2_first_ends = getLastFirstIndicesFromMask(access_mask_ly2);


# Make 52 x d FIFO, fill it with values from address_table_ly1 from the row first access begins
# There has to be two fifos fifo_a and fifo_b..
# We need to keep an access_queue
d = 2; #fifo columns
start_row = min(ly1_re_begins(1,1),ly1_re_begins(2,1));
start_row_copy = min(ly1_re_begins(1,1),ly1_re_begins(2,1));

global_flags = [];
unused_a = [];
unused_b = [];

max_unused_dim = [];
for start_row = start_row_copy : 1 : size( address_table_ly1)(1)
    
    
    data_fifo_a = covertRowsToFifo(address_table_ly1(:,:,1),start_row,d);
    mask_fifo_a = covertRowsToFifo(access_mask_ly1(:,:,1),start_row,d);

    data_fifo_b = covertRowsToFifo(address_table_ly1(:,:,2),start_row,d);
    mask_fifo_b = covertRowsToFifo(access_mask_ly1(:,:,2),start_row,d);

    # Line 29 : Make those symbols which are not post reaccess, 0 (invalid)
    data_fifo_a( mask_fifo_a == 1 ) = 0;
    data_fifo_b( mask_fifo_b == 1 ) = 0;
     
    # See if those values in these fifos, with access_mask = 2 can fill one row each of ly2_a and ly2_b

      # For each row_a,row_b in ly2_a,ly_b
        # For each element r_c_a, r_c_b in row_a, row_b
          # check if r_c_a in fifo_a or fifo_b...
          
    flags = ones(size(address_table_ly2)(1),2);
    for r = 1:1:size(address_table_ly2)(1)
      f1 = 1; # rth row of ly2_a can be fully filled
      f2 = 1; # rth row of ly2_b can be fully filled
      for c = 1:1:size(address_table_ly2)(2)
        #Check if address_table_ly1 (r,c,ly2) in fifo
        # if any one symbol in the row is not there is fifo, that row cant be filled
        # We need ensure two things : 
        #   1. The values in fifo that we consider must be second access
        #      This step is ensured in Line 29 (ctr + f "Line 29")
        #   2. The values in address_table that we consider must be first access
        #      This is in ensured in the following if statements
        
        # ly2_a
        
        # TO DO : Make it use unused FF as well
        
        f1d = checkIfElementInMatrix(address_table_ly2(r,c,1),data_fifo_a);
        if( r <= ly2_first_ends(1,1) && c <= ly2_first_ends(1,2))
          f1 *= f1d; 
        endif
        
        #ly2_b
        f2d = checkIfElementInMatrix(address_table_ly2(r,c,2),data_fifo_b);
        if( r <= ly2_first_ends(2,1) && c <= ly2_first_ends(2,2))
          f2 *= f2d;
        endif
       
      endfor
      flags(r,1) = f1;
      flags(r,2) = f2;
    endfor
    # CAUTION : The last rows of flags will be one but they are reaccess symbols
    # .. and need not be considered
    # there is an edge case row in a and b where some are not reaccess
    for i = 1:1:size(flags)(1)
      if(i > ly2_first_ends(1,1)) #STRICTLY GREATER TO AVOID EDGE CASE MENTIONED ABOVE
        flags(i,1) = -10;
      endif  
      if(i > ly2_first_ends(2,1)) #STRICTLY GREATER TO AVOID EDGE CASE MENTIONED ABOVE
        flags(i,2) = -10;
      endif  
    endfor
    
    global_flags = [global_flags, flags];
    
    # STORE THOSE SYMBOLS WHICH HAVE NOT BEEN USED FROM FIRST STAGE OF FIFO
    
    #First, isolate those rows of address_table_ly1 (a) and (b) that have 1's in flags
    used_a = [];
    used_b = [];
    for i = 1:1:size(flags)(1)
      if(flags(i,1) == 1)
        used_a = [used_a, address_table_ly2(i,:,1)]
      endif
      if(flags(i,2) == 1)
        used_b = [used_b, address_table_ly2(i,:,2)]; 
      endif
    endfor
    
    #Figure out those elements from first column of fifo_a and fifo_b that are not present in used_a or used_b
    u_a = [];
    u_b = [];
    fprintf("\n fifo_a front stage \n");
    data_fifo_a(:,end)
    for i = 1:1:size(data_fifo_a)(1)
      
      if( data_fifo_a(i,end) ~= 0 &&  ~checkIfElementInMatrix( data_fifo_a(i,end), used_a) && ~checkIfElementInMatrix( data_fifo_a(i,end), used_b))  
        u_a = [u_a, data_fifo_a(i,end)]; 
        fprintf(" %d is unused", data_fifo_a(i,end));
      endif
      if( data_fifo_a(i,2) ~= 0 && ~checkIfElementInMatrix( data_fifo_b(i,end), used_b) && ~checkIfElementInMatrix( data_fifo_a(i,end), used_a))
        u_b = [u_b, data_fifo_b(i,end)]; 
      endif
    endfor
    unused_a = [unused_a u_a];
    unused_b = [unused_b u_b];
endfor