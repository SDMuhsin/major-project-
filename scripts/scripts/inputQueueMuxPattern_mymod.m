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
## @deftypefn {} {@var{retval} =} inputQueueMuxPattern (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-29

% editor: soorajp
% edited 02-01-2021
% 

function muxPattern = inputQueueMuxPattern_mymod (block)
  retval = 0;
  layer0Pattern = layer0AddressMap_mymod(block);%size: ceil(circSize/p)=20, p*length(offsets)=52, lys=2
  inputPattern = loadMemAddressMap();
  inputPattern = transpose(inputPattern(1:end,1:end,block));
  
  #Reverse the columns to make
  ip = zeros(size(inputPattern));
  for i = 1:1:size(ip)(2)
    e = size(ip)(2);
    ip(1:end,i) = inputPattern(1:end,e-i + 1);
  endfor
  
  inputPattern = ip; % ## THIS IS THE FROZEN FIFO ##
  size(inputPattern)
  %muxpattern table is of size(52 symbols wide,number of circulant weight=2, slices=ceil(z/p)=20) 
  muxPattern = zeros(52,2,size(layer0Pattern)(1));
  for slice = 1:1:size(layer0Pattern)(1)%1 to 20
    
    size(layer0Pattern);
    muxPattern(1:end,1:end,slice) = findIndexesOfAInB(layer0Pattern(slice,1:end,1),inputPattern);
  endfor
endfunction
