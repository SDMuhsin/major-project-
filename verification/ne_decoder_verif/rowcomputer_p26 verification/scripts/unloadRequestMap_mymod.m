%Edits: sooraj
% bug: in unloadrequestmap : it was considering 7136 
% instead it had to consider 7154.
function unloadrequestmap = unloadRequestMap_mymod(block)
if(block > 14)
  unloadrequestmap = -1;
  return;
endif
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



%For the request list of first circulant
%make 1 to 18 symbol indices occurring in requests list of -1.
%so that findIndexesOfAInB wil give -1 invalid values
%so muxoutwire will be made 0 for those locations.
%for i=1:length(requests)
%  for j=1:18 
%    if(requests(1,i)==j)
%       requests(1,i)=-1;
%    end 
%  end
%end

%--unloading--%
%generating unloadrequestmap
%based on transmitting out shortened msg=code(19:7154) = (1:7136) only
Kb=14;%(7136+18)/511 = 7154/511 = 14
msgpart=18+shortcode_syspart;
msgbuffset=msgpart(1:buffwidth:end);
msgrequesttablemod=[];
numofrequests=ceil(511/32)+1
unloadrequestmap=(-1)*ones(numofrequests,buffwidth,Kb);
off1=0;
pos1=1;
for i=1:Kb
  requestidx=off1;
  offset=(i-1)*511;
  lastval=offset+511;
  if(lastval<msgpart(1,end)) %Bug: was 7136
    poslast1 = find(msgbuffset>lastval)(1);
    parselist=msgbuffset(pos1:poslast1-1);
    pos1=poslast1;
  else
    poslast1 = find(msgbuffset<msgpart(1,end))(end); %Bug: was 7136
    parselist=msgbuffset(pos1:poslast1);    
  end
  
  for j=parselist%1:buffwidth:(511)%length(msgpart)        
    requestidx=requestidx+1;
    prt=sprintf("[i , j, reqestidx]=[%d, %d, %d]",i,j,requestidx);  
    tmp=[j:j+buffwidth-1];  %msgpart(1,j+offset:j+offset+buffwidth-1)
    pos=find(tmp==offset+511);
    poslast=find(tmp==msgpart(1,end)); %Bug: was 7136
    %offset correction
    tmpmod=mod(tmp-1,511)+1;
    brkpt=0;
    brkpt=0;
    if(length(pos)!=0)%if 511 multiple present
      off1=1;
      tmpold=tmp;
      %offset correction
      tmpoldmod=tmpmod;
      
      tmpold(1,1:pos)=-1;
      tmp(1,pos+1:end)=-1;          
      tmpoldmod(1,1:pos)=-1;
      tmpmod(1,pos+1:end)=-1;          
    end    
    if(length(poslast)!=0)
      tmp(1,poslast+1:end)=-1;  
      tmpmod(1,poslast+1:end)=-1;  
      off1=0;
    end
    unloadrequestmap(requestidx,:,i)=tmpmod;%tmp;
    unloadrequestmap(requestidx,:,i);
    brkpt=0;
    brkpt=0;
  end
  if(off1==1)
    unloadrequestmap(1,:,i+1)=tmpoldmod;%tmpold;
    unloadrequestmap(1,:,i+1);
     brkpt=0;
     brkpt=0;
     
  else
     "finished"
     unloadrequestmap(:,:,i);
     brkpt=0;
     brkpt=0;
     break;
  end

end
 
# block i => requestmap(:,:, i )
%if sys part is 1:7136  (19:7154)
size(unloadrequestmap)
unloadrequestmap = unloadrequestmap(:,:,block);

%if sys part is 1:7154
%unloadrequestmap = unloadrequestmap2(:,:,block);
endfunction
