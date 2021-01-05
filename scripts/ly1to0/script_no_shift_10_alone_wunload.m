clear all;
block = 1;
shiftEn = 0;
swapLys = 1;
[fifo,fifoRows,fifoColumns,muxPattern] = lyToLyMuxPattern(block,shiftEn,swapLys);
unloadRequestMap = unloadRequestMap(block);
unloadMuxPattern = unloadMuxPattern(fifo,unloadRequestMap);
width = 6;

filename = sprintf("L_1to0_block%d_wunload_scripted.txt",block);
fid = fopen (filename, "w");
fprintf(fid,sprintf("`timescale 1ns / 1ps\n"));
fprintf(fid,sprintf("module L_10_block%d_noshift_wunload_scripted(\n",block));
fprintf(fid,sprintf("        muxOut,\n"));

# -- unload
fprintf(fid,sprintf("        unloadMuxOut,\n"));
fprintf(fid,sprintf("        unloadAddress,\n"));
# unload --

fprintf(fid,sprintf("        ly0In,\n"));
fprintf(fid,sprintf("        sliceAddress,\n"));
fprintf(fid,sprintf("        chipEn,\n"));
fprintf(fid,sprintf("        clk,\n"));
fprintf(fid,sprintf("        rst\n);\n"));

fprintf(fid,sprintf("parameter w = 6; // Width\n"));
fprintf(fid,sprintf("parameter r = %d;\n",fifoRows));
fprintf(fid,sprintf("parameter c = %d;\n ",fifoColumns));
fprintf(fid,sprintf("parameter muxOutSymbols = %d;\n",size(muxPattern)(1)));
fprintf(fid,sprintf("parameter maxVal = 6'b011111;\n"));
fprintf(fid,sprintf("input [ r * w - 1 : 0 ]ly0In; // Change #3\n"));
fprintf(fid,sprintf("wire [w-1:0]ly0InConnector[r-1:0]; // Change #\n"));
fprintf(fid,sprintf("input [4:0]sliceAddress;\n"));

# -- unload
fprintf(fid,sprintf("parameter unloadMuxOutBits = 32;\n"));
fprintf(fid,sprintf("output reg [unloadMuxOutBits - 1:0]unloadMuxOut;\n"));
fprintf(fid,sprintf("input [4:0]unloadAddress;\n "));
# unload --

fprintf(fid,sprintf("input clk,rst,chipEn; // #C\n"));
fprintf(fid,sprintf("output wire [ muxOutSymbols * w - 1 : 0]muxOut;\n"));
fprintf(fid,sprintf("reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];\n"));
fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n"));

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
fprintf(fid,sprintf("endgenerate\n"));

fprintf(fid,sprintf("integer i;\n"));
fprintf(fid,sprintf("integer j;\n"));
fprintf(fid,sprintf("always@(posedge clk)begin\n"));
fprintf(fid,sprintf("    if (rst) begin\n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("            for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= 0;\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else if(chipEn) begin\n"));
fprintf(fid,sprintf("        // Shift\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <=  fifoOut[i][j-1];\n"));
fprintf(fid,sprintf("            end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("        // Input\n"));
fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
fprintf(fid,sprintf("            fifoOut[i][0] <= ly0InConnector[i];\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("    else begin\n"));
fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
fprintf(fid,sprintf("                fifoOut[i][j] <= fifoOut[i][j];\n"));
fprintf(fid,sprintf("           end\n"));
fprintf(fid,sprintf("        end\n"));
fprintf(fid,sprintf("    end\n"));
fprintf(fid,sprintf("end\n"));

fprintf(fid,sprintf("always@(*)begin\n"));

#-- unload case start
fprintf(fid,sprintf("    case(unloadAddress)\n"));
for slice = 1:1:size(unloadMuxPattern)(3)
    fprintf(fid,sprintf("       %d: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(unloadMuxPattern)(1)
      fifoIndices = unloadMuxPattern(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              unloadMuxOut[%d] = 1'b0;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              unloadMuxOut[%d] = fifoOut[%d][%d][5];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
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

fprintf(fid,sprintf("    case(sliceAddress)\n"));
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