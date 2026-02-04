#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>
#include <fstream>

/**
 * ITAMARACÁ (ITA) PRNG - C++ Implementation
 * Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" (Pereira, D. H.)
 */

class ItamaracaPRNG {
private:
    double s0, s1, s2;
    double max_value;
    double lambda;

public:
    ItamaracaPRNG(double n, std::vector<double> initial_seeds, double l = 1.97) {
        if (initial_seeds.size() != 3) {
            throw std::invalid_argument("Error: 3 seeds required.");
        }
        max_value = n;
        s0 = initial_seeds[0];
        s1 = initial_seeds[1];
        s2 = initial_seeds[2];
        lambda = l;
    }

    double next() {
        // Step 1: Intermediate State (Pn)
        // Formula: Pn = ABS(S2 - S0)
        double pn = std::abs(s2 - s0);

        // Step 2: Final Calculation (FRNS)
        // Formula: FRNS = ABS[N - (Pn * lambda)]
        double generated_number = std::abs(max_value - (pn * lambda));

        // Step 3: Seed Update (Moving sequence logic)
        s0 = s1;
        s1 = s2;
        s2 = generated_number;

        return generated_number;
    }
};

int main() {
    // --- Configuration ---
    const int total_samples = 10000;
    double n_range = 10000.0;
    std::vector<double> seeds = {800.0, 25.0, 3005.0}; // Exact same seeds
    double lambda_val = 1.97;

    try {
        ItamaracaPRNG ita(n_range, seeds, lambda_val);
        
        // Output file for visualization analysis (CSV)
        std::ofstream outFile("itamaraca_results.csv");
        outFile << "Index,Value\n";

        std::cout << "--- Itamaraca PRNG C++ Simulation ---" << std::endl;
        std::cout << "Generating " << total_samples << " numbers..." << std::endl;

        for (int i = 0; i < total_samples; ++i) {
            double val = ita.next();
            
            // Save to file for Bar Chart (Uniformity) and Line Chart (Dynamics)
            outFile << i << "," << val << "\n";

            // Print first 10 for console preview
            if (i < 10) {
                std::cout << "Sample " << i + 1 << ": " << std::fixed << std::setprecision(4) << val << std::endl;
            }
        }

        outFile.close();
        std::cout << "--------------------------------------" << std::endl;
        std::cout << "Success! Data saved to 'itamaraca_results.csv'." << std::endl;
        std::cout << "Use this file to plot your Bar and Line charts." << std::endl;

    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }

    return 0;
}
