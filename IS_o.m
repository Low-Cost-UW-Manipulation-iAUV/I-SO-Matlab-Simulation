%%IS-O Understanding Matlab Script
%   Author: Raphael Nagel
%   Date created: 14/Mar/2014
close all 
clear all
clc


%% Relay Parameters
x_a = 22.5;% Hysterisis width
C = 17.09E-2;% Relay Output Amplitude

%% Model Parameters

%Thruster Limitations
force_torque_limit_top = 28.4;
force_torque_limit_bottom = -1* force_torque_limit_top;

%Inertia coefficient
alpha = 5.59E-4;

%Drag coefficients
beta_r= 0;
beta_rr= 18.93E-6;


%% Run the Simulink simulation - 1DOF

SimOut = sim('IS_O');


%% Identify the Model parameters
[ident_alpha, ident_beta_r, ident_beta_rr, omega]=ISO_Identification(SO_position, C, x_a);
alpha
ident_alpha 
beta_r
ident_beta_r
beta_rr
ident_beta_rr


