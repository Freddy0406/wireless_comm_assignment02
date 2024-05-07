clc;
clear;
close all;

W = 3.1;
time_step = 9998;
channel_length = 3;
N = time_step+channel_length-1;
%% Channel (h)
h = zeros(1,channel_length);
for i = 1:channel_length
    h(i) = 0.5*(1+cos((2*pi/W)*(i-2)));
end

%% Filter input signal (u,d)
u = zeros(1,N);
a = rand(1,time_step).*2-1;
var_v = 0.001;

%convolution (h * a)
for n = 1:length(u)
    noise = sqrt(var_v)*randn;
    for k = 1:channel_length
        if(n-k>0 && n-k<(time_step+1))
            temp = h(k)*a(n-k); 
        else
            temp = 0;
        end
        u(n) = temp+u(n);
    end
    u(n) = u(n)+noise;    
end

d = zeros(1,N);

for n = 1:length(d)
    if(n-7>0 && n-7<length(a)+1)
        d(n) = a(n-7);
    else
        d(n) = 0;
    end
end

%% Channel equalizer filter w(n) RLS LMS
[mse] = RLS(u,d,1,250,N);
semilogy(mse)
xlim([0 500])

%Output