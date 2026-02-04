import * as fs from 'fs';

/**
 * ITAMARACÁ (ITA) PRNG - TypeScript Implementation
 * Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
 */
class ItamaracaPRNG {
    private seeds: number[];
    private maxValue: number;
    private lambda: number;

    constructor(maxValue: number, initialSeeds: number[], lambda: number = 1.97) {
        if (initialSeeds.length !== 3) {
            throw new Error("Error: Exactly 3 seeds are required.");
        }
        this.maxValue = maxValue;
        this.seeds = [...initialSeeds]; // Clone to prevent external mutation
        this.lambda = lambda;
    }

    /**
     * Generates the next pseudo-random number and updates internal state.
     * Logic: FRNS = ABS(N - (ABS(S2 - S0) * lambda))
     */
    public next(): number {
        // Step 1: Intermediate State (Pn)
        const pn = Math.abs(this.seeds[2] - this.seeds[0]);

        // Step 2: Final Calculation (FRNS)
        const generatedNumber = Math.abs(this.maxValue - (pn * this.lambda));

        // Step 3: Seed Update (Moving sequence logic)
        this.seeds[0] = this.seeds[1];
        this.seeds[1] = this.seeds[2];
        this.seeds[2] = generatedNumber;

        return generatedNumber;
    }
}

// --- Execution ---
const totalSamples: number = 10000;
const maxRange: number = 10000.0;
const initialSeeds: number[] = [800.0, 25.0, 3005.0];
const lambdaVal: number = 1.97;

const ita = new ItamaracaPRNG(maxRange, initialSeeds, lambdaVal);

console.log("--- Itamaraca PRNG TypeScript Simulation ---");
console.log(`Generating ${totalSamples} numbers...`);

let csvContent = "Index,Value\n";

for (let i = 0; i < totalSamples; i++) {
    const val = ita.next();
    
    // Add to CSV string
    csvContent += `${i},${val.toFixed(4)}\n`;

    // Preview first 5
    if (i < 5) {
        console.log(`Sample ${i + 1}: ${val.toFixed(4)}`);
    }
}

// Save to CSV File using Node.js fs
try {
    fs.writeFileSync('itamaraca_results.csv', csvContent);
    console.log("--------------------------------------");
    console.log("Success! Data saved to 'itamaraca_results.csv'.");
} catch (err) {
    console.error("Error writing file:", err);
}
