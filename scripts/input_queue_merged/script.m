circSize = 511;
offsets = [0 176; 99 471];
%offsets = [0 4; 5 7];
p = 26; %Rows per slice

lys = size(offsets);
lys = lys(1);

filename = sprintf("LMem0To1_%d_scripted.txt",circSize);
fid = fopen (filename, "w");
fprintf(fid,sprintf("module LMem0to1%dScripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t reaccessAddress,\n\t\t ly,\n\t\t clk,rst \n );\n",circSize));

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

%Secondly, find maximum number of delay elements requires, including pipeLineStages

maxRelDiff = 0;
for i1 = 1:1:size(addressTable(:,:,1))(1)
  for j1 = 1:1:size(addressTable(:,:,1))(2)
    if( i1 >= reStartIndex(1,1) && j1 >= reStartIndex(1,2))
      for i2 = 1:1:size(addressTable(:,:,2))(1)
        for j2 = 1:1:size(addressTable(:,:,2))(2)
          if(i2 >= reStartIndex(2,1) && j2 >= reStartIndex(2,2))
            if( addressTable(i2,j2,2) ~= 0 && addressTable(i2,j2,2) ==  addressTable(i1,j1,1) && i1 - 1 + i2 > maxRelDiff)
              %i1
              %j1
              %i2
              %j2
              %addressTable(i2,j2,2)
              maxRelDiff = size(addressTable(:,:,1))(1) - i1  + i2; %-1
            endif
          endif
        endfor
      endfor
    endif
  endfor
endfor

%REG TABLE ( r x c )
rows = length(offsets)*p; % 2 * P
columns = size(addressTable)(1) - reStartIndex(1,1) + 1;%maxRelDiff + 1; % Including pipeStages
pipeStages = 0; % DOES NOT MATTER HERE
fifoStartIndex = pipeStages + 1;  %DOES NOT MATTER HERE
% Cycles
maxCycles = size(addressTable(:,:,2))(1) ; % Actually max cycles is two times this, but i've coded it to make use of this

fprintf(fid,sprintf("parameter r = %d;\n", rows));
fprintf(fid,sprintf("parameter c = %d;\n", columns - pipeStages));
fprintf(fid,sprintf("parameter w = %d;\n",6));
fprintf(fid,sprintf("parameter reaccessAddressWidth = %d;\n",ceil(log2(maxCycles))));
fprintf(fid,sprintf("input [reaccessAddressWidth-1:0]reaccessAddress;\n"));
fprintf(fid,sprintf("input ly;\n"));
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
fprintf(fid,sprintf("    if(ly==1'b0)begin\n"));
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
fprintf(fid,sprintf("    else begin \n"));
fprintf(fid,sprintf("        // Set (i,j)th value = (i,j)th value\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] =  fifoOut[i][j-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n"));
fprintf(fid,sprintf("always@(*)begin\n"));
fprintf(fid,sprintf("case(ly)\n"));
fprintf(fid,sprintf("    1'b0: begin \n"));

fprintf(fid,sprintf("       for(i=0;i<r;i=i+1)begin \n"));
fprintf(fid,sprintf("         muxOutWire[i] = 0; \n"));
fprintf(fid,sprintf("       end \n"));

fprintf(fid,sprintf("    end\n"));

fprintf(fid,sprintf("    1'b1:begin \n"));
fprintf(fid,sprintf("     case(reaccessAddress)\n"));
fprintf(fid,sprintf("\n"));

regTable = zeros(rows,columns);
regTable(regTable==0) = -1;

%%ASSUMPTION : We are starting from the beginning of layer 1, by this time layer 0's values are already in the shift register
%size(regTable)
regTable(:,:) = transpose(addressTable( end - columns + 1:end , :,1));
%size(regTable)
ly = 1
for reacessAddress = 0:1:maxCycles-1 % 0th cycle is already accounted for
  
  
  %Check ly 1's rows are the requests
  requests = addressTable(reacessAddress + 1, 1:end, ly + 1);
  
  fifo = regTable(1:end,fifoStartIndex:end);
  fifo;
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

  % No need to simuilate shift register
  %Simulate Shift Register, this will be the next cycle's state
  %for c = size(regTable)(2)-1:-1:1
  %  regTable(1:end,c+1) = regTable(1:end,c);
  %endfor
  %regTable(1:end,1) = addressTable( reacessAddress+1, 1:end, ly);
  %regTable(1,1:end);
  
endfor

fprintf(fid,sprintf("       default:begin \n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin \n"));
fprintf(fid,sprintf("          muxOutWire[i] = 0; \n"));
fprintf(fid,sprintf("        end \n"));
fprintf(fid,sprintf("       end \n"));

fprintf(fid,sprintf("     endcase\n"));
fprintf(fid,sprintf("    end\n"));


fprintf(fid,sprintf(" default:begin \n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin \n"));
fprintf(fid,sprintf("          muxOutWire[i] = 0; \n"));
fprintf(fid,sprintf("        end \n"));
fprintf(fid,sprintf(" end \n"));

fprintf(fid,sprintf("endcase\n"));
fprintf(fid,sprintf("end\nendmodule\n"));
fclose(fid);