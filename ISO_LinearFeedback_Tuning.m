function [ K_p, K_i, K_d ] = ISO_LinearFeedback_Tuning( tf_model, alpha, beta )
%ISO_LINEARFEEDBACK_TUNING Generate PID controller values from alpha, beta
%and the reference model function

%It relies on comparison of coefficients
a = tf_model.den{1}; % the coefficients of the reference model function denominator

%These are referenced in reverse order compared to the IS-O papers.
K_i = alpha           /   a(1)
K_d = ( ( a(2) * alpha ) / (a(1)) ) - beta
K_p = -( a(3) * alpha ) / a(1)

end

