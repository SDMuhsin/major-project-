function codeword = func_ru_encoder(Msub,s, Adp, B12, Cdp, Edp, X_12inv, X_22)
m=Msub;

%s, Msub, Adp, B12, Cdp, Edp, X_12inv, X22
% "Equations for AR4JA"
m=Msub;
f = smvm(Adp,s);
v = smvm(Cdp(1:m,:),s);
u1 = smvm(Edp(1:m,:),f);
u2 = smvm(Edp(m+1:2*m,:),f);

x1 = u1+v;
x2 = u2;
x = [x1, x2];

p12 = dmvm(X_12inv,x1);
xp = smvm(X_22, p12);
p11 = u2+xp;
p1 = [p11,p12];

pb = smvm(B12,p12);
p2 = pb+f;

%"Parity sections"
p1;
p2;
codeword = gf2toint([s,p1,p2]);
  
endfunction
