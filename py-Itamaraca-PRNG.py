import numpy as np
import matplotlib.pyplot as plt

# -------------------------------------------------------------------------
# Itamaracá (Ita) PRNG - Python Implementation
# Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" (Pereira, D. H.)
# -------------------------------------------------------------------------

def itamaraca_core(n_to_generate, max_value, seeds, lmbda=1.97):
    """
    Generates a sequence of pseudo-random numbers based on the Ita model.
    Formula: FRNS = ABS[N - (ABS(S2 - S0) * λ)]
    """
    # Validation
    if len(seeds) != 3:
        raise ValueError("Error: The number of seeds must be 3.")
    if max_value <= 0:
        raise ValueError("Error: The maximum value must be positive.")
    
    # Initialization
    random_series = np.zeros(n_to_generate)
    s = list(seeds)
    
    for i in range(n_to_generate):
        # Step 1: Pn Process (ABS difference between seeds)
        pn = abs(s[2] - s[0])
        
        # Step 2: Final Calculation
        generated_number = abs(max_value - (pn * lmbda))
        
        random_series[i] = generated_number
        
        # Step 3: Seed Update (Moving sequence logic)
        s[0], s[1], s[2] = s[1], s[2], generated_number
        
    return random_series

# --- Execution Parameters ---
TOTAL_SAMPLES = 10000
MAX_VALUE = 10000
INITIAL_SEEDS = [800, 25, 3005]  # Using your exact requested seeds
LAMBDA_VAL = 1.97

# Generate 10,000 numbers
data = itamaraca_core(TOTAL_SAMPLES, MAX_VALUE, INITIAL_SEEDS, LAMBDA_VAL)

# -------------------------------------------------------------------------
# Visual Analysis
# -------------------------------------------------------------------------
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 10))

# 1. Uniformity Analysis (Bar Chart / Histogram)
# Verifies if the distribution is uniform within the range [0, N] 
ax1.hist(data, bins=40, color='#1f77b4', edgecolor='white', alpha=0.8)
ax1.set_title(f"Uniformity Analysis: Itamaracá Model (N={TOTAL_SAMPLES})", fontsize=14, fontweight='bold')
ax1.set_xlabel("Generated Numerical Range")
ax1.set_ylabel("Frequency")
ax1.grid(axis='y', linestyle='--', alpha=0.7)

# 2. Sequence Dynamics (Line Graph)
# Visualizing the stochastic "up and down" movement (First 250 samples) [cite: 57]
ax2.plot(data[:250], color='#d62728', linewidth=1, label="Oscillation Path")
ax2.set_title("Sequence Dynamics (Stochastic Run - First 250 Samples)", fontsize=14, fontweight='bold')
ax2.set_xlabel("Iteration Index")
ax2.set_ylabel("Generated Value")
ax2.legend(loc='upper right')
ax2.grid(linestyle='--', alpha=0.6)

plt.tight_layout()
plt.show()

# Output basic results
print(f"--- Itamaracá PRNG Results ---")
print(f"Mean: {np.mean(data):.2f}")
print(f"Standard Deviation: {np.std(data):.2f}")
