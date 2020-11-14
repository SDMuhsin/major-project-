circSize = 511;
offsets = [0 176];

filename = sprintf("DMem%dScripted.txt",circSize);
fid = fopen (filename, "w");
fprintf(fid,sprintf("module DMem%dScripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t reaccessAddress,\n\t\t clk,rst \n );\n",circSize));

offsets=offsets.+1;
onesTable = zeros(circSize,length(offsets));

% ADDRESS OF 1s
for i=1:1:circSize
    onesTable(i,1:end) = mod(offsets,circSize);
    
    % Replace 0 with circSize
    if(onesTable(i,1) == 0)
      onesTable(i,1) = circSize;
    endif
    if(onesTable(i,2) == 0)
      onesTable(i,2) = circSize;
    endif
    offsets = offsets.+1;
endfor

% ADDRESS TABLE
p = 26; %Rows per slice
addressTable = zeros( ceil(circSize/p), p*length(offsets));

normIndex = 1;
for i = 1:p:circSize
  %printf(" %d to %d",i,i+p-1)
  startIndex = i;
  endIndex = i+p-1;
  
  if(endIndex > circSize)
    addressTable( normIndex, 1:end) = [ [transpose(onesTable(startIndex:circSize,1)), zeros(1, endIndex - circSize) ], [transpose(onesTable(startIndex:circSize,2)), zeros(1, endIndex - circSize) ] ] 
  elseif
    addressTable( normIndex, 1:end) = [ transpose(onesTable(startIndex:endIndex,1)), transpose(onesTable(startIndex:endIndex,2)) ] 
  endif
  
  normIndex+=1;
endfor

% REG TABLE

%First find maximum number of delay elements requires, including pipeLineStages
maxRelDiff = 0;
for i = 1:1:size(addressTable)(1)-1
  
  for j = i+1:1:size(addressTable)(1)
    if( anyOfAInB( addressTable(j,1:end), addressTable(i,1:end)))
      if(j-i > maxRelDiff)
        maxRelDiff = j-i+1;
      endif
    endif
  endfor
endfor

%REG TABLE ( r x c )
rows = length(offsets)*p; % 2 * P
columns = maxRelDiff + 1; % Including pipeStages
pipeStages = 3;
fifoStartIndex = pipeStages + 1; 
% Cycles
maxCycles = size(addressTable)(1);

fprintf(fid,sprintf("parameter r = %d;\n", rows));
fprintf(fid,sprintf("parameter c = %d;\n", columns - pipeStages));
fprintf(fid,sprintf("parameter w = %d;\n",6));
fprintf(fid,sprintf("parameter reaccessAddressWidth = %d;\n",ceil(log2(maxCycles))));
fprintf(fid,sprintf("input [reaccessAddressWidth-1:0]reaccessAddress;\n"));
fprintf(fid,sprintf("input clk,rst;\n"));
fprintf(fid,sprintf("input [r*w-1:0]dMemIn;\n"));
fprintf(fid,sprintf("wire [w-1:0]dMemInDummy[r-1:0];\n"));
fprintf(fid,sprintf("output wire [r*w -1 : 0]muxOut;// r numbers of w bits\n"));
fprintf(fid,sprintf("reg [w-1:0]muxOutWire[r-1:0];\n"));
fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n"));
fprintf(fid,sprintf("genvar k;\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<r;k=k+1)begin:assign_output\n"));
fprintf(fid,sprintf("        assign muxOut[ (k+1)*w-1:k*w] = muxOutWire[k];\n"));
fprintf(fid,sprintf("        assign dMemInDummy[k] = dMemIn[ (k+1)*w-1:k*w];\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n"));
fprintf(fid,sprintf("integer i;\n"));
fprintf(fid,sprintf("integer j;\n"));
fprintf(fid,sprintf("always @(posedge clk) begin\n"));
fprintf(fid,sprintf("    if (rst) begin\n "));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] = 0;\n"));
fprintf(fid,sprintf("           end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin\n"));
fprintf(fid,sprintf("        // Set (i,j)th value = (i,j-1)th value\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] =  fifoOut[i][j-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("        // Load Inputs\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            fifoOut[i][0] =  dMemInDummy[i]; \n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n"));
fprintf(fid,sprintf("always@(*)begin\n"));
fprintf(fid,sprintf("    case(reaccessAddress)\n"));
fprintf(fid,sprintf("\n"));

regTable = zeros(rows,columns);
regTable(regTable==0) = -1;
for reacessAddress = 0:1:maxCycles-1
  
  %Simulate Shift Register
  for c = size(regTable)(2)-1:-1:1
    regTable(1:end,c+1) = regTable(1:end,c);
  endfor
  regTable(1:end,1) = addressTable(reacessAddress+1,1:end);
  regTable(1,1:end);
  
  %Check if first column (requests) 's elements are in FIFO 
  requests = regTable(1:end,1);
  fifo = regTable(1:end,fifoStartIndex:end);
  requestIndices = findIndexesOfAInB(requests,fifo);

  
  fprintf(fid,sprintf("\t\t %d : begin \n",reacessAddress));
  for outIndex = 0:1:size(requestIndices)(1)-1
    if(requestIndices(outIndex+1,1) == -1)
      fprintf(fid,sprintf("\t\t\t muxOutWire[ %d ] = 0; \n", outIndex));
    else
      fprintf(fid,sprintf("\t\t\t muxOutWire[ %d ] = fifoOut[ %d ][ %d ]; \n", outIndex, requestIndices(outIndex+1,1)-1,requestIndices(outIndex+1,2)-1));
    endif  
  endfor
  fprintf(fid,sprintf("\t\t end\n"));
endfor
fprintf(fid,sprintf("    endcase\n"));
fprintf(fid,sprintf("end\nendmodule\n"));
fclose(fid);