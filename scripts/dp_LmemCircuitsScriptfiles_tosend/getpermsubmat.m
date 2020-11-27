%subfunction for making AR4JA H matrix
%The construction of submatices of H matrix.
%using pik eqn in ccsds which resulted in pmatvec 
% it gives 1's location in the M rows of Perm Matrix.

%Pemutation matrix is constructed as:
%Bug in this function.
%function permsubmat = getpermsubmat(k2,M)
%  permsubmat = zeros(M,M);
%  pmatk3 = pmatvec(k2,M);
%  for i3=1:M/4:M
%    j = pmatk3(i3);
%    permmatrow = zeros(1,M);
%    permmatrow(j+1) = 1; %since vecpmodM values j2 can be zero.
%    permsubmat(i3,:) = permmatrow;    
%    for j3 = 1:((M/4) - 1)
%      permmatrow = [permmatrow(M),permmatrow(1:M-1)];
%      permsubmat(i3+j3,:) = permmatrow;
%    end%forj3
%  end%fori3
%end%function

%Pemutation matrix is constructed as:

function permsubmat = getpermsubmat(k,M)
  permsubmat = zeros(M,M);
  pmatk = pmatvec(k,M); % The location of 1 of each row.
  for i=1:M/4:M
     % i3
    j = pmatk(i); 
    %j
    permmatrow = zeros(1,M);
    permmatrow(j+1) = 1; %since j values can be zero.
    permsubmat(i,:) = permmatrow;    
%    prte=0;
%    prte=0;
    
    circ1 = makecirculant(permmatrow(1,1:(M/4)),M/4);
    circ2 = makecirculant(permmatrow(1,(M/4)+1:(2*M/4)),M/4);
    circ3 = makecirculant(permmatrow(1,(2*M/4)+1:(3*M/4)),M/4);
    circ4 = makecirculant(permmatrow(1,(3*M/4)+1:(4*M/4)),M/4);
    
    permsubmat(i:i+(M/4)-1,:) = [circ1,circ2,circ3,circ4];
%    for j3 = 1:((M/4) - 1)  
%        %*Bug,in using this line%
%%      bug: permmatrow = [permmatrow(M),permmatrow(1:M-1)];  
%
%      %solved: to get M/4 bit circulants in M bit Matrix.
%      permmatrow(1,1:(M/4)) = [permmatrow(1, M/4), permmatrow(1, 1:(M/4)-1)];
%      permmatrow(1,(M/4)+1:(2*M/4)) = [permmatrow(1, 2*M/4), permmatrow(1, (M/4)+1:(2*M/4)-1)];
%      permmatrow(1,(2*M/4)+1:(3*M/4)) = [permmatrow(1, 3*M/4), permmatrow(1, (2*M/4)+1:(3*M/4)-1)];
%      permmatrow(1,(3*M/4)+1:(4*M/4)) = [permmatrow(1, 4*M/4), permmatrow(1, (3*M/4)+1:(4*M/4)-1)];
%      
%      permsubmat(i3+j3,:) = permmatrow;
%    end%forj3
            
  end%fori
%spy(permsubmat)
%size(permsubmat)
  %permsubmat = gf(permsubmat,1);
end