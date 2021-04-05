function parityshiftsequence= func_getparityshiftsequence(Z,Lm)
  %parityshiftsequence is 1xZ list if Lm is not factor of Z
  % it is Lmx(Z/Lm) matrix if Lm is factor of Z
  
  %Z=511;
  %Lm=73;
  x=[0:1:Z-1]; %make a list of parity reg indices

parityshiftsequence=mod([0:Lm:(Lm*Z)-1],Z); %parity shift sequence
%for Z and Lm factors case:
if(mod(Z,Lm)==0)
temp1=parityshiftsequence(1:(Z/Lm));
for i=1:length(x)
  if(length(find(temp1==x(i)))==0)
    j=x(i);
    temp=mod([j:Lm:(Lm*Z)-1],Z);
    temp1=[temp1;temp(1,1:(Z/Lm))];
  end
end
parityshiftsequence=temp1;
end
  
end
