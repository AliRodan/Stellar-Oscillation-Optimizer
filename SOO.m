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


% SOO Optimizer
function [best_luminosity, best_phase_position, luminosity_curve] = SOO(StarOsc_no, m_iter, lb, ub, dim, fobj)  
    % SOO initialization 
    best_phase_position = zeros(1, dim);  % Best position in the star's oscillation phase
    best_luminosity = inf;  % Best fitness value (luminosity)
    star_positions = initialization(StarOsc_no, dim, ub, lb);  % Initialize the positions of the star oscillators
    initial_period = 3.0;  % Initial period of oscillation
    lightcurve_iter = 1;  
    luminosity_curve = zeros(1, m_iter);  % Luminosity tracking for each iteration
    top_star_positions = zeros(3, dim);  % Top 3 best star positions
    top_luminosities = inf(1, 3);  % Top 3 best fitness values (luminosities)
    current_luminosities = zeros(1, StarOsc_no);  % Fitness values of the star oscillators
    updated_star_positions = star_positions;  % Initialize updated star positions

    % Initial evaluation of fitness (luminosity) for each star
    for i = 1:StarOsc_no
        current_luminosities(i) = fobj(star_positions(i, :));
        combined_luminosities = [top_luminosities, current_luminosities(i)];
        combined_star_positions = [top_star_positions; star_positions(i, :)];
        [sorted_luminosities, idx] = sort(combined_luminosities);
        sorted_star_positions = combined_star_positions(idx, :);
        top_luminosities = sorted_luminosities(1:3);
        top_star_positions = sorted_star_positions(1:3, :);
    end

    % Main loop 
    while lightcurve_iter <= m_iter 
    
        for i = 1:size(updated_star_positions, 1)
            current_period = initial_period + 0.001 * lightcurve_iter;  % Update period over time
            current_angular_freq = 2 * pi / current_period;  % Update angular frequency over time

            % Bound checks for star position 
            F_ub = updated_star_positions(i, :) > ub;
            F_lb = updated_star_positions(i, :) < lb;
            updated_star_positions(i, :) = (updated_star_positions(i, :) .* (~(F_ub + F_lb))) + ub .* F_ub + lb .* F_lb;
            current_luminosity = fobj(updated_star_positions(i, :));  % Evaluate new luminosity based on updated position

            if current_luminosity < best_luminosity
                best_luminosity = current_luminosity;
                best_phase_position = updated_star_positions(i, :);  % Update best position in the oscillation phase
            end
        end

        % Update the scaling factor for the oscillation
        scaling_factor = 2 - lightcurve_iter * ((2) / m_iter);

        % Update the location of the star oscillators 
        for i = 1:size(updated_star_positions, 1)
            for j = 1:size(updated_star_positions, 2)
                rand_factor1 = rand();
                rand_factor2 = rand();
                rand_factor3 = rand();
               osc_position1 = best_phase_position(j) - (rand_factor1*rand_factor3)* ((current_angular_freq * scaling_factor * rand_factor1 - scaling_factor) * ...
                    (updated_star_positions(i, j) - abs(rand_factor1 * sin(rand_factor2) * abs(rand_factor3  * best_phase_position(j)))));
                osc_position2 = best_phase_position(j) -  (rand_factor2*rand_factor3)* ((current_angular_freq * scaling_factor * rand_factor1 - scaling_factor) * ...
                    (updated_star_positions(i, j) - abs(rand_factor1 * cos(rand_factor2) * abs(rand_factor3  * best_phase_position(j)))));
                updated_star_positions(i, j) =rand_factor3*(osc_position1 + osc_position2/ 2);  % Update position based on averaged oscillation  % Update position based on averaged oscillation
            end
        end

        % Perform the update for oscillatory movement
        for i = 1:StarOsc_no
            avg_best_star_position = mean(top_star_positions, 1);  % Average of top star positions
            random_indices = randperm(StarOsc_no, 3);
            while any(random_indices == i)
                random_indices = randperm(StarOsc_no, 3);
            end

            % Generate new position based on oscillatory movement influenced by sine and cosine
            rand_factor = rand();
            oscillation_position = avg_best_star_position + 0.5 * (sin(rand_factor * pi) * (star_positions(random_indices(1), :) - star_positions(random_indices(2), :)) + ...
                cos((1 - rand_factor) * pi) * (star_positions(random_indices(1), :) - star_positions(random_indices(3), :)));
    
            star_update_position = star_positions(i, :);  % Initialize star update position
    
            % update the star's position based on oscillation_position
            for j = 1:dim
                if rand() <= 0.5
                    star_update_position(j) = oscillation_position(j); 
                end
            end
    
            % Ensure the updated position remains within bounds
            for j = 1:dim
                if isscalar(ub)
                    star_update_position(j) = min(max(star_update_position(j), lb), ub);
                else
                    star_update_position(j) = min(max(star_update_position(j), lb(j)), ub(j));
                end
            end

            % Update position if the new luminosity improves
            new_luminosity = fobj(star_update_position);
            if new_luminosity < current_luminosities(i)
                star_positions(i, :) = star_update_position;
                current_luminosities(i) = new_luminosity;

                % Update top star positions and luminosity values
                combined_luminosities = [top_luminosities, new_luminosity];
                combined_star_positions = [top_star_positions; star_update_position];
                [sorted_luminosities, idx] = sort(combined_luminosities);
                sorted_star_positions = combined_star_positions(idx, :);
                top_luminosities = sorted_luminosities(1:3);
                top_star_positions = sorted_star_positions(1:3, :);
            end
        end

        % Determine the best solution 
        best_primary_luminosity = best_luminosity;
        best_secondary_luminosity = min(top_luminosities);
        if best_primary_luminosity < best_secondary_luminosity
            best_luminosity = best_primary_luminosity;
        else
            best_luminosity = best_secondary_luminosity;
            best_phase_position = top_star_positions(1, :);
        end

        luminosity_curve(lightcurve_iter) = best_luminosity;  % Update luminosity curve based on best solution

        lightcurve_iter = lightcurve_iter + 1;
    end
end
