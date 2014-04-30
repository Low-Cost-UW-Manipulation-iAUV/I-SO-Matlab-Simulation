function [ tf_achieved_charac_func_match ] = ISO_CreateReferenceModelFunction( overshoot, settling_time )
%ISO_CREATEREFERENCEMODELFUNCTION Generate a Refernce Model Function
%   1st. gen a 2nd order response tf from overshot and settling time
%   2nd. transform it into a 3rd order using a real pole far away
%   3rd  format it to match the CLTF (manual labor...)

%%Model function
%   Author: Raphael Nagel
%   Date created: 07/Apr/2014

figure(1)
hold all

%% 1st. Gen a desired 2nd order behaviour tf
zeta = sqrt( (log(overshoot)^2) / ((pi^2)+(log(overshoot)^2)) );    %damping ratio
omega_n = 3 / (settling_time * zeta);                               %natural frequency

tf_wanted = tf(omega_n^2, [1 (2*zeta*omega_n) (omega_n^2)])              %Standard 2nd order tf
step(tf_wanted);


%% 2nd: Transform 2nd order tf into 3r order tf
p = pole(tf_wanted);                                %Find poles of 2nd order tf
far_pole = real(p(1)) * -15;                        %Find a real pole position 15 times further left

tf2 = tf([1], [1 far_pole]);                        %gen a 1st order tf with poles far away

tf3 = (tf2.den{1}(2)) *tf_wanted*tf2;              %Scale the overall TF to get a unit response


%% 3rd format to match CLTF

% The CLTF has K_I as the sole s^0 coefficient. This means we can find all PID coeffs
% without incorporating the s^3 coefficient alpha... We can change this by
% dividing everything by the s^0 coeff.:
tf_achieved_charac_func_match = tf3;
tf_achieved_charac_func_match.num{1} = tf3.num{1} / tf3.den{1}(4);
tf_achieved_charac_func_match.den{1} = tf3.den{1} / tf3.den{1}(4);
tf_achieved_charac_func_match

%% Technically we need a zero to exactly match the CLTF.
%However, since we are only comparing parts of the denominator to find the
%controller coeffs it doesn't affect anything...

tf4 = tf([(tf_achieved_charac_func_match.den{1}(3)/tf_achieved_charac_func_match.num{1}(4)) 1], [1]);
tf_achieved_full_match = tf_achieved_charac_func_match*tf4
step(tf_achieved_charac_func_match);
step(tf_achieved_full_match)

legend show



end

