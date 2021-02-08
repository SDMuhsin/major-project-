MODE = 1;


rd_address = 5 + 1;
if(MODE == 1) 

  input = fileread("./outputs/from_script_codeword_32x16.txt");
  size(input);
  
  output = fileread("./outputs/from_tb_codeword_32x16.txt");
  size(output);
  
  output_txt = fileread('./outputs/output_codeword_20x26x2x16.txt');
  
  w = 6;
  input_symbols = [];
  output_symbols = [];
  for i = 1:w:size(input)(2)
    input_symbols = [ input_symbols, bin2dec(input(i:i+w-1))];
    output_symbols = [ output_symbols, bin2dec(output(i:i+w-1))];

  endfor
  isf = flip(input_symbols);
  osf = flip(output_symbols);  

  no_match_indices = find( input_symbols ~= output_symbols)
  nmi = find(isf ~= osf);
  
  # Find cdwrd index
  cdwrd_nmi = pat(rd_address, nmi);
  fprintf(" Exoected from verilog : %d, expected from cdwrd %d\n", isf(nmi), cdwrd(cdwrd_nmi) );
  
  slice = rd_address;
  row_in_slice = ceil(nmi/32);
  #sum(input ~= output)
  input_symbols(no_match_indices)
  output_symbols(no_match_indices)
elseif (MODE == 0)
  cdwrd = func_quantizer( func_saturate(func_make_rand_cdwrd(8176) + 4 * randn(1,8176)));
  cdwrd(1:18) =7.75 * ones(1,18);
  [l0p,input_pattern] = func_write_l10_input_32x16( cdwrd);
  [pat,output_pattern] = func_write_rcu_output_52xn( cdwrd);
  
endif
