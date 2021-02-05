% Near Earth Decoder Throughout analysis
clc
clear all
close all
%---throughput---%
old=0;%0 for new, 1 for old
if(old)
prt= "old spec calculation"
end
incycles=(8160+64)/32;
if(old)
loadcycles=511%511%ceil((512+1)/32)
else
loadcycles=ceil((512+1)/32)
end
addresses=ceil(511/26)
memaccesscycle=1
if(old)
rcu_pipestages=6%6%9
else
rcu_pipestages=13%11%11%13%9
end
agenstart=1
overallpipestages=agenstart + 1*memaccesscycle + rcu_pipestages%agenstart+2*memaccesscycle+rcu_pipestages
stallcycles = 1*memaccesscycle + rcu_pipestages + 1 % taking RCU +2 as stall cycles, can be reduced.
layers=2
Maxitrs=30%25%20%10
decodecycles=Maxitrs*(layers*(addresses+stallcycles))
if(old)
unloadcycles=511%511%size(unloadrequestmap(:,:,13))(1)
else
unloadcycles=ceil((512+1)/32)%size(unloadrequestmap(:,:,13))(1)
end
loadunloadcycles = loadcycles+unloadcycles %max([unloadcycles,loadcycles])
if(old)
adjustment=0%0%4
else
adjustment=4
end
outcycles=(7136/32)
decodeclkcycles_withload=(loadunloadcycles+adjustment)+decodecycles
decodeclkcycles_withoutload=decodecycles
throughput_gbps_req=1.6 %target throughput is 1.6 gbps
T_req_withload = (7136/(decodeclkcycles_withload*throughput_gbps_req))
T_req_withoutload = (7136/(decodeclkcycles_withoutload*throughput_gbps_req))

%Clock frequency calculation:
%in_clk T, decodeclk T, outclk T
N=incycles
D=decodeclkcycles_withload
K=outcycles
lcmval = lcm(N,D,K)
n_mul=lcmval/N
k_mul=lcmval/K
d_mul=lcmval/D
prt=sprintf("incycles x (lcm/incycles) = decodecycleswithload x (lcm/decodecycleswithload) = outcycles x (lcm/outcycles) :-")
prt=sprintf("%d x %d = %d x %d = %d x %d ",N,n_mul, D,d_mul, K,k_mul)
%decode clk period : d_t
d_t=T_req_withload
%multiplication factor:
dfactor= d_t/d_mul
%clock periods: 
Tinclk=n_mul_x_dfactor = n_mul*dfactor
Toutclk=k_mul_x_dfactor = k_mul*dfactor
Tclk=d_mul_x_dfactor = d_mul*dfactor
%Print results:
prt=sprintf("incycles x Tinclk = decodecycleswithload x Tclk = outcycles x Toutclk :-",N,n_mul, D,d_mul, K,k_mul)
prt=sprintf("%d x %d = %d x %d = %d x %d ",N,Tinclk, D,Tclk, K,Toutclk)