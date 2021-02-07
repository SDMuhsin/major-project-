MODE = 1;


test_row = 3;
if(MODE == 1)

  input = fileread("./outputs/from_script_codeword_32x16.txt");
  size(input);
  
  output = fileread("./outputs/from_tb_codeword_32x16.txt");
  size(output);
  
  w = 6;
  input_symbols = [];
  output_symbols = [];
  for i = 1:w:size(input)(2)
    input_symbols = [ input_symbols, bin2dec(input(i:i+w-1))];
    output_symbols = [ output_symbols, bin2dec(output(i:i+w-1))];
    
  endfor
  
  no_match_indices = find( input_symbols ~= output_symbols);
  sum(input ~= output)
  input_symbols(no_match_indices)
  output_symbols(no_match_indices)
elseif (MODE == 0)
  cdwrd = func_quantizer( func_saturate(func_make_rand_cdwrd(8176) + 4 * randn(1,8176)));
  input_pattern = func_write_l10_input_32x16( cdwrd);
  [pat,output_pattern] = func_write_rcu_output_52xn( cdwrd);
  
endif
