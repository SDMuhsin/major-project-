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
## @deftypefn {} {@var{retval} =} inputQueueScript (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-29

function [muxPattern] = inputQueueScript(block)
  
  clear all;
  retval = 0;
  block = 1;
  muxPattern = inputQueueMuxPattern(block); # 52 x 2 x 20
  fifoRows = 32;
  fifoColumns = 17;
  muxOutSymbols = size(muxPattern)(1);
  sliceAddressWidth = ceil(log2(size(muxPattern)(3)));
  
  filename = sprintf("InputQueueCirc_%d.txt",block);
  fid = fopen (filename, "w");
  
  fprintf(fid,sprintf("`timescale 1ns / 1ps \n"));
  fprintf(fid,sprintf("module InputQueueCirc_%d(\n",block));
  fprintf(fid,sprintf("        muxOut,\n"));
  fprintf(fid,sprintf("        rxIn,\n"));
  fprintf(fid,sprintf("        sliceAddress,\n"));
  fprintf(fid,sprintf("        wrEn,\n"));
  fprintf(fid,sprintf("        chipEn,\n"));
  fprintf(fid,sprintf("        clk,\n"));
  fprintf(fid,sprintf("        rst\n"));
  fprintf(fid,sprintf(");\n"));
  fprintf(fid,sprintf("parameter w = 6; // Width \n"));
  fprintf(fid,sprintf("parameter maxVal = 63; // These are 0 LLRs \n"));
  fprintf(fid,sprintf("parameter r = %d; // Rows of FIFO and input symbol count \n",fifoRows));
  fprintf(fid,sprintf("parameter c = %d; // Columns of FIFO\n",fifoColumns));
  fprintf(fid,sprintf("parameter muxOutSymbols = %d;\n",muxOutSymbols));
  fprintf(fid,sprintf("input [ r * w - 1 : 0 ]rxIn;\n"));
  fprintf(fid,sprintf("wire [w-1:0]rxInConnector[r-1:0];\n"));
  fprintf(fid,sprintf("output wire [ muxOutSymbols * w - 1 : 0]muxOut;\n"));
  fprintf(fid,sprintf("reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];\n"));
  fprintf(fid,sprintf("input [%d:0]sliceAddress;\n",sliceAddressWidth));
  fprintf(fid,sprintf("input chipEn,wrEn;\n input clk,rst;\n"));
  fprintf(fid,sprintf("reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs\n"));
  fprintf(fid,sprintf("genvar k;\n"));
  fprintf(fid,sprintf("generate\n"));
  fprintf(fid,sprintf("    for (k=0;k<muxOutSymbols;k=k+1)begin:assign_output \n"));
  fprintf(fid,sprintf("        assign muxOut[ (k+1)*w-1:k*w] = muxOutConnector[k];\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("endgenerate\n"));
  fprintf(fid,sprintf("generate\n"));
  fprintf(fid,sprintf("    for (k=0;k<r;k=k+1)begin:assign_input\n"));
  fprintf(fid,sprintf("        assign rxInConnector[k] = rxIn[(k+1)*w-1:k*w];\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("endgenerate\n"));
  fprintf(fid,sprintf("integer i;\n"));
  fprintf(fid,sprintf("integer j;\n"));
  fprintf(fid,sprintf("always@(posedge clk)begin\n"));
  fprintf(fid,sprintf("    if (rst) begin\n"));
  fprintf(fid,sprintf("        for(i=0;i<r;i=i+1)begin\n"));
  fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
  fprintf(fid,sprintf("                fifoOut[i][j] <= 0;\n"));
  fprintf(fid,sprintf("           end  \n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("    else if(chipEn) begin\n"));
  fprintf(fid,sprintf("        //LOAD inputs\n"));
  fprintf(fid,sprintf("        if(wrEn)begin // Whether to accept input or not\n"));
  fprintf(fid,sprintf("            //Accept input\n"));
  fprintf(fid,sprintf("            for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("               fifoOut[i][0] <= rxInConnector[i];\n"));
  fprintf(fid,sprintf("            end\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("        else begin\n"));
  fprintf(fid,sprintf("            // If input is not to be accepted, fifo's first row keeps the same values \n"));
  fprintf(fid,sprintf("            for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("                fifoOut[i][0] <= fifoOut[i][0];\n"));
  fprintf(fid,sprintf("            end\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("        //Shifting process\n"));
  fprintf(fid,sprintf("        // Set (i,j)th value = (i,j-1)th value (except column 0)\n"));
  fprintf(fid,sprintf("        for(i = r-1; i > -1; i=i-1) begin\n"));
  fprintf(fid,sprintf("            for(j= c-1; j > 0; j=j-1)begin\n"));
  fprintf(fid,sprintf("                fifoOut[i][j] <=  fifoOut[i][j-1];\n"));
  fprintf(fid,sprintf("            end\n"));
  fprintf(fid,sprintf("        end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("    else begin\n"));
  fprintf(fid,sprintf("       for(i=0;i<r;i=i+1)begin\n"));
  fprintf(fid,sprintf("           for(j=0;j<c;j=j+1)begin\n"));
  fprintf(fid,sprintf("                fifoOut[i][j] <= fifoOut[i][j];\n"));
  fprintf(fid,sprintf("           end\n"));
  fprintf(fid,sprintf("       end\n"));
  fprintf(fid,sprintf("    end\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("// MUX WIRING\n"));
  fprintf(fid,sprintf("always@(*)begin\n"));
  fprintf(fid,sprintf("    case(sliceAddress)\n"));
  
  #Script muxPattern 52 x 2 x 20
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
  fprintf(fid,sprintf("              muxOutConnector[i] = 1;\n"));
  fprintf(fid,sprintf("             end\n"));
  fprintf(fid,sprintf("       end\n"));
  fprintf(fid,sprintf("    endcase\n"));
  fprintf(fid,sprintf("end\n"));
  fprintf(fid,sprintf("endmodule\n"));
  fclose(fid);   
endfunction
