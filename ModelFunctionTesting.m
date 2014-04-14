%%Model function
%   Author: Raphael Nagel
%   Date created: 07/Apr/2014
close all 
clc
clear all


tf1 = tf([173.206], [1 13.16 173.206]);
tf2 = tf([1], [1 70]);
tf3a = 70*tf1*tf2;
tf2a = tf([(tf3a.den{1,1}(1,3)/tf3a.num{1,1}(1,4)) 1], [1]);
tf3 = tf3a*tf2a 
step(tf3)
figure(2)
hold all
step(tf1)


tf33 = tf([2.4743], [1 13.17 173.394 2.4743])