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
## @deftypefn {} {@var{retval} =} lmemPatternAndFifo (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-30

function [fifo,muxPattern] = lmemPatternAndFifo (input1, input2)
  retval = 0;
  circSize = 511;
  offsets = [0 176; 99 471];
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

  #
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
  # Actually this isn't necessary....
  # We just need to find maxRelDiff of ly1 pattern
  # And the portion of layer 1 pattern that starts from reaccess ...
  # ...is stored in FIFO and FROZEN
  
  # Actually actually, we need to store everything past reaccessAddress
  
  # I G N O R E This whole quadruple for loop
  #maxRelDiff = 0;
  #for i1 = 1:1:size(addressTable(:,:,1))(1)
  #  for j1 = 1:1:size(addressTable(:,:,1))(2)
  #    if( i1 >= reStartIndex(1,1) && j1 >= reStartIndex(1,2))
  #      for i2 = 1:1:size(addressTable(:,:,2))(1)
  #        for j2 = 1:1:size(addressTable(:,:,2))(2)
  #          if(i2 >= reStartIndex(2,1) && j2 >= reStartIndex(2,2))
  #            if( addressTable(i2,j2,2) ~= 0 && addressTable(i2,j2,2) ==  addressTable(i1,j1,1) && i1 - 1 + i2 > maxRelDiff)
  #              %i1
  #              %j1
  #              %i2
  #              %j2
  #              %addressTable(i2,j2,2)
  #             maxRelDiff = size(addressTable(:,:,1))(1) - i1  + i2; %-1
  #            endif
  #         endif
  #        endfor
  #      endfor
  #    endif
  #  endfor
  #endfor

  %REG TABLE ( r x c )
  rows = length(offsets)*p; % 2 * P
  columns = size(addressTable)(1) - reStartIndex(2,1) + 1;%maxRelDiff + 1; % Including pipeStages
  pipeStages = 0; % DOES NOT MATTER HERE
  fifoStartIndex = pipeStages + 1;  %DOES NOT MATTER HERE
  % Cycles I AM NOT USING THIS EITHER....
  maxCycles = size(addressTable(:,:,1))(1) ; % Actually max cycles is two times this, but i've coded it to make use of this
  
  
  % THIS MATTERS Make and fill FIFO
  fifo = zeros(rows,columns);
  fifo(1:end,1:end) = transpose(addressTable(reStartIndex(2,1):end,1:end,2));
  # Its the other way around...
  temp = zeros(size(fifo));
  for i = 1:1:size(fifo)(2)
    temp(1:end,i) = fifo(1:end, size(fifo)(2) - i + 1);
  endfor
  fifo = temp;
  
  % Now make the request pattern...
  % This is just addressTable(:,:,1)
  requests = addressTable(:,:,1); # 20 x 52
  
  %Now make mux pattern 52 x 2 x 20
  muxPattern = zeros( size(requests)(2) , 2,  size(requests)(1));
  for i = 1:1:size(addressTable)(1)
      muxPattern(:,:,i) = findIndexesOfAInB(requests(i,:),fifo);
  endfor
endfunction
