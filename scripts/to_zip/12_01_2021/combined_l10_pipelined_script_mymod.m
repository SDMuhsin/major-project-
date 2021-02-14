clc
clear all
close all
%----------------
%pipeline_en=1, for adding pipelineing at first iter mux
% script not tested.
%------------
%-------------------
% try not using for loop, to print each file
% manually modify block number and run the script
% due to possible error: we get half the lines printed in file
%--------------------
block=16;
shiftEn = 0;
swapLys = 1;
pipeline_en=1; %pipeline just before firstiter mux
for block = 1:1:16;
#--------------------------------------------#

# Generate two seperate FIFOs 
#   1. L10 r1 x c1
#   2. input_queue r2 x c2

# Make TWO new FIFOs whose dimnsns = max( L10, input_queue) 
#   1. fifo_l10_filled r x c
#   2. fifo_input_filled r x c

#Generate two seperate mux patterns (L1->0 patterns) for the above queues,
#Generate unload pattern for fifo_l10_filled

#--------------------------------------------#

# STEP 2 : Make : L10 and input_queue 

#1.1 L10 
addressTable = layerAddressMap_mymod(block);
if(swapLys)
  fprintf("Swapping lys .. \n");
  temp = addressTable(:,:,1);
  addressTable(:,:,1) = addressTable(:,:,2);
  addressTable(:,:,2) = temp;
endif
reIndices = getReaccessIndices_mymod(addressTable)
r1 = size(addressTable)(2);
c1 = size(addressTable)(1) - reIndices(1,1) + 1;
fifo = zeros(r1,c1);
fifo = transpose(addressTable(reIndices(1,1):end,:,1));
fifoTemp = zeros(size(fifo));
for i = 1:1:size(fifo)(2)
  fifoTemp(:,i) = fifo(:,size(fifo)(2) - i + 1);
endfor
L10 = fifoTemp;

#1.2 input_queue_dimensions
inputPattern = loadMemAddressMap();
inputPattern = transpose(inputPattern(1:end,1:end,block));
ip = zeros(size(inputPattern));
for i = 1:1:size(ip)(2)
  e = size(ip)(2);
  ip(1:end,i) = inputPattern(1:end,e-i + 1);
endfor
input_queue= ip; % ## THIS IS THE FROZEN FIFO ##

r2 = size(input_queue)(1);
c2 = size(input_queue)(2);


# STEP 2 : Make larger queues fifo_l10_filled, fifo_input_filled
r = max(r1,r2);
r_min = min(r1,r2);

c = max(c1,c2);
c_min = min(c1,c2);

fifo_l10_filled = zeros(r,c);
fifo_input_filled = zeros(r,c);

fifo_l10_filled(1:r1,1:c1) = L10;
fifo_input_filled(1:r2,1:c2) = input_queue;

# Step 3 : Make 2 L1->0 mux patterns for each of the above queues,
#          make unload pattern for fifo_l10_filled alone 

requests=addressTable(:,:,2);
requests(requests==0)=-1;

# 52 (symbols) x 2 ((x,y) cords in shift reg) x 20 (max_cycles)
mux_pattern_from_input = zeros(size(requests)(2),2,size(requests)(1));
mux_pattern_from_l10 = zeros(size(requests)(2),2,size(requests)(1));

fl10 = fifo_l10_filled; #copies of initial state
finp = fifo_input_filled;

%correction make -1's in finp to 0. so that function findIndexesOfAInB
%will find last address's invalid positions as -1,-1
% so that they can be filled with constant maxval.
finp(finp==-1) = 0;

for slice = 1:1:size(requests)(1)
  
  mux_pattern_from_input(:,:,slice) = findIndexesOfAInB(requests(slice,:),finp);
  mux_pattern_from_l10(:,:,slice) = findIndexesOfAInB(requests(slice,:),fl10);
  
  %finp
  %requests(slice,:)
  %mux_pattern_from_input(:,:,slice)
  %prte=0;
  %prte=0;
  
  if(shiftEn)
    fl10 = shiftFifo(fl10);
    finp = shiftFifo(finp);
  endif
endfor

# Make unload pattern
unloadRequests = unloadRequestMap_mymod(block);
fl10 = fifo_l10_filled;#copy of initial state
mux_pattern_unload = zeros(size(unloadRequests)(2),2,size(unloadRequests)(1));
for slice = 1:1:size(unloadRequests)(1)
  
  mux_pattern_unload(:,:,slice) = findIndexesOfAInB(unloadRequests(slice,:),fl10);
  if(shiftEn)
    fl10 = shiftFifo(fl10);
  endif
endfor
unloadMuxPattern = mux_pattern_unload;
#Now print verilog

width = 6;
maxCycles = size(mux_pattern_from_l10)(3);
sliceAddressWidth = ceil(log2(maxCycles));
READDISABLEDCASE = (2^sliceAddressWidth)-1;

if(shiftEn)
  filename = sprintf("./outputs/LMem1To0_511_circ%d_combined_ys_yu_pipelined_scripted_h1.v",block-1);
  fid = fopen (filename, "w");
  fprintf(fid,sprintf("`timescale 1ns / 1ps\n"));
  fprintf(fid,sprintf("module LMem1To0_511_circ%d_combined_ys_yu_pipelined_scripted(\n",block-1));
  %fprintf(fid,sprintf("module L_10_block%d_noshift_wunload_scripted(\n",block));
else
  filename = sprintf("./outputs/LMem1To0_511_circ%d_combined_ns_yu_pipelined_scripted_h1.v",block-1);
  fid = fopen (filename, "w");
  fprintf(fid,sprintf("`timescale 1ns / 1ps\n"));
  fprintf(fid,sprintf("module LMem1To0_511_circ%d_combined_ns_yu_pipelined_scripted(\n",block-1));
  %fprintf(fid,sprintf("module L_10_block%d_noshift_wunload_scripted(\n",block));
endif

if(block <= 14)
# -- unload
fprintf(fid,sprintf("        unloadMuxOut,\n"));
fprintf(fid,sprintf("        unload_en,\n"));
fprintf(fid,sprintf("        unloadAddress,\n"));
end
# unload --
fprintf(fid,sprintf("        muxOut,\n"));
fprintf(fid,sprintf("        ly0In,\n"));
fprintf(fid,sprintf("        rxIn,\n"));
fprintf(fid,sprintf("        load_input_en,\n"));
fprintf(fid,sprintf("        iteration_0_indicator,\n"));
if(shiftEn) #Shift feedback
#fprintf(fid,sprintf("        feedback_en,\n"));
endif

fprintf(fid,sprintf("        wr_en,\n"));
fprintf(fid,sprintf("        rd_address,\n"));
fprintf(fid,sprintf("        rd_en,\n"));
fprintf(fid,sprintf("        clk,\n"));
fprintf(fid,sprintf("        rst\n);\n"));



fprintf(fid,sprintf("parameter w = %d; // DataWidth\n",width));
fprintf(fid,sprintf("parameter r = %d;\n",r));
fprintf(fid,sprintf("parameter r_lower = %d;\n",r_min));
fprintf(fid,sprintf("parameter c = %d;\n",c));
fprintf(fid,sprintf("parameter ADDRESSWIDTH = %d;\n",sliceAddressWidth));
fprintf(fid,sprintf("parameter muxOutSymbols = %d;\n",size(mux_pattern_from_input)(1)));

if(block<=14)
fprintf(fid,sprintf("parameter unloadMuxOutBits = 32;\n"));
end

fprintf(fid,sprintf("parameter maxVal = 6'b011111;\n"));
fprintf(fid,sprintf("parameter READDISABLEDCASE = %d'd%d; // if rd_en is 0 go to a default Address \n\n",sliceAddressWidth,READDISABLEDCASE));

if(block<=14)
# -- unload
fprintf(fid,sprintf("output reg [unloadMuxOutBits - 1:0]unloadMuxOut;\n"));
fprintf(fid,sprintf("input unload_en;\n"));
fprintf(fid,sprintf("input [ADDRESSWIDTH-1:0]unloadAddress;\n"));
# unload --
end
if(shiftEn)
fprintf(fid,sprintf("reg feedback_en;\n"));
endif

fprintf(fid,sprintf("input load_input_en;\n"));
fprintf(fid,sprintf("input iteration_0_indicator;\n"));
fprintf(fid,sprintf("output [ muxOutSymbols * w - 1 : 0]muxOut;\n"));
fprintf(fid,sprintf("input [ r * w - 1 : 0 ]ly0In; // Change #3\n"));
fprintf(fid,sprintf("input [ r_lower * w - 1 : 0 ] rxIn; // Change #3\n"));
fprintf(fid,sprintf("input wr_en;\n"));
fprintf(fid,sprintf("input [ADDRESSWIDTH-1:0]rd_address;\n"));
fprintf(fid,sprintf("input rd_en;\n"));
fprintf(fid,sprintf("input clk,rst; // #C\n\n"));

fprintf(fid,sprintf("wire [ADDRESSWIDTH-1:0]rd_address_case;\n"));
fprintf(fid,sprintf("reg [ w - 1 : 0 ]column_1[ r - 1 : 0 ];\n"));
fprintf(fid,sprintf("reg chip_en;\n"));
if(block<=14)
fprintf(fid,sprintf("wire [ADDRESSWIDTH-1:0]unloadAddress_case;\n"));
end

fprintf(fid,sprintf("wire [w-1:0]ly0InConnector[r-1:0]; // Change #\n"));
fprintf(fid,sprintf("wire [w-1:0]rxInConnector[r_lower-1:0]; // Change #\n"));

if(pipeline_en)
fprintf(fid,sprintf("reg [ muxOutSymbols * w - 1 : 0]muxOut_firstiter_reg0, muxOut_process_reg0;\n"));
fprintf(fid,sprintf("wire [ muxOutSymbols * w - 1 : 0]muxOut_firstiter, muxOut_process;\n"));
fprintf(fid,sprintf("reg [w-1:0]muxOutConnector_firstiter[ muxOutSymbols  - 1 : 0];\n"));
fprintf(fid,sprintf("reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];\n"));
else
fprintf(fid,sprintf("reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];\n"));
end

fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n\n"));

if(pipeline_en)
fprintf(fid,sprintf(" assign muxOut = iteration_0_indicator ? muxOut_firstiter_reg0 : muxOut_process_reg0;\n"));
fprintf(fid,sprintf("always@(posedge clk)begin\n"));
fprintf(fid,sprintf("    if (!rst) begin\n"));
fprintf(fid,sprintf("      muxOut_firstiter_reg0 <= 0;\n"));
fprintf(fid,sprintf("      muxOut_process_reg0 <= 0;\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin\n"));
fprintf(fid,sprintf("      muxOut_firstiter_reg0 <= muxOut_firstiter;\n"));
fprintf(fid,sprintf("      muxOut_process_reg0 <= muxOut_process;\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n\n"));
end

fprintf(fid,sprintf("genvar k;\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<muxOutSymbols;k=k+1)begin:assign_output\n"));
if(pipeline_en)
fprintf(fid,sprintf("        assign muxOut_firstiter[ (k+1)*w-1:k*w] = muxOutConnector_firstiter[k];\n"));
fprintf(fid,sprintf("        assign muxOut_process[ (k+1)*w-1:k*w] = muxOutConnector[k];\n"));
else
fprintf(fid,sprintf("        assign muxOut[ (k+1)*w-1:k*w] = muxOutConnector[k];\n"));
end

fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<r;k=k+1)begin:assign_input\n"));
fprintf(fid,sprintf("        assign ly0InConnector[k] = ly0In[(k+1)*w-1:k*w];\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<r_lower;k=k+1)begin:assign_rx\n"));
fprintf(fid,sprintf("        assign rxInConnector[k] = rxIn[(k+1)*w-1:k*w];\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n\n"));



fprintf(fid,sprintf("integer i;\n"));
fprintf(fid,sprintf("integer j;\n\n"));
fprintf(fid,sprintf("always@(posedge clk)begin\n"));
fprintf(fid,sprintf("    if (!rst) begin\n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("            for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= 0;\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else if(chip_en) begin\n"));
fprintf(fid,sprintf("        // Shift\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <=  fifoOut[i][j-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("        // Input\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            fifoOut[i][0] <= column_1[i];\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin\n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= fifoOut[i][j];\n"));
fprintf(fid,sprintf("           end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n\n"));

if(shiftEn)
fprintf(fid,sprintf("    always@(*) begin\n"));
if(block<=14)
fprintf(fid,sprintf("      feedback_en=(unload_en||rd_en);\n"));
else
fprintf(fid,sprintf("      feedback_en=rd_en;\n"));
endif
fprintf(fid,sprintf("      if(load_input_en)begin\n"));
fprintf(fid,sprintf("        chip_en=load_input_en;\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("      else if(wr_en)begin\n"));
fprintf(fid,sprintf("        chip_en=wr_en;\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("      else begin\n"));
fprintf(fid,sprintf("        chip_en=feedback_en;\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            if(feedback_en)begin\n"));
fprintf(fid,sprintf("                 column_1[i] <= fifoOut[i][c-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("            else if(load_input_en)begin\n"));
fprintf(fid,sprintf("                 if(i < r_lower)begin\n"));
fprintf(fid,sprintf("                   column_1[i] = rxInConnector[i];\n"));
fprintf(fid,sprintf("                 end\n"));
fprintf(fid,sprintf("                 else begin\n"));
fprintf(fid,sprintf("                   column_1[i] = maxVal;\n"));
fprintf(fid,sprintf("                 end\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("            else begin\n"));
fprintf(fid,sprintf("                 column_1[i] <= ly0InConnector[i];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
else

fprintf(fid,sprintf("    always@(*) begin\n"));
fprintf(fid,sprintf("      if(load_input_en)begin\n"));
fprintf(fid,sprintf("        chip_en=load_input_en;\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("      else if(wr_en)begin\n"));
fprintf(fid,sprintf("        chip_en=wr_en;\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("      else begin // if wr_en or load_en=0, dont shift or load inputs\n"));
fprintf(fid,sprintf("        chip_en=0;\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("      for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("        if(load_input_en)begin\n"));
fprintf(fid,sprintf("          if(i < r_lower)begin\n"));
fprintf(fid,sprintf("             column_1[i] = rxInConnector[i];\n"));
fprintf(fid,sprintf("          end\n"));
fprintf(fid,sprintf("          else begin\n"));
fprintf(fid,sprintf("             column_1[i] = maxVal;\n"));
fprintf(fid,sprintf("          end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("        else begin//wr_en=1 or 0 or load_en=0 case: connect input but loading does not happen since chipen=0\n"));
fprintf(fid,sprintf("          column_1[i] <= ly0InConnector[i];\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("      end\n"));
fprintf(fid,sprintf("    end//always\n"));

%was the error lines:
%fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
%
%fprintf(fid,sprintf("            if(load_input_en)begin\n"));
%fprintf(fid,sprintf("                 if(i < r_lower)begin\n"));
%fprintf(fid,sprintf("                   fifoOut[i][0] = rxInConnector[i];\n"));
%fprintf(fid,sprintf("                 end\n"));
%fprintf(fid,sprintf("                 else begin\n"));
%fprintf(fid,sprintf("                   fifoOut[i][0] = maxVal;\n"));
%fprintf(fid,sprintf("                 end\n"));
%fprintf(fid,sprintf("            end\n"));
%fprintf(fid,sprintf("            else begin\n"));
%fprintf(fid,sprintf("                 fifoOut[i][0] <= ly0InConnector[i];\n"));
%fprintf(fid,sprintf("            end\n"));
%fprintf(fid,sprintf("        end\n"));

endif

#fprintf(fid,sprintf("    end\n"));

fprintf(fid,sprintf("assign rd_address_case = rd_en ? rd_address : READDISABLEDCASE;\n\n")); 
if(block<=14)
fprintf(fid,sprintf("assign unloadAddress_case = unload_en ? unloadAddress : READDISABLEDCASE;\n\n")); 
end

fprintf(fid,sprintf("always@(*)begin\n"));
if(block<=14)
#-- unload case start
fprintf(fid,sprintf("    case(unloadAddress_case)\n"));
for slice = 1:1:size(unloadMuxPattern)(3)
    fprintf(fid,sprintf("       %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(unloadMuxPattern)(1)
      fifoIndices = unloadMuxPattern(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              unloadMuxOut[%d] = 1'b0;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              unloadMuxOut[%d] = fifoOut[%d][%d][w-1];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
      
    endfor
    fprintf(fid,sprintf("       end\n"));
endfor

fprintf(fid,sprintf("       default: begin\n"));
fprintf(fid,sprintf("             for(i=0;i<unloadMuxOutBits;i=i+1)begin\n"));
fprintf(fid,sprintf("              unloadMuxOut[i] = 0; \n"));
fprintf(fid,sprintf("             end\n"));
fprintf(fid,sprintf("       end\n"));
fprintf(fid,sprintf("    endcase //unload case end\n"));
#-- unload case end
end %block<=14

if(pipeline_en)

%normal processing case
fprintf(fid,sprintf("         case(rd_address_case)\n"));
  #The case statement generation L1->0 read align

  for slice = 1:1:size(mux_pattern_from_l10)(3)
    fprintf(fid,sprintf("         %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(mux_pattern_from_l10)(1)
      fifoIndices = mux_pattern_from_l10(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("         end\n"));
  endfor

fprintf(fid,sprintf("         default: begin\n"));
fprintf(fid,sprintf("               for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
fprintf(fid,sprintf("                muxOutConnector[i] = 0;\n"));
fprintf(fid,sprintf("              end\n"));
fprintf(fid,sprintf("         end\n//hgjhgbuiguigbigbgbgbui\n"));
fprintf(fid,sprintf("         endcase\n")); #Internal case readaddress case

%first iter ((iter==0) && (lyr==0)) case
fprintf(fid,sprintf("       case(rd_address_case)\n"));
#The case statement generation Linput->0 read align
fprintf("HELLO\n\n");
  for slice = 1:1:size(mux_pattern_from_input)(3)
    fprintf(fid,sprintf("         %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(mux_pattern_from_input)(1)
      fifoIndices = mux_pattern_from_input(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector_firstiter[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector_firstiter[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("         end\n"));
  endfor
  fprintf("HELLO\n\n");
  fprintf(fid,sprintf("         default: begin\n"));
  fprintf(fid,sprintf("               for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
  fprintf(fid,sprintf("                muxOutConnector_firstiter[i] = 0;\n"));
  fprintf(fid,sprintf("              end\n"));
  fprintf(fid,sprintf("         end\n"));
  fprintf(fid,sprintf("     endcase\n")); #Internal case readaddress case

  
  
else

fprintf(fid,sprintf("    case(iteration_0_indicator)\n"));
fprintf(fid,sprintf("       0: begin\n"));  
fprintf(fid,sprintf("         case(rd_address_case)\n"));
  #The case statement generation L1->0 read align

  for slice = 1:1:size(mux_pattern_from_l10)(3)
    fprintf(fid,sprintf("         %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(mux_pattern_from_l10)(1)
      fifoIndices = mux_pattern_from_l10(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("         end\n"));
  endfor

fprintf(fid,sprintf("         default: begin\n"));
fprintf(fid,sprintf("               for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
fprintf(fid,sprintf("                muxOutConnector[i] = 0;\n"));
fprintf(fid,sprintf("              end\n"));
fprintf(fid,sprintf("         end\n//hgjhgbuiguigbigbgbgbui\n"));
fprintf(fid,sprintf("         endcase\n")); #Internal case readaddress case
fprintf(fid,sprintf("    end\n")); #External firstiter case, case (0) end

%fclose(fid);
%
%if(shiftEn)
%  filename = sprintf("./outputs/LMem1To0_511_circ%d_combined_ys_yu_scripted_h2.v",block-1);
%  fid = fopen (filename, "w");
%else
%  filename = sprintf("./outputs/LMem1To0_511_circ%d_combined_ns_yu_scripted_h2.v",block-1);
%  fid = fopen (filename, "w");
%
%endif
fprintf(fid,sprintf("       1: begin // iteration_0_indicator = 1\n"));
fprintf(fid,sprintf("       case(rd_address_case)\n"));
#The case statement generation Linput->0 read align
fprintf("HELLO\n\n");
  for slice = 1:1:size(mux_pattern_from_input)(3)
    fprintf(fid,sprintf("         %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(mux_pattern_from_input)(1)
      fifoIndices = mux_pattern_from_input(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("         end\n"));
  endfor
  fprintf("HELLO\n\n");
  fprintf(fid,sprintf("         default: begin\n"));
  fprintf(fid,sprintf("               for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
  fprintf(fid,sprintf("                muxOutConnector[i] = 0;\n"));
  fprintf(fid,sprintf("              end\n"));
  fprintf(fid,sprintf("         end\n"));
  fprintf(fid,sprintf("     endcase\n")); #Internal case readaddress case
  fprintf(fid,sprintf("    end\n")); #External firstiter case, case (1) end


fprintf("HELLO\n\n");

fprintf(fid,sprintf("         default: begin\n"));
fprintf(fid,sprintf("               for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
fprintf(fid,sprintf("                muxOutConnector[i] = 0;\n"));
fprintf(fid,sprintf("              end\n"));
fprintf(fid,sprintf("         end\n")); # External case firstiter
fprintf(fid,sprintf("    endcase\n")); #External case firstiter

end %if(pipeline_en) else part end


fprintf(fid,sprintf("end//always\n"));
fprintf(fid,sprintf("endmodule\n"));
fclose(fid);
endfor

%