circSize = 511;

% -- PRINT INITIAL VERILOG STUFF -- %
% --------------------------------- %
% --------------------------------- %
filename = sprintf("LMem%dScripted.txt",circSize);
fid = fopen (filename, "w");

fprintf(fid,sprintf("`timescale 1ns / 1ps \n"));
fprintf(fid,sprintf("module LMemReadFF(\n    muxOut,\n    muxIn,\n    sel\n\n);"));

fprintf(fid,sprintf("parameter W = 6;\nparameter p = 26;\nparameter circSize = 511;\nparameter blocksPerLayer = 16;\nparameter symbolsPerAccessBits = 2 * W * p * blocksPerLayer; // Actually bits per access\nparameter sliceAddressSize = 5;\nparameter totalSlices = 20;\n"));
fprintf(fid,sprintf("output wire [ symbolsPerAccessBits - 1: 0]muxOut; // 26 * 2 symbols per access \n"));
fprintf(fid,sprintf("input [ 1 + sliceAddressSize - 1 : 0 ]sel;\n"));
fprintf(fid,sprintf("input wire [ circSize * blocksPerLayer * W - 1 : 0 ]muxIn;\n"));
fprintf(fid,sprintf("reg [W-1:0]muxOutWire[ 2 * p * blocksPerLayer - 1: 0 ];\n"));
fprintf(fid,sprintf("wire [W-1:0]muxInWire[ circSize * blocksPerLayer - 1 : 0];\n"));
fprintf(fid,sprintf("genvar i;\n"));
fprintf(fid,sprintf("generate for( i = 0; i < 2*p*blocksPerLayer; i = i+1 ) begin : muxOutWiring \n"));
fprintf(fid,sprintf("    assign muxOut[ (i+1)*W - 1:i*W] = muxOutWire[i]; \n"));
fprintf(fid,sprintf("end\nendgenerate\n"));
fprintf(fid,sprintf("genvar k;\n"));
fprintf(fid,sprintf("generate for( k = 0; k < circSize * blocksPerLayer; k = k+1 ) begin : muxInWiring \n"));
fprintf(fid,sprintf("    assign muxInWire[k] = muxIn[(k+1)*W - 1 : k*W]; \n"));
fprintf(fid,sprintf("end \n"));
fprintf(fid,sprintf("endgenerate \n"));
fprintf(fid,sprintf("assign muxIn = 0; \n"));
fprintf(fid,sprintf("wire lyWire; \n"));
fprintf(fid,sprintf("wire [ sliceAddressSize - 1:0]sliceAddressWire; \n"));
fprintf(fid,sprintf("assign lyWire = sel[sliceAddressSize]; \n"));
fprintf(fid,sprintf("assign sliceAddressWire = sel[ sliceAddressSize - 1 : 0 ]; \n"));
fprintf(fid,sprintf("integer v; \n"));
fprintf(fid,sprintf("always @(*) begin \n"));
fprintf(fid,sprintf("    case(sel) \n"));

% -- END INITIAL VERILOG STUFF -- %
% --------------------------------- %
% --------------------------------- %

M= 511;
%h=zeros(2*M,16*M);
%table from ccsds for nearearthLDPC
circulantsLUT=[0, 176 0, 176;
12, 239 523, 750;
0, 352 1022, 1374;
24, 431 1557, 1964;
0, 392 2044, 2436;
151, 409 2706, 2964;
0, 351 3066, 3417;
9, 359 3586, 3936;
0, 307 4088, 4395;
53, 329 4652, 4928;
0, 207 5110, 5317;
18, 281 5639, 5902;
0, 399 6132, 6531;
202, 457 6845, 7100;
0, 247 7154, 7401;
36, 261 7701, 7926;
99, 471 99, 471;
130, 473 641, 984;
198, 435 1220, 1457;
260, 478 1793, 2011;
215, 420 2259, 2464;
282, 481 2837, 3036;
48, 396 3114, 3462;
193, 445 3770, 4022;
273, 430 4361, 4518;
302, 451 4901, 5050;
96, 379 5206, 5489;
191, 386 5812, 6007;
244, 467 6376, 6599;
364, 470 7007, 7113;
51, 382 7205, 7536;
192, 414 7857, 8079];
%H matrix construction
ro=0;
h=[];
hloc=[];
for h_row=1:2
  hlyr = [];
  hlyrloc=[];
  for h_col=1:16
    ro = ro+1;
    firstrow = zeros(1,M);
    firstrow(1,circulantsLUT(ro,1)+1) = 1;
    firstrow(1,circulantsLUT(ro,2)+1) = 1;
    A = makecirculant(firstrow,M);
    hlyr = [hlyr,A];
    %Location finding
    Aloc = func_makecirculantlocations((circulantsLUT(ro,1:2)+1),M,M);
    hlyrloc=[hlyrloc,Aloc];      
  end
  h = [h;hlyr];
  %Locations
  hloc = [hloc;hlyrloc];
end

%exact loc adding 511 offsets
h_exactloc = zeros(size(hloc));
for lyr=1:2
  for irow=1+(lyr-1)*511:511+(lyr-1)*511
    for circ=1:16
      wtc1 = 2*circ - 1;
      wtc2 = 2*circ;
      offset=511*(circ-1);
      h_exactloc(irow,wtc1)=hloc(irow,wtc1)+offset;
      h_exactloc(irow,wtc2)=hloc(irow,wtc2)+offset;
    end
  end
end

p = 26;
rowsPerLayer = 511;
layersCount = 2;
blocksCount = 16;
offsetsPerCircCount = 2;
slicesPerLayer = ceil( M / p);

% -- GENERATE ADDRESS TABLE -- %
addressTableRows = layersCount * ceil( M / p);
addressTableColumns = blocksCount * offsetsPerCircCount * p;

addressTable = zeros(addressTableRows,addressTableColumns);
for ly = 1:layersCount
  hl = h( (ly-1) * M  + 1: ly*M , :);
  for slice = 1:1:addressTableRows/2
    
    sliceStart = 1 + p*(slice -1);
    sliceEnd = slice * p;
    
    if sliceEnd > 511
      sliceEnd = 511;  
    endif
    disp("slice");
    disp(slice);
    % - Get addresses of 1's in a slice -- %
    addressTable( (ly-1)*addressTableRows/2 + slice, :) = iloc(hl(sliceStart:sliceEnd,:),p,blocksCount,1);
    
  endfor
endfor

symbolAccessCounts = zeros(1,M*blocksCount);
for ly = [0,1]
  for i = 1:1:addressTableRows/layersCount
    toAccess = [];
    for j = 1:1:addressTableColumns
      if( addressTable(ly*slicesPerLayer + i,j) ~= 0 && symbolAccessCounts(1,addressTable(ly*slicesPerLayer + i,j)) == 0)
        
        toAccess = [toAccess, addressTable(ly*slicesPerLayer + i,j)];
        symbolAccessCounts(1,addressTable(ly*slicesPerLayer + i,j)) = 1;
      else 
        toAccess = [toAccess, 0];
        
      endif
    endfor     
    %-- PRINT --%
    fprintf(fid,sprintf("\t\t\t {1'b %d,5'd %d}:begin\n", ly,i-1));
    disp(length(toAccess));
    for k = 1:1:2 * p * blocksCount
      if( k > length(toAccess))
        fprintf(fid,sprintf("\t\t\t\t muxOutWire[%d] = 0; \n",k-1));
      else
        if( toAccess(k) == 0)
          fprintf(fid,sprintf("\t\t\t\t muxOutWire[%d] = 0; \n",k-1));          
        else
          fprintf(fid,sprintf("\t\t\t\t muxOutWire[%d] = muxInWire[%d]; \n",k-1,toAccess(k) - 1));
        endif
      endif
    endfor
    fprintf(fid,sprintf("end\n"));
    
  endfor
endfor

fprintf(fid,sprintf("\t\t\t default:begin\n", ly,i-1));
for k = 1:1: 2 * p * blocksCount
  fprintf(fid,sprintf("\t\t\t\t muxOutWire[%d] = 0; \n",k-1));
endfor
fprintf(fid,sprintf("\t\t\t end", ly,i-1));


fprintf(fid,sprintf("    endcase\n"));
fprintf(fid,sprintf("end\n"));
fprintf(fid,sprintf("endmodule\n"));
fprintf(fid,sprintf(""));

fclose(fid);
