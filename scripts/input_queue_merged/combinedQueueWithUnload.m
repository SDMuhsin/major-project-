## Copyright (C) 2020 sayed
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} combinedQueueScript (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-30

clear all;
block = 1;
[fifoRows,fifoColumns,fifoLoadInputFilled,fifoLy1Filled,iter0MuxPattern,higherIterMuxPattern] = combinedFifoAndMuxPatterns(block);
unloadMuxPattern = unloadMuxPattern(block);
lowerR = 32;
  filename = sprintf("CombinedQueueCirc_%d.txt",block);
  fid = fopen (filename, "w");
  
  fprintf(fid,sprintf("`timescale 1ns / 1ps \n"));
  fprintf(fid,sprintf("module CombinedQueueCirc_%d(\n",block));
  fprintf(fid,sprintf("        muxOut,\n"));
  fprintf(fid,sprintf("        unloadMuxOut,\n"));
  fprintf(fid,sprintf("        rxIn,\n"));
  fprintf(fid,sprintf("        ly1In,\n"));
  fprintf(fid,sprintf("        inputLoadEn,\n"));
  fprintf(fid,sprintf("        unloadEn,\n"));
  fprintf(fid,sprintf("        sliceAddress,\n"));
  fprintf(fid,sprintf("        unloadAddress,\n"));
  fprintf(fid,sprintf("        wrEn,\n"));
  fprintf(fid,sprintf("        chipEn,\n"));
  fprintf(fid,sprintf("        clk,\n"));
  fprintf(fid,sprintf("        rst\n"));
  fprintf(fid,sprintf(");\n"));
  fprintf(fid,sprintf("parameter w = 6; // Width \n"));
  
  fprintf(fid,sprintf("parameter r = %d; \n",fifoRows));
  fprintf(fid,sprintf("parameter c = %d; \n",fifoColumns));
  fprintf(fid,sprintf("parameter muxOutSymbols = 26 * 2;\n"));
  fprintf(fid,sprintf("parameter maxVal = 63;\n"));
  fprintf(fid,sprintf("parameter lowerR = %d; //Change #4\n",lowerR));
  fprintf(fid,sprintf("input [ lowerR * w - 1 : 0 ]rxIn;\n"));
  fprintf(fid,sprintf("input [ r * w - 1 : 0 ]ly1In; // Change #3\n"));
  fprintf(fid,sprintf("wire [w-1:0]rxInConnector[lowerR-1:0];\n"));
  fprintf(fid,sprintf("wire [w-1:0]ly1InConnector[r-1:0]; // Change #5\n"));
  fprintf(fid,sprintf("output wire [ muxOutSymbols * w - 1 : 0]muxOut;\n"));
  fprintf(fid,sprintf("reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];\n"));
  fprintf(fid,sprintf("output reg [ lowerR - 1 : 0]unloadMuxOut; // #C\n"));
  fprintf(fid,sprintf("input [4:0]sliceAddress;\n"));
  fprintf(fid,sprintf("input [4:0]unloadAddress;\n"));
  fprintf(fid,sprintf("input inputLoadEn,unloadEn; // cahnge #10\n"));
  fprintf(fid,sprintf("input chipEn,wrEn;\n"));
  fprintf(fid,sprintf("input clk,rst;\n"));
  fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n"));
  fprintf(fid,sprintf("genvar k;\n"));
  fprintf(fid,sprintf("generate\n"));
  fprintf(fid,sprintf("for (k=0;k<muxOutSymbols;k=k+1)begin:assign_output\n"));
  fprintf(fid,sprintf("assign muxOut[ (k+1)*w-1:k*w] = muxOutConnector[k];\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("endgenerate\n"));
  fprintf(fid,sprintf("generate\n"));
  fprintf(fid,sprintf("for (k=0;k<r;k=k+1)begin:assign_input\n"));
  fprintf(fid,sprintf("    assign ly1InConnector[k] = ly1In[(k+1)*w-1:k*w];\n"));
  fprintf(fid,sprintf("    if(k < lowerR)begin\n"));
  fprintf(fid,sprintf("        assign rxInConnector[k] = rxIn[(k+1)*w-1:k*w];\n"));
  fprintf(fid,sprintf("    end // change #8\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("endgenerate\n"));
  fprintf(fid,sprintf("integer i;\n"));
  fprintf(fid,sprintf("integer j;\n"));
  fprintf(fid,sprintf("always@(posedge clk)begin\n"));
  fprintf(fid,sprintf("if (rst) begin    \n"));
  fprintf(fid,sprintf("    for(i=0;i<r;i=i+1)begin\n"));
  fprintf(fid,sprintf("       for(j=0;j<c;j=j+1)begin\n"));
  fprintf(fid,sprintf("            fifoOut[i][j] <= 0;\n"));
  fprintf(fid,sprintf("       end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("else if(chipEn) begin\n"));
  fprintf(fid,sprintf("    if(wrEn)begin\n"));
  fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("            if(inputLoadEn)begin\n"));
  fprintf(fid,sprintf("                if(i < lowerR)begin\n"));
  fprintf(fid,sprintf("                    fifoOut[i][0] <= rxInConnector[i];\n"));
  fprintf(fid,sprintf("                end\n"));
  fprintf(fid,sprintf("                else begin\n"));
  fprintf(fid,sprintf("                    fifoOut[i][0] <= maxVal;\n"));
  fprintf(fid,sprintf("                end\n"));
  fprintf(fid,sprintf("            end\n"));
  fprintf(fid,sprintf("            else begin\n"));
  fprintf(fid,sprintf("                fifoOut[i][0] <= ly1InConnector[i];\n"));
  fprintf(fid,sprintf("            end\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("    else begin\n"));
  fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("            fifoOut[i][0] <= fifoOut[i][0];\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("    //Shifting process\n"));
  fprintf(fid,sprintf("    // Set (i,j)th value = (i,j-1)th value (except column 0)\n"));
  fprintf(fid,sprintf("    for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("        for(j= c-1; j > 0; j=j-1)begin\n"));
  fprintf(fid,sprintf("            fifoOut[i][j] <=  fifoOut[i][j-1];\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("else begin\n"));
  fprintf(fid,sprintf("    for(i=0;i<r;i=i+1)begin\n"));
  fprintf(fid,sprintf("       for(j=0;j<c;j=j+1)begin\n"));
  fprintf(fid,sprintf("            fifoOut[i][j] <= fifoOut[i][j];\n"));
  fprintf(fid,sprintf("       end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("end\n"));
  
  
  #Seperate case statement for unload
  fprintf(fid,sprintf("always@(*)begin\n"));  
  fprintf(fid,sprintf("if(unloadEn)begin\n"));  
  fprintf(fid,sprintf("    case(unloadAddress)\n")); 
 
  for unloadAddress = 1:1:size(unloadMuxPattern)(3)
    fprintf(fid,sprintf("       %d : begin\n",unloadAddress-1));
    for outSymbolIndex = 1:1:size(unloadMuxPattern)(1)
      fifoIndices = unloadMuxPattern(outSymbolIndex,1:end,unloadAddress);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              unloadMuxOut[%d] = 1'b0;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              unloadMuxOut[%d] = fifoOut[%d][%d][5];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("        end\n"));  
  endfor
  
  
  fprintf(fid,sprintf("        default:begin\n"));  
  fprintf(fid,sprintf("            for(i = 0; i < lowerR; i=i+1)begin\n"));  
  fprintf(fid,sprintf("                unloadMuxOut[i] = 1'b0;\n"));  
  fprintf(fid,sprintf("            end\n"));  
  fprintf(fid,sprintf("        end\n"));  
  fprintf(fid,sprintf("    endcase\n"));  
  fprintf(fid,sprintf("end\n"));  
  fprintf(fid,sprintf("else begin\n"));
  fprintf(fid,sprintf("    unloadMuxOut = 0;\n"));
  fprintf(fid,sprintf("end\n"));
  
  fprintf(fid,sprintf("case({unloadEn,sliceAddress})\n"));
  fprintf(fid,sprintf("//iter0 = 0 => not first iteration\n"));
  
  #Script
  #for iter0 = 0 (Not first iteration
  
  for slice = 1:1:size(higherIterMuxPattern)(3)
    fprintf(fid,sprintf("       {1'b0,5'd %d}: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(higherIterMuxPattern)(1)
      fifoIndices = higherIterMuxPattern(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("       end\n"));
  endfor
  #for iter0 = 1
  
  fprintf(fid,sprintf("//iter0 = 1 => first iteration \n"));
  for slice = 1:1:size(iter0MuxPattern)(3)
    fprintf(fid,sprintf("       {1'b1,5'd %d }: begin\n",slice-1));  
    for outSymbolIndex = 1:1:size(iter0MuxPattern)(1)
      fifoIndices = iter0MuxPattern(outSymbolIndex,1:end,slice);
      
      #if index = -1, not found in fifo, MAXVAL... or 0?
      if(fifoIndices(1) == -1 || fifoIndices(2) == -1)
        fprintf(fid,sprintf("              muxOutConnector[%d] = maxVal;\n",outSymbolIndex-1));      
      else
        fprintf(fid,sprintf("              muxOutConnector[%d] = fifoOut[%d][%d];\n",outSymbolIndex-1,fifoIndices(1)-1,fifoIndices(2)-1));      
      endif
    endfor
    fprintf(fid,sprintf("       end\n"));
  endfor
  
  fprintf(fid,sprintf("\n"));
  
  
  
  fprintf(fid,sprintf("default: begin\n"));
  fprintf(fid,sprintf("     for(i=0;i<muxOutSymbols;i=i+1)begin\n"));
  fprintf(fid,sprintf("      muxOutConnector[i] = 0; // change #13\n"));
  fprintf(fid,sprintf("     end\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("endcase\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("endmodule\n"));
  fclose(fid);   
