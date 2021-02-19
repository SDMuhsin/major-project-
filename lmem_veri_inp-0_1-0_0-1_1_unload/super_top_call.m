MODE = 1;

if(MODE == 0)
  len=8160;
  c= ones(1,len);
  c(randi(len,1,len)) = -1;
  c(c~= -1) = 1;
  c = c + 2 * randn(1,len);
  c = func_quantizer( func_saturate( c));


  asm = zeros(1,64); 

  rx = [asm,c];

  # Write to file, 32 bits per row

  fn = sprintf("./outputs/input_257x32.txt");
  fid = fopen(fn,'w');

  for i = 1:1: size(rx)(2)/32
    assert(size( rx((i-1)*32 + 1: i*32) )(2),32);
    a = flip(rx((i-1)*32 + 1: i*32),2);
    fprintf( fid, "%s\n", func_conv_symbol2bin( a ) );
  endfor
  fflush(fid);
  fclose(fid);

  # Make unpunctured codeword

  c = [ 7.75*ones(1,18),rx(65:end-2)];
  assert(size(c)(2),8176);
  [ pat, sym] = func_write_l10_input_32x16 (c);

else 
  r = 16;
  ref = fileread( strcat('./outputs/from_tb_load17x32_', strcat(num2str(r),"_ref.txt")));  
  op = fileread( strcat('./outputs/from_tb_load17x32_', strcat(num2str(r),"_op.txt")));  
  #op = fileread('./outputs/from_tb_load17x32_%d_op.txt',r); 
  
 
  ref_s = [];
  op_s = [];
  for i = 1:6:size(ref)(2)
    r_sy = ref(i: i + 5);
    o_sy = op(i: i + 5);
    
    
    if(length( find( o_sy(o_sy == 'x') ) ) == 0)
      fprintf("|");
      op_s = [ op_s, bin2dec( o_sy )];
    else
      op_s = [ op_s, 99999];
    endif
    ref_s = [ ref_s, bin2dec( r_sy )];      
  endfor
  
  ref_s = flip(ref_s);
  op_s = flip(op_s);
  
  ref_s(pat(r+1,:) <= 0) = -1;
  op_s(pat(r+1,:) <= 0) = -1;
  Nerr = sum(ref_s ~= op_s)
  nmi = find(ref_s ~=op_s)
endif