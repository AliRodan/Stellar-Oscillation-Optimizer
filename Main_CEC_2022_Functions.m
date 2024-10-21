%______________________________________________________________________________________________%
%  Stellar Oscillation Optimizer (SOO) source codes (version 1.1)                              %
%                                                                                              %
%  Developed in MATLAB R2018a (7.13)                                                           %
%  Author and programmer: Ali Rodan                                                            %
%                         e-Mail: alirodan@gmail.com                                           %
%                         Homepages:                                                           %
%                         1- https://scholar.google.co.uk/citations?user=n8Z3RMwAAAAJ&hl=en    %
%                         2- https://www.researchgate.net/profile/Ali-Rodan                    %
%                                                                                              %
%   Paper Title:Stellar Oscillation Optimizer: A Nature-inspired metaheuristic optimization algorithm.   %
%                   A. Rodan, A. Al-Tamimi, L. Alnemer, S. Mirjalili (2024)                                  %
%          Stellar Oscillation Optimizer: A Nature-inspired metaheuristic optimization algorithm.       %
%                                                                                 %
%______________________________________________________________________________________________%
clear all 
clc

% Initialize parameters
StarOsc_no = 50;
m_iter = 500; 
lb = -100;             
ub = 100;              
dim = 10;

% Define IEEE CEC2022 Function (F1-F12)
Fun = 1;

display(['Optimizing: ', num2str(Fun)]);

% Objective function for IEEE CEC2022 Function
fobj = @(x) cec22_test_func(x', Fun);

% Run the SOO optimizer
[best_luminosity, best_phase_position, luminosity_curve] = SOO(StarOsc_no, m_iter, lb, ub, dim, fobj);

display(['The best optimal value of the objective function found by SOO is: ', num2str(best_luminosity)]);