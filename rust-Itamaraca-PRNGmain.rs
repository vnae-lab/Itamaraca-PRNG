use std::error::Error;
use std::fs::File;
use std::io::Write;

/// ITAMARACÁ (ITA) PRNG - Rust Implementation
/// Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
struct ItamaracaPRNG {
    seeds: [f64; 3],
    max_value: f64,
    lambda: f64,
}

impl ItamaracaPRNG {
    /// Initializes the generator with 3 seeds and the lambda constant
    fn new(max_value: f64, initial_seeds: [f64; 3], lambda: f64) -> Self {
        Self {
            seeds: initial_seeds,
            max_value,
            lambda,
        }
    }

    /// Generates the next value and updates internal seeds (Moving Sequence)
    fn next(&mut self) -> f64 {
        // Step 1: Intermediate State (Pn)
        // Pn = ABS(S2 - S0)
        let pn = (self.seeds[2] - self.seeds[0]).abs();

        // Step 2: Final Calculation (FRNS)
        // FRNS = ABS[N - (Pn * lambda)]
        let generated_number = (self.max_value - (pn * self.lambda)).abs();

        // Step 3: Seed Update (Shift logic)
        self.seeds[0] = self.seeds[1];
        self.seeds[1] = self.seeds[2];
        self.seeds[2] = generated_number;

        generated_number
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    // Configuration
    let total_samples = 10000;
    let max_range = 10000.0;
    let initial_seeds = [800.0, 25.0, 3005.0];
    let lambda_val = 1.97;

    let mut ita = ItamaracaPRNG::new(max_range, initial_seeds, lambda_val);

    println!("--- Itamaraca PRNG Rust Simulation ---");
    println!("Generating {} numbers...", total_samples);

    // Create CSV file for analysis
    let mut file = File::create("itamaraca_results.csv")?;
    writeln!(file, "Index,Value")?;

    for i in 0..total_samples {
        let val = ita.next();
        
        // Write to CSV for Bar/Line chart analysis
        writeln!(file, "{},{:.4}", i, val)?;

        // Preview first 5
        if i < 5 {
            println!("Sample {}: {:.4}", i + 1, val);
        }
    }

    println!("--------------------------------------");
    println!("Success! Data exported to 'itamaraca_results.csv'.");
    println!("Use this file to analyze Uniformity (Bars) and Dynamics (Lines).");

    Ok(())
}
