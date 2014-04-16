function [ ident_alpha, ident_beta_r, ident_beta_rr, omega ] = ISO_Identification( SO_position, C, x_a )
%ISO_IDENTIFICATION Summary of this function goes here
%   Detailed explanation goes here


%% Resample the timeseries to account for variable step size
ts_dt = inf;

%Find the smallest timestep
for x=1:(length(SO_position.Time)-1)
    if (SO_position.Time(x+1) - SO_position.Time(x)) < ts_dt
        ts_dt = (SO_position.Time(x+1) - SO_position.Time(x));
    end
end
% Limit the timestep so that we can still calculate with it.
if ts_dt < 0.000001
    ts_dt = 0.000001;
end


SO_position_resampled = resample(SO_position, SO_position.Time(1):ts_dt:SO_position.Time(length(SO_position.Time)));

% Find the output amplitude
x_m = mean([max(SO_position_resampled) abs(min(SO_position_resampled))]);

%Find the time step size - NOTE it is necessary to manually uniform the
%time vector!!!
dt = SO_position_resampled.Time(2)-SO_position_resampled.Time(1);

%Plot the FFT
[response.amplitude, response.frequency] = MyFFT(SO_position_resampled.Data, 1/dt, 10, 0);

%Find the main frequency
[a,ampl_max] = max(response.amplitude) ;
omega = 2*pi*response.frequency(ampl_max);


%% Calculate the model / hyderodynamic coefficients

%Define the Nonlinear Element (relay with Hysterisis) as taken from "Distance Keeping for Underwater Vehicles...Nikola"
P = ((4*C)/(pi*x_m)) * sqrt(1-((x_a/x_m)^2));
Q = -((4*C*x_a)/(pi*(x_m^2)));
%G_N(x_m) = P(x_m)+(1i*Q(x_m));

%% ModelCoefficients

ident_alpha = P/(omega^2); %Inertia coefficient
ident_beta_r = -((Q)/(omega)); %Constant drag
ident_beta_rr = -((3*pi*Q)/(8*x_m*(omega^2))); %Non-Linear Drag



end

