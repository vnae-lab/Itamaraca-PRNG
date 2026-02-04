const fs = require('fs');

/**
 * ITAMARACÁ (ITA) PRNG - JavaScript Implementation
 * Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
 */
class ItamaracaPRNG {
    constructor(maxValue, initialSeeds, lambda = 1.97) {
        if (initialSeeds.length !== 3) {
            throw new Error("Error: Exactly 3 seeds are required.");
        }
        this.maxValue = maxValue;
        this.seeds = [...initialSeeds]; // Clone to avoid mutation
        this.lambda = lambda;
    }

    /**
     * Generates the next pseudo-random number and updates internal state
     */
    next() {
        // Step 1: Intermediate State (Pn)
        // Pn = ABS(S2 - S0)
        const pn = Math.abs(this.seeds[2] - this.seeds[0]);

        // Step 2: Final Calculation (FRNS)
        // FRNS = ABS[N - (Pn * lambda)]
        const generatedNumber = Math.abs(this.maxValue - (pn * this.lambda));

        // Step 3: Seed Update (Moving sequence logic)
        this.seeds[0] = this.seeds[1];
        this.seeds[1] = this.seeds[2];
        this.seeds[2] = generatedNumber;

        return generatedNumber;
    }
}

// --- Execution ---
const totalSamples = 10000;
const maxRange = 10000.0;
const initialSeeds = [800.0, 25.0, 3005.0];
const lambdaVal = 1.97;

const ita = new ItamaracaPRNG(maxRange, initialSeeds, lambdaVal);

console.log("--- Itamaraca PRNG JavaScript Simulation ---");
console.log(`Generating ${totalSamples} numbers...`);

let csvContent = "Index,Value\n";

for (let i = 0; i < totalSamples; i++) {
    const val = ita.next();
    
    // Add to CSV string (fixed to 4 decimal places)
    csvContent += `${i},${val.toFixed(4)}\n`;

    // Preview first 5
    if (i < 5) {
        console.log(`Sample ${i + 1}: ${val.toFixed(4)}`);
    }
}

// Save to CSV File using Node.js filesystem
fs.writeFileSync('itamaraca_results.csv', csvContent);

console.log("--------------------------------------");
console.log("Success! Data saved to 'itamaraca_results.csv'.");
console.log("Analyze Uniformity (Bars) and Dynamics (Lines) using the CSV.");
