## Copyright (C) 2021 sayed
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
## @deftypefn {} {@var{retval} =} lyToLyMuxPattern (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-04

function [fifoInit,fifoRows,fifoColumns,muxPattern] = lyToLyMuxPattern_mymod(block,shiftEn,swapLys)

addressTable = layerAddressMap_mymod(block);

if(swapLys)
  fprintf("Hello");
  temp = addressTable(:,:,1);
  addressTable(:,:,1) = addressTable(:,:,2);
  
  addressTable(:,:,2) = temp;
endif
# Define FIFO dimensions r x c
# r = 52, c = 20 - first re-access row

reIndices = getReaccessIndices_mymod(addressTable)
fifoRows = size(addressTable)(2);
fifoColumns = size(addressTable)(1) - reIndices(1,1) + 1

#Initialise FIFO : FIFO will be filled with rows of addressTable(:,:,1) starting from reaccess
fifo = zeros(fifoRows,fifoColumns);
fifo = transpose(addressTable(reIndices(1,1):end,:,1));
fifoTemp = zeros(size(fifo));
for i = 1:1:size(fifo)(2)
  fifoTemp(:,i) = fifo(:,size(fifo)(2) - i + 1);
endfor
fifo = fifoTemp;
fifoInit = fifoTemp;
#Generate Mux Pattern

#Shift ON
if(shiftEn)
  
  muxPattern = -1 * ones( fifoRows, 2, size(addressTable)(1));
  for slice = 1:1:size(muxPattern)(3)
    
    %Earlier: requests contain '0's and fifo also contain '0's
    %so findIndexesOfAInB matches them and gets a match.
    % but actually '0' is invalid request.
    % so we need -1 there.
    %Mod: to avoid [52][1] index to come for '0' entries.
    requests=addressTable(slice,:,2);
    requests(requests==0)=-1;
    muxPattern(:,:,slice) = findIndexesOfAInB( requests, fifo);
    
    fifo = shiftFifo(fifo);
    fprintf("Shifting...");
  end  
  fprintf("\n");
else
  muxPattern = -1 * ones( fifoRows, 2, size(addressTable)(1));
  for slice = 1:1:size(muxPattern)(3)
    
    %Earlier: requests contain '0's and fifo also contain '0's
    %so findIndexesOfAInB matches them and gets a match.
    % but actually '0' is invalid request.
    % so we need -1 there.
    %Mod: to avoid [52][1] index to come for '0' entries.
    requests=addressTable(slice,:,2);
    requests(requests==0)=-1;
    muxPattern(:,:,slice) = findIndexesOfAInB( requests, fifo);
  end  
endif
endfunction
