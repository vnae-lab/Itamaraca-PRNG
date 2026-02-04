#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/**
 * ITAMARACÁ (ITA) PRNG - C Implementation
 * Based on the paper: "A Novel Simple Way to Generate Pseudo Random Numbers"
 * * Formula: FRNS = ABS[N - (ABS(S2 - S0) * lambda)]
 */

typedef struct {
    double seeds[3];
    double max_value;
    double lambda;
} ItamaracaPRNG;

/**
 * Initializes the PRNG with a range, initial seeds, and the lambda constant.
 */
void init_ita(ItamaracaPRNG *ita, double max_val, double initial_seeds[3], double l) {
    ita->max_value = max_val;
    ita->lambda = l;
    for(int i = 0; i < 3; i++) {
        ita->seeds[i] = initial_seeds[i];
    }
}

/**
 * Generates the next value in the sequence and updates the internal state.
 * This simulates the "Stone Shaker" (Ita) stochastic movement.
 */
double next_ita(ItamaracaPRNG *ita) {
    // Step 1: Intermediate State (Pn)
    // Pn is the absolute difference between the first and third seeds.
    double pn = fabs(ita->seeds[2] - ita->seeds[0]);

    // Step 2: Final Calculation (FRNS)
    // The result is the absolute difference between the limit N and (Pn * lambda).
    double generated_number = fabs(ita->max_value - (pn * ita->lambda));

    // Step 3: Moving Sequence Update
    // Seeds are shifted to ensure a non-periodic, "infinite" flow.
    ita->seeds[0] = ita->seeds[1];
    ita->seeds[1] = ita->seeds[2];
    ita->seeds[2] = generated_number;

    return generated_number;
}

int main() {
    // Configuration for 10,000 samples
    const int total_samples = 10000;
    double max_range = 10000.0;
    double initial_seeds[3] = {800.0, 25.0, 3005.0};
    double lambda_val = 1.97; // Recommended value close to 2.0

    ItamaracaPRNG ita;
    init_ita(&ita, max_range, initial_seeds, lambda_val);

    printf("--- Itamaraca PRNG C Simulation ---\n");
    printf("Generating %d numbers for statistical analysis...\n", total_samples);

    // Opening CSV file for external plotting (Bar and Line charts)
    FILE *fp = fopen("itamaraca_results.csv", "w");
    if (fp == NULL) {
        printf("Error opening file for writing!\n");
        return 1;
    }

    // Write CSV Header
    fprintf(fp, "Index,Value\n");

    for (int i = 0; i < total_samples; i++) {
        double val = next_ita(&ita);
        
        // Export to CSV for Uniformity and Dynamics check
        fprintf(fp, "%d,%.4f\n", i, val);

        // Terminal preview for the first 5 samples
        if (i < 5) {
            printf("Sample %d: %.4f\n", i + 1, val);
        }
    }

    fclose(fp);

    printf("--------------------------------------\n");
    printf("Success! Data exported to 'itamaraca_results.csv'.\n");
    printf("Ready for Uniformity (Bars) and Sequence (Lines) visualization.\n");

    return 0;
}
