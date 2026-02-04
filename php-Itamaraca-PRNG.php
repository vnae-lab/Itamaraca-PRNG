<?php
/**
 * ITAMARACÁ (ITA) PRNG - PHP Implementation
 * Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
 */

class ItamaracaPRNG {
    private array $seeds;
    private float $maxValue;
    private float $lambda;

    public function __construct(float $maxValue, array $initialSeeds, float $lambda = 1.97) {
        if (count($initialSeeds) !== 3) {
            throw new Exception("Error: Exactly 3 seeds are required.");
        }
        $this->maxValue = $maxValue;
        $this->seeds = array_values($initialSeeds);
        $this->lambda = $lambda;
    }

    /**
     * Generates the next pseudo-random number and updates internal state.
     */
    public function next(): float {
        // Step 1: Intermediate State (Pn)
        // Pn = ABS(S2 - S0)
        $pn = abs($this->seeds[2] - $this->seeds[0]);

        // Step 2: Final Calculation (FRNS)
        // FRNS = ABS[N - (Pn * lambda)]
        $generatedNumber = abs($this->maxValue - ($pn * $this->lambda));

        // Step 3: Seed Update (Moving sequence logic)
        $this->seeds[0] = $this->seeds[1];
        $this->seeds[1] = $this->seeds[2];
        $this->seeds[2] = $generatedNumber;

        return $generatedNumber;
    }
}

// --- Configuration ---
$totalSamples = 10000;
$maxRange = 10000.0;
$initialSeeds = [800.0, 25.0, 3005.0];
$lambdaVal = 1.97;

try {
    $ita = new ItamaracaPRNG($maxRange, $initialSeeds, $lambdaVal);

    echo "--- Itamaraca PRNG PHP Simulation ---\n";
    echo "Generating $totalSamples numbers...\n";

    // Open file for CSV export
    $file = fopen('itamaraca_results.csv', 'w');
    fputcsv($file, ['Index', 'Value']);

    for ($i = 0; $i < $totalSamples; $i++) {
        $val = $ita->next();
        
        // Write to CSV
        fputcsv($file, [$i, number_format($val, 4, '.', '')]);

        // Preview first 5 samples
        if ($i < 5) {
            echo "Sample " . ($i + 1) . ": " . number_format($val, 4) . "\n";
        }
    }

    fclose($file);

    echo "--------------------------------------\n";
    echo "Success! Data saved to 'itamaraca_results.csv'.\n";
    echo "Analyze Uniformity (Bars) and Dynamics (Lines) using the CSV file.\n";

} catch (Exception $e) {
    echo $e->getMessage();
}
