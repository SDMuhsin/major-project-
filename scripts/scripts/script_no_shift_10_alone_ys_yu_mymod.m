clc
clear all
close all
%-------------------%
%Layer 1 to Layer 0 with Unload align for blocks 1 to 14 only
%--------------------%
block = 1;
for block=1:16
ver_wr_en=1;%to enable printing of module files
ver_wr_en2=0;%to enable printing of instantiation lines

if(ver_wr_en)
shiftEn = 1;
swapLys = 1;
[fifo,fifoRows,fifoColumns,muxPattern] = lyToLyMuxPattern_mymod(block,shiftEn,swapLys);
unloadRequestMap = unloadRequestMap_mymod(block);
unloadMuxPattern = unloadMuxPattern_mymod(fifo,unloadRequestMap);
width = 6;
maxCycles = size(muxPattern)(3);
sliceAddressWidth = ceil(log2(maxCycles));
READDISABLEDCASE = (2^sliceAddressWidth)-1;

filename = sprintf("./outputs/L10/ys_yu/LMem1To0_511_circ%d_ys_yu_scripted.v",block-1);
fid = fopen (filename, "w");
fprintf(fid,sprintf("`timescale 1ns / 1ps\n"));
fprintf(fid,sprintf("module LMem1To0_511_circ%d_ys_yu_scripted(\n",block-1));
%fprintf(fid,sprintf("module L_10_block%d_noshift_wunload_scripted(\n",block));
if(block <= 14)
# -- unload
fprintf(fid,sprintf("        unloadMuxOut,\n"));
fprintf(fid,sprintf("        unload_en,\n"));
fprintf(fid,sprintf("        unloadAddress,\n"));
end
# unload --
fprintf(fid,sprintf("        muxOut,\n"));
fprintf(fid,sprintf("        ly0In,\n"));
fprintf(fid,sprintf("        wr_en,\n"));

if(shiftEn)
fprintf(fid,sprintf("        feedback_en,\n"));
endif

fprintf(fid,sprintf("        rd_address,\n"));
fprintf(fid,sprintf("        rd_en,\n"));
fprintf(fid,sprintf("        clk,\n"));
fprintf(fid,sprintf("        rst\n);\n"));

fprintf(fid,sprintf("parameter w = %d; // DataWidth\n",width));
fprintf(fid,sprintf("parameter r = %d;\n",fifoRows));
fprintf(fid,sprintf("parameter c = %d;\n",fifoColumns));
fprintf(fid,sprintf("parameter ADDRESSWIDTH = %d;\n",sliceAddressWidth));
fprintf(fid,sprintf("parameter muxOutSymbols = %d;\n",size(muxPattern)(1)));

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
fprintf(fid,sprintf("output [ muxOutSymbols * w - 1 : 0]muxOut;\n"));
fprintf(fid,sprintf("input [ r * w - 1 : 0 ]ly0In; // Change #3\n"));
fprintf(fid,sprintf("input wr_en;\n"));
fprintf(fid,sprintf("input [ADDRESSWIDTH-1:0]rd_address;\n"));
fprintf(fid,sprintf("input rd_en;\n"));
fprintf(fid,sprintf("input clk,rst; // #C\n\n"));
if(shiftEn)
fprintf(fid,sprintf("input feedback_en;\n"));
endif

fprintf(fid,sprintf("wire [ADDRESSWIDTH-1:0]rd_address_case;\n"));

if(block<=14)
fprintf(fid,sprintf("wire [ADDRESSWIDTH-1:0]unloadAddress_case;\n"));
end

fprintf(fid,sprintf("wire [w-1:0]ly0InConnector[r-1:0]; // Change #\n"));
fprintf(fid,sprintf("reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];\n"));
fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n\n"));

fprintf(fid,sprintf("genvar k;\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<muxOutSymbols;k=k+1)begin:assign_output\n"));
fprintf(fid,sprintf("        assign muxOut[ (k+1)*w-1:k*w] = muxOutConnector[k];\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n"));
fprintf(fid,sprintf("generate\n"));
fprintf(fid,sprintf("    for (k=0;k<r;k=k+1)begin:assign_input\n"));
fprintf(fid,sprintf("        assign ly0InConnector[k] = ly0In[(k+1)*w-1:k*w];\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("endgenerate\n\n"));

fprintf(fid,sprintf("integer i;\n"));
fprintf(fid,sprintf("integer j;\n\n"));

fprintf(fid,sprintf("always@(posedge clk)begin\n"));
fprintf(fid,sprintf("    if (rst) begin\n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("            for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= 0;\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else if(wr_en) begin\n"));
fprintf(fid,sprintf("        // Shift\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <=  fifoOut[i][j-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("        // Input\n"));

if(shiftEn)
  fprintf(fid,sprintf("        if(feedback_en) begin\n"));
  fprintf(fid,sprintf("         for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("              fifoOut[i][0] <= fifoOut[i][c-1];\n"));
  fprintf(fid,sprintf("         end\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("        else begin\n"));
  fprintf(fid,sprintf("         for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("              fifoOut[i][0] <= ly0InConnector[i];\n"));
  fprintf(fid,sprintf("         end\n"));
  fprintf(fid,sprintf("        end\n"));
else
  fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("            fifoOut[i][0] <= ly0InConnector[i];\n"));
  fprintf(fid,sprintf("        end\n"));
endif

fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin\n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= fifoOut[i][j];\n"));
fprintf(fid,sprintf("           end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n\n"));

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
fprintf(fid,sprintf("              unloadMuxOut[i] = 0;\n"));
fprintf(fid,sprintf("             end\n"));
fprintf(fid,sprintf("       end\n"));
fprintf(fid,sprintf("    endcase\n"));
#-- unload case end
end %block<=14

fprintf(fid,sprintf("    case(rd_address_case)\n"));
  #The case statement generation

  for slice = 1:1:size(muxPattern)(3)
    fprintf(fid,sprintf("       %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(muxPattern)(1)
      fifoIndices = muxPattern(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("       end\n"));
  endfor

fprintf(fid,sprintf("       default: begin\n"));
fprintf(fid,sprintf("             for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
fprintf(fid,sprintf("              muxOutConnector[i] = 0;\n"));
fprintf(fid,sprintf("             end\n"));
fprintf(fid,sprintf("       end\n"));
fprintf(fid,sprintf("    endcase\n"));
fprintf(fid,sprintf("end\n"));

fprintf(fid,sprintf("endmodule\n"));

fclose(fid);

end


end %for block=1 to 16


