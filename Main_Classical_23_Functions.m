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
% Define your parameters and objective function
StarOsc_no=50;
f_name='F1';
m_iter=500; 

%The Classical 23 Benchmark Functions

% Call the objective function with the defined parameters
[lb,ub,dim,fobj]=Get_F(f_name);


% Call the optimizer
[best_luminosity, best_phase_position, luminosity_curve] = SOO(StarOsc_no, m_iter, lb, ub, dim, fobj);

display(['The best optimal value of the objective funciton found by SOO is : ', num2str(best_luminosity)]);



        



