clc
clear all
close all

%finding offsets of each layer circulants 
p_rowsperslice=26;%4;%8;%26;%7;
z=511;
p_cycles=ceil(z/p_rowsperslice);%20;%73;%cycles
%mat = func_makecirculantlocations(firstrow,z,z);
[h,hloc] = func_makeHNE_LOC(z);
Wc=sum(hloc(1,:)~=0)
lyr1_offsets= hloc(1,:)-1
lyr2_offsets=hloc(512,:)-1
layeroffsets = [lyr1_offsets;lyr2_offsets];
ver_wr_en=1;%to enable printing of module files
ver_wr_en2=0;%to enable printing of instantiation lines

%print modules for each circulant
circ=1;
for circ=1:16
  offsets_circ = layeroffsets(:,((2*circ)-1):(2*circ) )

if(ver_wr_en)

%-------- Script for Dmem circuit of a circulant of both layers ---------%
circSize = 511;
offsets = offsets_circ;%[0 176; 99 471];
%offsets = [0 4; 5 7];
p = 26; %Rows per slice

lys = size(offsets);
lys = lys(1);

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
sliceAddressWidth = ceil(log2(maxCycles));
READDISABLEDCASE = (2^sliceAddressWidth)-1;
%circ = 1;
filename = sprintf("./outputs/Dmem_circ%d_scripted.v",circ-1);%circSize);
fid = fopen (filename, "w");


fprintf(fid,sprintf("`timescale 1ns / 1ps\n"));%,circSize));
fprintf(fid,sprintf("module Dmem_circ%d_scripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t wr_en,\n\t\t reaccessAddress,\n\t\t reaccess_lyr,\n\t\t rd_en, clk, rst \n );\n",circ-1));%,circSize));

fprintf(fid,sprintf("parameter r = %d;\n", rows));
fprintf(fid,sprintf("parameter c = %d;\n", columns - pipeStages));
fprintf(fid,sprintf("parameter w = %d;\n",6));
fprintf(fid,sprintf("parameter ADDRESSWIDTH = %d;\n\n",sliceAddressWidth));
fprintf(fid,sprintf("parameter READDISABLEDCASE = %d'd%d; // if rd_en is 0 go to a default Address \n",sliceAddressWidth,READDISABLEDCASE));

fprintf(fid,sprintf("output wire [r*w -1 : 0]muxOut;// r numbers of w bits\n"));
fprintf(fid,sprintf("input [r*w-1:0]dMemIn;\n"));
fprintf(fid,sprintf("input wr_en;\n"));
fprintf(fid,sprintf("input [ADDRESSWIDTH-1:0]reaccessAddress;\n"));
fprintf(fid,sprintf("input reaccess_lyr;\n"));
fprintf(fid,sprintf("input rd_en;\n"));
fprintf(fid,sprintf("input clk,rst;\n\n"));

fprintf(fid,sprintf("wire [(ADDRESSWIDTH+1)-1:0]case_sel;//{layer,address}\n")); 
fprintf(fid,sprintf("wire [w-1:0]dMemInDummy[r-1:0];\n"));
fprintf(fid,sprintf("reg [w-1:0]muxOutWire[r-1:0];\n"));
fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n\n"));

fprintf(fid,sprintf("genvar k;\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<r;k=k+1)begin:assign_output\n"));
fprintf(fid,sprintf("        assign muxOut[ (k+1)*w-1:k*w] = muxOutWire[k];\n"));
fprintf(fid,sprintf("        assign dMemInDummy[k] = dMemIn[ (k+1)*w-1:k*w];\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n\n"));

fprintf(fid,sprintf("integer i;\n"));
fprintf(fid,sprintf("integer j;\n\n"));

fprintf(fid,sprintf("always @(posedge clk) begin\n"));
fprintf(fid,sprintf("    if (rst) begin\n "));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] = 0;\n"));
fprintf(fid,sprintf("           end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin\n"));
fprintf(fid,sprintf("    if(wr_en) begin\n"));
fprintf(fid,sprintf("        // Set (i,j)th value = (i,j-1)th value\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <=  fifoOut[i][j-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("        // Load Inputs\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            fifoOut[i][0] <= dMemInDummy[i]; \n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin \n"));
fprintf(fid,sprintf("        // Set (i,j)th value = (i,j)th value\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= fifoOut[i][j];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n\n"));

fprintf(fid,sprintf("assign case_sel = rd_en ? {reaccess_lyr,reaccessAddress} : {1'd1,READDISABLEDCASE};\n\n")); 

fprintf(fid,sprintf("always@(*) begin\n"));

%fprintf(fid,sprintf("case(rd_en)\n"));
%fprintf(fid,sprintf("    1'b0: begin \n"));
%
%fprintf(fid,sprintf("       for(i=0;i<r;i=i+1)begin \n"));
%fprintf(fid,sprintf("         muxOutWire[i] = 0; \n"));
%fprintf(fid,sprintf("       end \n"));
%
%fprintf(fid,sprintf("    end\n"));
%
%fprintf(fid,sprintf("    1'b1:begin \n"));

%fprintf(fid,sprintf("    case({rd_en,reaccess_lyr,reaccessAddress})\n"));
fprintf(fid,sprintf("    case(case_sel)\n"));
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

  
  %fprintf(fid,sprintf("\t\t {1'd1, 1'd%d, 5'd%d} : begin \n",ly-1,reacessAddress));
  fprintf(fid,sprintf("\t\t {1'd%d, 5'd%d} : begin \n",ly-1,reacessAddress));
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


%fprintf(fid,sprintf(" default:begin \n"));
%fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin \n"));
%fprintf(fid,sprintf("          muxOutWire[i] = 0; \n"));
%fprintf(fid,sprintf("        end \n"));
%fprintf(fid,sprintf(" end \n"));
%fprintf(fid,sprintf(" endcase\n"));

fprintf(fid,sprintf("end\nendmodule\n"));
fclose(fid);
%---------Script for Dmem circuit of a circulant of both layers ---------%
end%verilog print enable

end%for all circ

%-------------------printing instances for Lmem---------------------------%
if(ver_wr_en2)

  filename = sprintf("./outputs/DMeminstances.v");
  fid = fopen (filename, "w");
  for circ=1:16
    fprintf(fid,sprintf("\ndefparam dmemcirc%d.w=W, dmemcirc%d.r=P*Wt; //addresswidth is constant at 5.",circ-1,circ-1));    
    fprintf(fid,sprintf("\nDmem_circ%d_scripted dmemcirc%d(dmem_data_out[%d],dmem_data_in[%d],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);\n",circ-1,circ-1,circ-1,circ-1));    
    %Dmem_circ%d_scripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t wr_en,\n\t\t reaccessAddress,\n\t\t reaccess_lyr,\n\t\t rd_en, clk, rst \n );\n",circ-1));%,circSize));
  end
  fclose(fid);
end

%Test indices:
%W=6;
%for i=0:1:15 
%  for j=0:1:25 
%    for k=0:1:1  
%      xc=( (j*2) + (i*26*2) + k );
%      xcw=( (j*2) + (i*26*2) + k )*W;
%      xc2=( (j*2) + k );
%      xc2w=xc2*W;
%      
%      prt=sprintf("assign wr_data_arr[%d][%d][%d] = wr_data[ ( ( (%d*Wt) + (%d*P*Wt) + %d +1)*W)-1: ( ( (%d*Wt) + (%d*P*Wt) + %d )*W)];",i,j,k,j,i,k,j,i,k)
%      prt=sprintf("assign wr_data_arr[%d][%d][%d] = wr_data[ ( %d +1)*W)-1: ( %d )*W)];",i,j,k,xc,xc)
%      prt=sprintf("assign wr_data_arr[%d][%d][%d] = wr_data[ ( %d ): ( %d )];",i,j,k,((xc+1)*W)-1,xcw)
%      
%      prt=sprintf("assign dMemIn[%d][( ( (%d*Wt) + %d + 1)*W )-1:( ( (%d*Wt) + %d )*W )] = wr_data_arr[%d][%d][%d];",i,j,k,j,k,i,j,k)
%      prt=sprintf("assign dMemIn[%d][( ( %d + 1)*W )-1:( ( %d )*W )] = wr_data_arr[%d][%d][%d];",i,xc2,xc2,i,j,k)
%      prt=sprintf("assign dMemIn[%d][( %d ): ( %d )] = wr_data_arr[%d][%d][%d];",i,((xc2+1)*W)-1,xc2w,i,j,k)
%      
%      prte=0;
%      prte=0;
%    end 
%  end 
%end

