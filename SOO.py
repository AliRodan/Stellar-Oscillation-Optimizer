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

def SOO(Oscillator_no, m_iter, lb, ub, dim, f_obj):
    b1 = np.zeros(dim)
    b1_best = np.inf
    b2 = np.zeros(dim)
    b2_best = np.inf
    L_new = initialization(Oscillator_no, dim, ub, lb)
    t = 0

    while t < m_iter:
        for i in range(L_new.shape[0]):
            # Update the location with respect to bounds
            F_ub = L_new[i] > ub
            F_lb = L_new[i] < lb
            L_new[i] = np.where(~(F_ub | F_lb), L_new[i], ub * F_ub + lb * F_lb)

            # Calculate fitness
            fit = f_obj(L_new[i])

            # Update b1 and b1_best if the current solution is better
            if fit < b1_best:
                b1_best = fit
                b1 = L_new[i]

            # Update b2 and b2_best if the current solution is the second best
            if b1_best < fit < b2_best:
                b2_best = fit
                b2 = L_new[i]

        # Update the scaling factor
        a = 2 - t * (2 / m_iter)

        # Update the location of the Oscillators
        for i in range(L_new.shape[0]):
            for j in range(L_new.shape[1]):
                r1 = np.random.rand()
                r2 = np.random.rand()
                r3 = np.random.rand()

                # Calculate new locations O1 and O2
                O1 = b1[j] - (2 * a * r1 - a) * (L_new[i, j] - abs(r1 * np.sin(r2) * abs(r3 * b1[j])))
                O2 = b2[j] - (2 * a * r1 - a) * (L_new[i, j] - abs(r1 * np.cos(r2) * abs(r3 * b1[j])))

                # Update the position
                L_new[i, j] = (O1 + O2) / 2

        # Update iteration count
        t += 1

    return b1_best, b1

# SOO parameters
f_obj = F11
lb = -600
ub = 600
dim = 30
Oscillator_no = 30
m_iter = 1000

# Run SOO
best_value, best_solution = SOO(Oscillator_no, m_iter, lb, ub, dim, f_obj)
print("Best value:", best_value)
