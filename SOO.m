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
%                                                                               %
%______________________________________________________________________________________________%


% SOO Optimizer
function [b1_best, b1] = SOO(Oscillator_no, m_iter, lb, ub, dim, f_obj)
   
 % Initialize variables
    b1 = zeros(1, dim);
    b1_best = inf;
    b2 = zeros(1, dim);
    b2_best = inf;
    L_new = initialization(Oscillator_no, dim, ub, lb);
    t = 0;


    % Main loop
    while t < m_iter
        for i = 1:size(L_new, 1)
            % Update the location with respect to bounds
            F_ub = L_new(i, :) > ub;
            F_lb = L_new(i, :) < lb;
            L_new(i, :) = (L_new(i, :) .* (~(F_ub + F_lb))) + ub .* F_ub + lb .* F_lb;

            % Calculate fitness
            fit = f_obj(L_new(i, :));

            % Update b1 and b1_best if the current solution is better
            if fit < b1_best
                b1_best = fit;
                b1 = L_new(i, :);
            end

            % Update b2 and b2_best if the current solution is the second best
            if fit > b1_best && fit < b2_best
                b2_best = fit;
                b2 = L_new(i, :);
            end
        end

        
        % Update the scaling factor
        a = 2 - t * ((2) / m_iter);

        % Update the location of the Oscillators
        for i = 1:size(L_new, 1)
            for j = 1:size(L_new, 2)
                r1 = rand();
                r2 = rand();
                r3 = rand();

                % Calculate new locations O1 and O2
                O1 = b1(j) - (2 * a * r1 - a) * (L_new(i, j) - abs(r1 * sin(r2) * abs(r3 * b1(j))));
                O2 = b2(j) - (2 * a * r1 - a) * (L_new(i, j) - abs(r1 * cos(r2) * abs(r3 * b1(j))));

                % Update the position
                L_new(i, j) = (O1 + O2) / 2;
            end
        end

        % Update iteration count
        t = t + 1;
    end
end
