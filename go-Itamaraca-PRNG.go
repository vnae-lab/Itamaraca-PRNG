package main

import (
	"encoding/csv"
	"fmt"
	"math"
	"os"
	"strconv"
)

// ItamaracaPRNG represents the state of the generator
type ItamaracaPRNG struct {
	seeds    []float64
	maxValue float64
	lambda   float64
}

// NewItamaracaPRNG initializes the generator with 3 seeds
func NewItamaracaPRNG(maxValue float64, seeds []float64, lambda float64) *ItamaracaPRNG {
	if len(seeds) != 3 {
		panic("Error: Exactly 3 seeds are required.")
	}
	// Copy seeds to avoid external mutations
	s := make([]float64, 3)
	copy(s, seeds)
	return &ItamaracaPRNG{
		seeds:    s,
		maxValue: maxValue,
		lambda:   lambda,
	}
}

// Next generates the next pseudo-random number and updates the seeds
func (ita *ItamaracaPRNG) Next() float64 {
	// Step 1: Intermediate State (Pn)
	// Pn = ABS(S2 - S0)
	pn := math.Abs(ita.seeds[2] - ita.seeds[0])

	// Step 2: Final Calculation (FRNS)
	// FRNS = ABS[N - (Pn * lambda)]
	generatedNumber := math.Abs(ita.maxValue - (pn * ita.lambda))

	// Step 3: Seed Update (Moving sequence logic)
	ita.seeds[0] = ita.seeds[1]
	ita.seeds[1] = ita.seeds[2]
	ita.seeds[2] = generatedNumber

	return generatedNumber
}

func main() {
	// --- Configuration ---
	totalSamples := 10000
	maxRange := 10000.0
	initialSeeds := []float64{800.0, 25.0, 3005.0}
	lambdaVal := 1.97

	ita := NewItamaracaPRNG(maxRange, initialSeeds, lambdaVal)

	fmt.Println("--- Itamaraca PRNG Go Simulation ---")
	fmt.Printf("Generating %d numbers...\n", totalSamples)

	// Create CSV file
	file, err := os.Create("itamaraca_results.csv")
	if err != nil {
		fmt.Println("Error creating file:", err)
		return
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	// Write CSV Header
	writer.Write([]string{"Index", "Value"})

	for i := 0; i < totalSamples; i++ {
		val := ita.Next()

		// Write to CSV
		writer.Write([]string{
			strconv.Itoa(i),
			fmt.Sprintf("%.4f", val),
		})

		// Print first 5 preview
		if i < 5 {
			fmt.Printf("Sample %d: %.4f\n", i+1, val)
		}
	}

	fmt.Println("--------------------------------------")
	fmt.Println("Success! Data saved to 'itamaraca_results.csv'.")
	fmt.Println("Analyze Uniformity (Bars) and Dynamics (Lines) using the CSV.")
}
