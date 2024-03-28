%______________________________________________________________________________________________%
%  Stellar Oscillation Optimizer (SOO) source codes (version 1.0)                              %
%                                                                                              %
%  Developed in MATLAB R2018a (7.13)                                                           %
%  Author and programmer: Ali Rodan                                                            %
%                         e-Mail: alirodan@gmail.com                                           %
%                         Homepages:                                                           %
%                         1- https://scholar.google.co.uk/citations?user=n8Z3RMwAAAAJ&hl=en    %
%                         2- https://www.researchgate.net/profile/Ali-Rodan                    %
%                                                                                              %
%   Paper Title:Stellar Oscillation Optimizer: A novel meta-heuristic optimization algorithm   %
%                   A. Rodan, A. Al-Tamimi, L. Alnemer (2024).                                 %
%          Stellar Oscillation Optimizer: A novel meta-heuristic optimization algorithm.       %
%                                                                                 %
%______________________________________________________________________________________________%

clear all 
clc

Oscillator_no=30;
f_name='F1';
m_iter=1000; 


[lb,ub,dim,f_obj]=Get_F(f_name);

[b1_best,b1_L]=SOO(Oscillator_no,m_iter,lb,ub,dim,f_obj);

display(['The best optimal value of the objective funciton found by SOO is : ', num2str(b1_best)]);

        



