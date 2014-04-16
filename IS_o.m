%%IS-O Understanding Matlab Script
%   Author: Raphael Nagel
%   Date created: 14/Mar/2014
close all
clear all
clc


%% Relay Parameters
x_a = 22.5;% Hysterisis width
C = 17.09E-4;% Relay Output Amplitude

%% Model Parameters

%Thruster Limitations
force_torque_limit_top = 28.4;
force_torque_limit_bottom = -1* force_torque_limit_top;

%Inertia coefficient
alpha = 4.26E-4;

%Drag coefficients
beta_r= 6.75E-4;
beta_rr= 0;


%% Run the Simulink simulation - 1DOF

SimOut = sim('IS_O');


%% Identify the Model parameters
% Ensure that the maximum torque/force limit is accounted for in the
% calculations.
if C > force_torque_limit_top 
    C = force_torque_limit_top;
end

[ident_alpha, ident_beta_r, ident_beta_rr, omega]=ISO_Identification(SO_position, C, x_a);


%% Output Model Parameters
alpha
ident_alpha
beta_r
ident_beta_r
beta_rr
ident_beta_rr

%% Calculate the Linear Feedback Controller parameters

%this TF is specific to a CLTF defined on paper / in the connected Simulink Model:
% 07/Apr/2014 page...
tf_model = ISO_CreateReferenceModelFunction(0.1, 0.5);

%this function is ATM specific to the above TF
[k_p, k_i, k_d] = ISO_LinearFeedback_Tuning(tf_model, alpha, beta_r); 

%% Test this PID controller

%Turn the controller on
controller_step_onoff = 1;

%When should the controller start? [s]
step_time = 2;

% Do we want input force disturbances? These are a square waveform with:
disturb_ampl = 0; %Also the  on off switch

disturb_freq = 10;


SimOut = sim('controlled_PID_from_ISO');




