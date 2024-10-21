import numpy as np

def F11(x):
    dim = len(x)
    return (np.sum(x**2) / 4000 - np.prod(np.cos(x / np.sqrt(np.arange(1, dim + 1)))) + 1)

def initialization(Oscillator_no, dim, ub, lb):
    if np.isscalar(lb) and np.isscalar(ub):
        L_new = np.random.uniform(low=lb, high=ub, size=(Oscillator_no, dim))
    else:
        L_new = np.zeros((Oscillator_no, dim))
        for i in range(dim):
            lb_i = lb[i]
            ub_i = ub[i]
            L_new[:, i] = np.random.uniform(low=lb_i, high=ub_i, size=Oscillator_no)
    return L_new

def SOO(StarOsc_no, m_iter, lb, ub, dim, f_obj):
    best_phase_position = np.zeros(dim)  # Best position in the star's oscillation phase
    best_luminosity = np.inf  # Best fitness value (luminosity)
    star_positions = initialization(StarOsc_no, dim, ub, lb)  # Initialize the positions of the star oscillators
    initial_period = 3.0  # Initial period of oscillation
    lightcurve_iter = 1
    luminosity_curve = np.zeros(m_iter)  # Luminosity tracking for each iteration
    top_star_positions = np.zeros((3, dim))  # Top 3 best star positions
    top_luminosities = np.full(3, np.inf)  # Top 3 best fitness values (luminosities)
    current_luminosities = np.zeros(StarOsc_no)  # Fitness values of the star oscillators
    updated_star_positions = star_positions.copy()  # Initialize updated star positions

    # Initial evaluation of fitness (luminosity) for each star
    for i in range(StarOsc_no):
        current_luminosities[i] = f_obj(star_positions[i, :])
        combined_luminosities = np.append(top_luminosities, current_luminosities[i])
        combined_star_positions = np.vstack((top_star_positions, star_positions[i, :]))
        sorted_indices = np.argsort(combined_luminosities)
        top_luminosities = combined_luminosities[sorted_indices[:3]]
        top_star_positions = combined_star_positions[sorted_indices[:3], :]

    # Main loop
    while lightcurve_iter <= m_iter:
        for i in range(updated_star_positions.shape[0]):
            current_period = initial_period + 0.001 * lightcurve_iter  # Update period over time
            current_angular_freq = 2 * np.pi / current_period  # Update angular frequency over time

            # Bound checks for star position
            F_ub = updated_star_positions[i, :] > ub
            F_lb = updated_star_positions[i, :] < lb
            updated_star_positions[i, :] = np.where(~(F_ub | F_lb), updated_star_positions[i, :], ub * F_ub + lb * F_lb)
            current_luminosity = f_obj(updated_star_positions[i, :])  # Evaluate new luminosity based on updated position

            if current_luminosity < best_luminosity:
                best_luminosity = current_luminosity
                best_phase_position = updated_star_positions[i, :]  # Update best position in the oscillation phase

        # Update the scaling factor for the oscillation
        scaling_factor = 2 - lightcurve_iter * (2 / m_iter)

        # Update the location of the star oscillators
        for i in range(updated_star_positions.shape[0]):
            for j in range(updated_star_positions.shape[1]):
                rand_factor1 = np.random.rand()
                rand_factor2 = np.random.rand()
                rand_factor3 = np.random.rand()

                osc_position1 = best_phase_position[j] - (rand_factor1 * rand_factor3) * (
                    (current_angular_freq * scaling_factor * rand_factor1 - scaling_factor) *
                    (updated_star_positions[i, j] - abs(rand_factor1 * np.sin(rand_factor2) * abs(rand_factor3 * best_phase_position[j]))))
                osc_position2 = best_phase_position[j] - (rand_factor2 * rand_factor3) * (
                    (current_angular_freq * scaling_factor * rand_factor1 - scaling_factor) *
                    (updated_star_positions[i, j] - abs(rand_factor1 * np.cos(rand_factor2) * abs(rand_factor3 * best_phase_position[j]))))
                updated_star_positions[i, j] = rand_factor3 * (osc_position1 + osc_position2 / 2)  # Update position based on averaged oscillation

        # Perform the update for oscillatory movement
        for i in range(StarOsc_no):
            avg_best_star_position = np.mean(top_star_positions, axis=0)  # Average of top star positions
            random_indices = np.random.choice(StarOsc_no, 3, replace=False)
            while i in random_indices:
                random_indices = np.random.choice(StarOsc_no, 3, replace=False)

            # Generate new position based on oscillatory movement influenced by sine and cosine
            rand_factor = np.random.rand()
            oscillation_position = avg_best_star_position + 0.5 * (
                np.sin(rand_factor * np.pi) * (star_positions[random_indices[0], :] - star_positions[random_indices[1], :]) +
                np.cos((1 - rand_factor) * np.pi) * (star_positions[random_indices[0], :] - star_positions[random_indices[2], :]))

            star_update_position = star_positions[i, :].copy()  # Initialize star update position

            # Update the star's position based on oscillation_position
            for j in range(dim):
                if np.random.rand() <= 0.5:
                    star_update_position[j] = oscillation_position[j]

            # Ensure the updated position remains within bounds
            if np.isscalar(ub):
                star_update_position = np.clip(star_update_position, lb, ub)
            else:
                for j in range(dim):
                    star_update_position[j] = np.clip(star_update_position[j], lb[j], ub[j])

            # Update position if the new luminosity improves
            new_luminosity = f_obj(star_update_position)
            if new_luminosity < current_luminosities[i]:
                star_positions[i, :] = star_update_position
                current_luminosities[i] = new_luminosity

                # Update top star positions and luminosity values
                combined_luminosities = np.append(top_luminosities, new_luminosity)
                combined_star_positions = np.vstack((top_star_positions, star_update_position))
                sorted_indices = np.argsort(combined_luminosities)
                top_luminosities = combined_luminosities[sorted_indices[:3]]
                top_star_positions = combined_star_positions[sorted_indices[:3], :]

        # Determine the best solution
        best_primary_luminosity = best_luminosity
        best_secondary_luminosity = np.min(top_luminosities)
        if best_primary_luminosity < best_secondary_luminosity:
            best_luminosity = best_primary_luminosity
        else:
            best_luminosity = best_secondary_luminosity
            best_phase_position = top_star_positions[0, :]

        luminosity_curve[lightcurve_iter - 1] = best_luminosity  # Update luminosity curve based on best solution

        lightcurve_iter += 1

    return best_luminosity, best_phase_position, luminosity_curve

# SOO parameters
f_obj = F11
lb = -600
ub = 600
dim = 30
StarOsc_no = 50 
m_iter = 500 
# Run SOO
best_value, best_solution, luminosity_curve = SOO(StarOsc_no, m_iter, lb, ub, dim, f_obj)
print("Best value:", best_value)
