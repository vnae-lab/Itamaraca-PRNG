using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace ItamaracaSimulation
{
    /// <summary>
    /// ITAMARACÁ (ITA) PRNG - C# Implementation
    /// Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
    /// </summary>
    public class ItamaracaPRNG
    {
        private double[] _seeds;
        private readonly double _maxValue;
        private readonly double _lambda;

        public ItamaracaPRNG(double maxValue, double[] initialSeeds, double lambda = 1.97)
        {
            if (initialSeeds.Length != 3)
                throw new ArgumentException("Error: Exactly 3 seeds are required.");
            
            _maxValue = maxValue;
            _seeds = (double[])initialSeeds.Clone();
            _lambda = lambda;
        }

        public double Next()
        {
            // Step 1: Intermediate State (Pn)
            // Pn = ABS(S2 - S0)
            double pn = Math.Abs(_seeds[2] - _seeds[0]);

            // Step 2: Final Calculation (FRNS)
            // FRNS = ABS[N - (Pn * lambda)]
            double generatedNumber = Math.Abs(_maxValue - (pn * _lambda));

            // Step 3: Seed Update (Moving sequence logic)
            _seeds[0] = _seeds[1];
            _seeds[1] = _seeds[2];
            _seeds[2] = generatedNumber;

            return generatedNumber;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Configuration
            const int totalSamples = 10000;
            const double nRange = 10000.0;
            double[] initialSeeds = { 800.0, 25.0, 3005.0 };
            const double lambdaVal = 1.97;

            var ita = new ItamaracaPRNG(nRange, initialSeeds, lambdaVal);

            Console.WriteLine("--- Itamaraca PRNG C# Simulation ---");
            Console.WriteLine($"Generating {totalSamples} numbers...");

            try
            {
                using (StreamWriter writer = new StreamWriter("itamaraca_results.csv"))
                {
                    writer.WriteLine("Index,Value");

                    for (int i = 0; i < totalSamples; i++)
                    {
                        double val = ita.Next();
                        writer.WriteLine($"{i},{val:F4}");

                        // Preview first 5
                        if (i < 5)
                        {
                            Console.WriteLine($"Sample {i + 1}: {val:F4}");
                        }
                    }
                }

                Console.WriteLine("--------------------------------------");
                Console.WriteLine("Success! Data saved to 'itamaraca_results.csv'.");
                Console.WriteLine("Analyze Uniformity (Bars) and Dynamics (Lines) using the exported file.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }
    }
}
