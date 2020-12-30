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
## @deftypefn {} {@var{retval} =} combinedFifoAndMuxPatterns (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-30

function [fifoRows,fifoColumns,fifoLoadInputFilled,fifoLy1Filled,iter0MuxPattern,higherIterMuxPattern] = combinedFifoAndMuxPatterns (block)
  
  # We are going to up the input to ly0 fifo and ly1 to ly0 fifo as though..
  # .. they were seperate, filled with the symbols they are epxected to be filled with..
  # ..when frozen ( They'll both contain all symbols of the circulant)
  # We'll then create a new fifo of
  %clear all;
  retval = 0;
  block = 1;
  
  
  muxPattern = inputQueueMuxPattern(block); # 52 x 2 x 20

  % Make input to ly0 fifo
  loadMemAddressMap = loadMemAddressMap();
  inputPattern = transpose(loadMemAddressMap(1:end,1:end,block));  
  #Reverse the columns to make this a fifo
  ip = zeros(size(inputPattern));
  for i = 1:1:size(ip)(2)
    e = size(ip)(2);
    ip(1:end,i) = inputPattern(1:end,e-i + 1);
  endfor
  loadInputFifo = ip; % ## THIS IS THE FROZEN FIFO ##
  
  
  %Make ly 1 to ly 0 fifo
  [lyToLyFifo,lyToLyMuxPattern] = lmemPatternAndFifo();
  
  % ly 1 to ly 0 fifo
  lyFifoRows = size(lyToLyFifo)(1)
  lyFifoColumns = size(lyToLyFifo)(2)
  
  % input to ly 0 fifo
  loadInputFifoRows = size(loadInputFifo)(1);
  loadInputFifoColumns = size(loadInputFifo)(2);
  
  % new  fifo
  fifoRows = max(loadInputFifoRows,lyFifoRows);
  fifoColumns = max(loadInputFifoColumns,lyFifoColumns);
  
  fifoLoadInputFilled = zeros(fifoRows,fifoColumns);
  fifoLy1Filled = zeros(fifoRows,fifoColumns);
  
  %Fill with input pattern
  fifoLoadInputFilled(1:loadInputFifoRows,1:loadInputFifoColumns) = loadInputFifo;
  fifoLy1Filled(1:lyFifoRows,1:lyFifoColumns) = lyToLyFifo;
  
  
  %First we need request pattern, which is common to both
  requestPattern = layer0AddressMap(block)(:,:,1); % 20 x 52 x 2 -> 20 x 52 (function returns both ly amaps)
  size(requestPattern);
  %hence max cycles, common to both
  maxCycles = size(requestPattern)(1);
  
  
  
  %Now we create mux patterns, two mux patterns in fact
  iter0MuxPattern = zeros(52,2,maxCycles);
  higherIterMuxPattern = zeros(52,2,maxCycles);
  
  for i = 1:1:size(requestPattern)(1)
    
    %fill fifo for iteration 0
    %fifo(1:loadInputFifoRows,1:loadInputFifoColumns) = fifo();
    size(requestPattern(i,1:end));
    size(iter0MuxPattern(:,:,i));
    iter0MuxPattern(:,:,i) = findIndexesOfAInB(requestPattern(i,1:end),fifoLoadInputFilled);
    higherIterMuxPattern(:,:,i) = findIndexesOfAInB(requestPattern(i,1:end),fifoLy1Filled);
  endfor
  
endfunction
