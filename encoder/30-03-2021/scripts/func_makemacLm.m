function macLm = func_makemacLm(circrow,Lm)
  macLm=zeros(Lm,size(circrow)(2));
  macLm(1,:) = circrow;
  for i=2:Lm
    macLm(i,:)=[macLm(i-1,2:end),macLm(i-1,1)];%leftshift
  end
end
