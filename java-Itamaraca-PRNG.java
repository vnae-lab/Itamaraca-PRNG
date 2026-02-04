import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

/**
 * ITAMARACÁ (ITA) PRNG - Java Implementation
 * Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
 */
public class ItamaracaPRNG {

    private double[] seeds;
    private double maxValue;
    private double lambda;

    public ItamaracaPRNG(double maxValue, double[] initialSeeds, double lambda) {
        if (initialSeeds.length != 3) {
            throw new IllegalArgumentException("Error: Exactly 3 seeds are required.");
        }
        this.maxValue = maxValue;
        this.seeds = Arrays.copyOf(initialSeeds, 3);
        this.lambda = lambda;
    }

    public double next() {
        // Step 1: Intermediate State (Pn)
        // Pn = ABS(S2 - S0)
        double pn = Math.abs(seeds[2] - seeds[0]);

        // Step 2: Final Calculation (FRNS)
        // FRNS = ABS[N - (Pn * lambda)]
        double generatedNumber = Math.abs(maxValue - (pn * lambda));

        // Step 3: Seed Update (Moving sequence logic)
        seeds[0] = seeds[1];
        seeds[1] = seeds[2];
        seeds[2] = generatedNumber;

        return generatedNumber;
    }

    public static void main(String[] args) {
        // Configuration
        int totalSamples = 10000;
        double nRange = 10000.0;
        double[] initialSeeds = {800.0, 25.0, 3005.0};
        double lambdaVal = 1.97;

        ItamaracaPRNG ita = new ItamaracaPRNG(nRange, initialSeeds, lambdaVal);

        System.out.println("--- Itamaraca PRNG Java Simulation ---");
        System.out.println("Generating " + totalSamples + " numbers...");

        try (PrintWriter writer = new PrintWriter(new FileWriter("itamaraca_results.csv"))) {
            writer.println("Index,Value");

            for (int i = 0; i < totalSamples; i++) {
                double val = ita.next();
                writer.printf("%d,%.4f%n", i, val);

                // Print first 5 for preview
                if (i < 5) {
                    System.out.printf("Sample %d: %.4f%n", i + 1, val);
                }
            }
            
            System.out.println("--------------------------------------");
            System.out.println("Success! Data saved to 'itamaraca_results.csv'.");
            System.out.println("Use this file to analyze Uniformity (Bars) and Dynamics (Lines).");

        } catch (IOException e) {
            System.err.println("Error saving file: " + e.getMessage());
        }
    }
}
