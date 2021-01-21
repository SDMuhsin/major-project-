function [Adp, B12, Cdp, Edp, X_12inv, X_22] = func_preprocess_for_ru_encoder(Msub,hdp,foundrows_dp)

[mb,nb] = size(hdp);
newh = zeros(mb,nb);

f_rows = foundrows_dp;
for i = 1:rows(newh)
  newh(i,:) = hdp(f_rows(i),:);
end
newh = gf(newh,1);
%Segregating into sub matrix sections
[Adp,Bdp,Tdp,Cdp,Ddp,Edp] = findalt(newh);
 trowdp = size(Tdp,1);%rows(Tdp);
 
minusetinv = -(Edp/Tdp);
[m_etinv,n_etinv] = size(minusetinv);
%premulmat = [eye(columns(minusetinv),columns(minusetinv)) , zeros(columns(minusetinv),rows(minusetinv));
%minusetinv,eye(rows(minusetinv),rows(minusetinv))];
premulmat = [eye(n_etinv,n_etinv) , zeros(n_etinv,m_etinv);minusetinv,eye(m_etinv,m_etinv)];

%"premultiplication.."
htilda= premulmat*newh;
[At,Bt,Ttilda,Ct,Dt,Et]= findalt(htilda);

 B12 = Bdp(:,Msub+1:2*Msub);
%X_12 = Dt(1:128,129:256);
%X_22 = Dt(129:256,129:256);
X_12 = Dt(1:Msub,Msub+1:2*Msub);
X_22 = Dt(Msub+1:2*Msub,Msub+1:2*Msub);
det(X_12)
X_12inv = inv(X_12); 

end