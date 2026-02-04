% ITAMARACÁ (ITA) PRNG - MATLAB Implementation
% Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" (Pereira, D. H.)

clear; clc;

% --- Configuration ---
total_samples = 10000;
max_range = 10000.0;
seeds = [800.0, 25.0, 3005.0]; % [S0, S1, S2]
lambda = 1.97;

% Pre-allocate array for speed
results = zeros(total_samples, 1);

% --- Generation Loop ---
for i = 1:total_samples
    % Step 1: Intermediate State (Pn)
    pn = abs(seeds(3) - seeds(1)); % MATLAB index starts at 1
    
    % Step 2: Final Calculation (FRNS)
    generated_number = abs(max_range - (pn * lambda));
    
    % Store result
    results(i) = generated_number;
    
    % Step 3: Seed Update (Moving sequence logic)
    seeds(1) = seeds(2);
    seeds(2) = seeds(3);
    seeds(3) = generated_number;
end

% --- Visual Analysis ---

% 1. Line Chart (Stochastic Dynamics)
subplot(2,1,1);
plot(results(1:200)); % Showing first 200 for clarity
title('Sequence Dynamics (First 200 samples)');
xlabel('Iteration'); ylabel('Value');
grid on;

% 2. Histogram (Uniformity Check)
subplot(2,1,2);
histogram(results, 50); % 50 bins
title('Uniformity Distribution (10,000 samples)');
xlabel('Value Range'); ylabel('Frequency');

% Save data to CSV (optional)
csvwrite('itamaraca_results.csv', [(1:total_samples)', results]);
disp('Simulation complete. Graphs generated.');
