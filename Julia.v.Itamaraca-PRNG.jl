using Plots
using Distributions
using Statistics
using Measures

# -------------------------------------------------------------------------
# Itamaracá (Ita) PRNG - Julia Implementation
# Based on the paper: "A Novel Simple Way to Generate Pseudo Random Numbers"
# -------------------------------------------------------------------------

"""
itamaraca_core(n_to_generate, max_value, seeds, λ=1.97)

Generates a sequence of pseudo-random numbers based on the Itamaracá model.
- Pn Calculation: ABS(S2 - S0) 
- Final Calculation: ABS[N - (Pn * λ)] 
"""
function itamaraca_core(n_to_generate::Int, max_value::Real, seeds::Vector{<:Real}, λ::Float64=1.97)
    
    # Error Checking
    if length(seeds) != 3
        error("Error: The number of seeds must be 3.") [cite: 23]
    end
    if max_value <= 0
        error("Error: The maximum value N must be positive.") [cite: 22]
    end
    if λ <= 0
        error("Error: λ must be positive and typically close to 2.0 (e.g., 1.97).") [cite: 34]
    end

    # Pre-allocate results array for performance
    random_series = Vector{Float64}(undef, n_to_generate)
    s = copy(seeds)

    for i in 1:n_to_generate
        # Intermediate State (Pn Process) [cite: 29]
        # Pn = ABS(S2 - S0) 
        pn = abs(s[3] - s[1])
        
        # Final Calculation (General Formula) [cite: 33]
        # FRNS = ABS[N - (Pn * λ)] 
        generated_number = abs(max_value - (pn * λ))
        
        random_series[i] = generated_number

        # Seed Update (Moving sequence logic) [cite: 30]
        s[1] = s[2]
        s[2] = s[3]
        s[3] = generated_number
    end

    return random_series
end

# --- Execution Settings ---
TOTAL_SAMPLES = 10_000
MAX_RANGE     = 10_000.0
INITIAL_SEEDS = [8777.0, 11.0, 8.0] # Standard seeds from technical example [cite: 39]
LAMBDA_VAL    = 1.97                # Recommended scaling factor close to 2 [cite: 34]

# Generate numbers
data_series = itamaraca_core(TOTAL_SAMPLES, MAX_RANGE, INITIAL_SEEDS, LAMBDA_VAL)

# --- Visualization & Statistical Analytics ---

# 1. Uniformity Analysis (Histogram)
# Verifies the [0, 1] or [0, N] uniform distribution claim [cite: 14]
p1 = histogram(data_series, bins=40, color=:steelblue, edgecolor=:white, alpha=0.8,
               title="Uniformity Analysis: Itamaracá (Ita) Model",
               xlabel="Generated Numerical Range", ylabel="Frequency Density",
               label="Sample Distribution", legend=:topright)

# 2. Run Sequence Analysis (Line Graph)
# Visualizing the non-periodic "up and down" movement [cite: 14, 57]
p2 = plot(data_series[1:250], color=:crimson, linewidth=1.2,
          title="Sequence Oscillation (Stochastic Run)",
          subtitle="First 250 samples visualizing the 'Stone Shaker' effect",
          xlabel="Sequence Index (Iteration)", ylabel="Generated Value",
          label="Oscillation Path", legend=:topright)

# Combine plots using layout
final_plot = plot(p1, p2, layout=(2,1), size=(800, 700), margin=5mm)

display(final_plot)
