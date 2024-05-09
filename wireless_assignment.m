clc;
clear;
close all;


rng(100);
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
a = rand(1,time_step).*2-1;     %Uniform[-1,1]
var_v = 0.001;                  %Noise variance 

%convolution (h * a)

u = conv(h,a);
noise_v = sqrt(var_v)*randn(1,N);
u = u+noise_v;

d = zeros(1,N);
for n = 1:length(d)
%     if(n-7>0 && n-7<length(a)+1)
%         d(n) = a(n-7);
%     else
%         d(n) = 0;
%     end
    if(n<=time_step)
        d(n) = a(n);
    else
        d(n) = 0;
    end
end
%% Channel equalizer filter w(n) RLS LMS
[mse_rls] = RLS(u,d,1,250,N);
[mse_lms] = LMS(u,d,0.075,N);
semilogy(mse_rls)
hold on
semilogy(mse_lms)
legend('RLS','LMS',"Location","Best")
xlim([0 250])

%Output