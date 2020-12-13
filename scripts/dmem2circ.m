circSize = 511;
offsets = [0 176; 99 471];
%offsets = [0 4; 5 7];
p = 26; %Rows per slice

lys = size(offsets);
lys = lys(1);
circ = 1;
filename = sprintf("Dmem_combined_scripted.txt",circSize);
fid = fopen (filename, "w");
fprintf(fid,sprintf("module DMem_%d_circ%d_Scripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t reaccessAddress,\n\t\t ly,\n\t\t clk,rst \n );\n",circ,circSize));

offsets=offsets.+1;
onesTable = zeros(2*circSize,length(offsets));

% ADDRESS OF 1s
for ly = 1:1:lys
  for i=1:1:circSize
      
      %I called this variable slice but its actually row
      slice = (ly-1)*circSize + i;
      onesTable(slice,1:end) = mod(offsets(ly,1:end),circSize);
      
      % Replace 0 with circSize
      if(onesTable(slice,1) == 0)
        onesTable(slice,1) = circSize;
      endif
      if(onesTable(slice,2) == 0)
        onesTable(slice,2) = circSize;
      endif
      offsets(ly,1:end) = offsets(ly,1:end).+1;
  endfor
endfor
% ADDRESS TABLE
addressTable = zeros( ceil(circSize/p), p*length(offsets), lys);


for ly = 1:1:lys
  normIndex = 1;
  for i = 1:p:circSize
    %printf(" %d to %d",i,i+p-1)
    startIndex = (ly-1)*circSize + i;
    endIndex = (ly-1)*circSize + i+p-1;
    
    rowLimit = (ly-1)*circSize + circSize;
    if(endIndex  > rowLimit)
      addressTable( normIndex, 1:end, ly) = [ [transpose(onesTable(startIndex:rowLimit,1)), zeros(1, endIndex - rowLimit) ], [transpose(onesTable(startIndex:rowLimit,2)), zeros(1, endIndex - rowLimit) ] ] ;
    else
      addressTable( normIndex, 1:end,ly) = [ transpose(onesTable(startIndex:endIndex,1)), transpose(onesTable(startIndex:endIndex,2)) ] ;
    endif
    
    normIndex+=1;
  endfor
endfor
% REG TABLE


%First find where reaccess begins for both layers

reStartIndex = zeros(2,2);

%layer 0 reaccess
flag = 0;
symbolCount = zeros(1,circSize);
for i = 1:1:size(addressTable(:,:,1))(1)  
if(~flag)
for j = 1:1:size(addressTable(:,:,1))(2)
  if(addressTable(i,j,1) ~= 0)

    symbolCount(addressTable(i,j,1)) = symbolCount(addressTable(i,j,1)) +  1;
    if(symbolCount(addressTable(i,j,1)) == 2)
      
      reStartIndex(1,:) = [i,j]
      flag = 1;
      break;
  endif
  endif
endfor  
endif
endfor

% layer 1 reaccess
flag = 0;
symbolCount = zeros(1,circSize);
for i = 1:1:size(addressTable(:,:,2))(1)  
if(~flag)
for j = 1:1:size(addressTable(:,:,2))(2)
  if(addressTable(i,j,2) ~= 0)
    symbolCount(addressTable(i,j,2)) = symbolCount(addressTable(i,j,2)) +  1;
    if(symbolCount(addressTable(i,j,2)) == 2)
      addressTable(i,j,2)
      reStartIndex(2,:) = [i,j]
      flag = 1;
      break;
  endif
  endif
endfor  
endif
endfor

% Secondly, find maximum number of delay elements requires, including pipeStages...
% ... seperately for both circulants

maxRelDiffs = zeros(1,lys);

for ly = 1:1:ly
  for i = 1:1:size(addressTable(:,:,ly))(1)
    for j = i+1:1:size(addressTable(:,:,ly))(1)
      if( anyOfAInB( addressTable(j,1:end,ly), addressTable(i,1:end,ly)))
        if(j-i > maxRelDiffs(ly))
          maxRelDiffs(ly) = j-i+1;
          maxRelDiffs;
        endif
      endif
    endfor
  endfor
endfor

maxRelDiff = max(maxRelDiffs);

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
fprintf(fid,sprintf("input clk,rst,ly;\n"));
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
fprintf(fid,sprintf("    case({ly,reaccessAddress})\n"));
fprintf(fid,sprintf("\n"));


for ly = 1:1:lys
regTable = zeros(rows,columns);
regTable(regTable==0) = -1;
for reacessAddress = 0:1:maxCycles-1
  
  %Simulate Shift Register
  for c = size(regTable)(2)-1:-1:1
    regTable(1:end,c+1) = regTable(1:end,c);
  endfor
  regTable(1:end,1) = addressTable(reacessAddress+1,1:end,ly);
  regTable(1,1:end);
  
  %Check if first column (requests) 's elements are in FIFO 
  requests = regTable(1:end,1);
  fifo = regTable(1:end,fifoStartIndex:end);
  requestIndices = findIndexesOfAInB(requests,fifo);

  
  fprintf(fid,sprintf("\t\t {1'b %d, 5'd %d} : begin \n",ly-1,reacessAddress));
  for outIndex = 0:1:size(requestIndices)(1)-1
    if(requestIndices(outIndex+1,1) == -1)
      fprintf(fid,sprintf("\t\t\t muxOutWire[ %d ] = 0; \n", outIndex));
    else
      fprintf(fid,sprintf("\t\t\t muxOutWire[ %d ] = fifoOut[ %d ][ %d ]; \n", outIndex, requestIndices(outIndex+1,1)-1,requestIndices(outIndex+1,2)-1));
    endif  
  endfor
  fprintf(fid,sprintf("\t\t end\n"));
endfor
endfor

fprintf(fid,sprintf("    default:begin \n"));
for outIndex = 0:1:size(requestIndices)(1)-1
    fprintf(fid,sprintf("\t\t\t muxOutWire[ %d ] = 0; \n", outIndex));
endfor

fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    endcase\n"));
fprintf(fid,sprintf("end\nendmodule\n"));
fclose(fid);