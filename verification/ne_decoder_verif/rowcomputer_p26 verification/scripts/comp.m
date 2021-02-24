

for i = 11:1:15
  fprintf(" - rd_address %d\n",i-1);
  f = sprintf("./outputs/from_tb_op%d.txt",i-1);
  op = fileread( f);
  f = sprintf("./outputs/from_tb_ref%d.txt",i-1);
  ref = fileread(f);
  assert(size(op)(2),size(ref)(2));

  w = 6;
  op_s = [];
  ref_s = [];
  for i = 1:w:size(op)(2)
    op_s = [op_s, bin2dec(op(i:i+w-1))]; 
    ref_s = [ref_s, bin2dec(ref(i:i+w-1))]; 
  endfor

  op_s = flip(op_s);
  ref_s = flip(ref_s);

  errs = sum(op_s ~= ref_s)
  nmi = find(op_s ~= ref_s)

  op_s_nm = op_s(nmi)
  ref_s_nm = ref_s(nmi)
  fprintf("-----\n");
endfor