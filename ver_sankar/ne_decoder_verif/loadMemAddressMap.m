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
## @deftypefn {} {@var{retval} =} loadMemAddressMap (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-29

function loadmemaddressmap = loadMemAddressMap (input1, input2)
%--------Lmem shiftreg Loading circuit------------%
Nb=16;
buffwidth=32;
asmsymbols = (-1)*ones(1,64);
prependsymbols=[1:18];
shortcode_syspart=[1:7136];
shortcode_paritypart=[7136 + 1:7136+1022];
appendsymbols=(-1)*ones(1,2);
rxcodesymbols=[asmsymbols,shortcode_syspart,shortcode_paritypart,appendsymbols];
rxregtable = [asmsymbols,18+shortcode_syspart,18+shortcode_paritypart,appendsymbols];

txcodesymbols=[prependsymbols,18+shortcode_syspart]; %7154=14x511
txrequesttable=[shortcode_syspart];

buffset=rxregtable(1:buffwidth:end);
%size of buffset is 1x257
%257 cycles.
% we need to store to 16 separate storage fifos 
% corresponding to 16 circulants. So 256/16=16.
%So clipping first 32 asm bits.
buffsetclipped=buffset(2:end);
%separating it to 16 rows for 16 circulants:
% we note that we miss last set of symbols for each circulant 
% which is arriving as the first set for next circulant.
%therefore, dupicating this last set, the overall length of buffer
% is incremented by 1 to 16+1=17.
%first symbol indices are shown in rxregtablemod.
% [buffsetclipped(241-1:241-1+16-1),buffsetclipped(241-1+16)]
rxregtablemod=[];
for i=1:Nb
    if(i==Nb)
      j=(i-1)*Nb;
    else
      j=(i-1)*Nb+1;
    end
    tmpvar=[];
    tmpvar=[tmpvar, buffsetclipped(j:j+Nb-1)];
    if((i==14)||(i==15))%corner case: for circ14, last cycle17th is to be avoided, made invalid(32 -1s)
      tmpvar=[tmpvar, -1];
    else
      tmpvar=[tmpvar, buffsetclipped(j+Nb)];
    end
    brkpt=0;
    brkpt=0;
    rxregtablemod=[rxregtablemod;tmpvar];
end
rxregtablemod;
bufflength=length(rxregtablemod(1,:));
%generating address map of loaded memory for each circulant:
%size= 17 rows/cycles, 32 symbols width, 16 circulants.
loadmemaddressmap=zeros(bufflength,buffwidth,Nb);
for i=1:Nb
  zmulstart=1;
  zmulend=511;
  tmpv1 = transpose(rxregtablemod(i,:));
  for j=1:bufflength
    if(tmpv1(j,1)==-1)
      tmpv2=(-1)*ones(1,buffwidth);
    else     
      tmpv2=mod([tmpv1(j,1):1:tmpv1(j,1)+buffwidth-1]-1,511)+1;   
      
      %correcting first indices.      
      if((i!=1)&&(j==1))
        pos=find(tmpv2(1,:)==1);
        tmpv2(1,1:pos-1)=-1;
      end
      
      %correcting last indices.      
      if( ((i!=14)||(i!=15))&&(j==bufflength) )
        pos=find(tmpv2(1,:)==1);
        tmpv2(1,pos:end)=-1;
      end      
      if(((i==14)||(i==15))&&(j==16))
        pos=find(tmpv2(1,:)==1);
        tmpv2(1,pos:end)=-1;
      end
    end
    
    loadmemaddressmap(j,:,i) = tmpv2;
  end
end

endfunction
