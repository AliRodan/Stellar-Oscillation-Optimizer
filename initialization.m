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


function star_positions = initialization(StarOsc_no, dim, ub, lb)

b_no = size(ub, 2); % number of boundaries

if b_no == 1
    star_positions = rand(StarOsc_no, dim) .* (ub - lb) + lb;
end

% If each variable has a different lb and ub
if b_no > 1
    for i = 1:dim
        ub_i = ub(i);
        lb_i = lb(i);
        star_positions(:, i) = rand(StarOsc_no, 1) .* (ub_i - lb_i) + lb_i;
    end
end
