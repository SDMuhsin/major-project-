function retval = script_function_generator (input1, input2)
  G = func_NE_makeG();
  
  G = G(1:end, 7155 : end);
  size(G)
  row_addresses = zeros(1, size(G)(1) / 511);
  row_addresses(1) = 1;
  row_addresses = 1 + row_addresses * 16;
  
  #Print file
  fid = fopen('function_generator.v','wt');
  
  K_N = 1022;
  addr_width = ceil( log2( size(row_addresses )(2) ));
  fprintf(fid, "`timescale 1ns / 1ps\n");
  fprintf(fid, "module Function_generator1 (f,adrs,rst);\n");
  fprintf(fid, "parameter K_N=%d;\n", K_N);
  fprintf(fid, "parameter addr_width=%d;\n", addr_width);
  
  fprintf(fid, "output reg [K_N-1:0]f;\n");
  fprintf(fid, "input [addr_width-1:0]adrs;\n");
  fprintf(fid, "input rst;\n");
  
  fprintf(fid, "input rst;\n");
  fprintf(fid, "always@(adrs,rst)begin\n");
  fprintf(fid, "  if(rst)begin\n");
  fprintf(fid, "    f = K_N'd0;\n");
  fprintf(fid, "  end\n");
  fprintf(fid, "  else begin\n");
  
  fprintf(fid, "    case(adrs)begin\n");  
  for i = 1:1:14
    fprintf(fid, "    addr_width'd%d : begin \n",i-1);  
    fprintf(fid, "      f = K_N'b%s;\n",  bin2str(G( row_addresses(i) + 511*(i-1) + 1, :))) ;  
    fprintf(fid, "    end \n");  
  endfor
  fprintf(fid, "default: f = K_N'd0;");
  fprintf(fid, "    endcase\n");
  
  
  fprintf(fid, "  end\n");
  fprintf(fid, "  endmodule\n");
            
  
  fclose(fid);
endfunction
