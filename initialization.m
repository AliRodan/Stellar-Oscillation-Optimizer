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


function L_new=initialization(Oscillator_no,dim,ub,lb)

b_no= size(ub,2); % numnber of boundaries


if b_no==1
    L_new=rand(Oscillator_no,dim).*(ub-lb)+lb;
end

% If each variable has a different lb and ub
if b_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        L_new(:,i)=rand(Oscillator_no,1).*(ub_i-lb_i)+lb_i;
    end
end