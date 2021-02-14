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
[pat,sym] = func_write_l10_input_32x16 (c);

