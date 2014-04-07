%%IS-O Understanding Matlab Script
%   Author: Raphael Nagel
%   Date created: 14/Mar/2014
close all 


%% Position and Orientation Vector in Earth-fixed frame {E}
eta_1 = [1 1 1]';
eta_2 = [2 2 2]';
eta = [eta_1.' eta_2.']';

%% Linear and Angular Velocity Vector in body-fixed frame {B}
nu_1 = [1 1 1]';
nu_2 = [2 2 2]';
nu = [nu_1.' nu_2.']';

%% Forces and Moments acting on the vehicle in the body-fixed frame {B}
tau_1 = [1 1 1]';
tau_2 = [2 2 2]';
tau = [tau_1.' tau_2.']';




%% 1 DOF in Simulink
ts_dt = inf;

for x=1:(length(position.Time)-1)
    if (position.Time(x+1) - position.Time(x)) < ts_dt
        ts_dt = (position.Time(x+1) - position.Time(x));
    end
end
if ts_dt < 0.0001
    ts_dt = 0.0001;
end



position_resampled = resample(position, position.Time(1):ts_dt:position.Time(length(position.Time)));
% Find the output amplitude
x_m = mean([max(position_resampled) abs(min(position_resampled))]);

%Find the time step size - NOTE it is necessary to manually uniform the
%time vector!!!
dt = position_resampled.Time(2)-position_resampled.Time(1);

clear response;

%Plot the FFT
[response.amplitude, response.frequency] = MyFFT(position_resampled.Data, 1/dt, 10, 2);

%Find the main frequency
[a,ampl_max] = max(response.amplitude) ;
omega = 2*pi*response.frequency(ampl_max);


%% Nonlinear Element (relay with Hysterisis) as taken from "Distance Keeping for Underwater Vehicles...Nikola"
C = 17.09E-2;
x_a = 22.5; %the width of the relay as specified in the hardware/software


P = ((4*C)/(pi*x_m)) * sqrt(1-((x_a/x_m)^2));
Q = -((4*C)/(pi*x_m^2))*x_a;
%G_N(x_m) = P(x_m)+(1i*Q(x_m));

%% Coefficients

alpha = P/(omega^2)
%beta_r = -((Q)/(x_m*(omega^2)))
beta_rr = -((3*pi)/(8))*((Q)/(x_m*(omega^2)))


