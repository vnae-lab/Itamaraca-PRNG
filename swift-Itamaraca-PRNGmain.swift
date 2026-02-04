import Foundation

/// ITAMARACÁ (ITA) PRNG - Swift Implementation
/// Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
class ItamaracaPRNG {
    private var seeds: [Double]
    private let maxValue: Double
    private let lambda: Double
    
    init(maxValue: Double, initialSeeds: [Double], lambda: Double = 1.97) {
        guard initialSeeds.count == 3 else {
            fatalError("Error: Exactly 3 seeds are required.")
        }
        self.maxValue = maxValue
        self.seeds = initialSeeds
        self.lambda = lambda
    }
    
    /// Generates the next pseudo-random number and updates internal state
    func next() -> Double {
        // Step 1: Intermediate State (Pn)
        // Pn = ABS(S2 - S0)
        let pn = abs(seeds[2] - seeds[0])
        
        // Step 2: Final Calculation (FRNS)
        // FRNS = ABS[N - (Pn * lambda)]
        let generatedNumber = abs(maxValue - (pn * lambda))
        
        // Step 3: Seed Update (Moving sequence logic)
        seeds[0] = seeds[1]
        seeds[1] = seeds[2]
        seeds[2] = generatedNumber
        
        return generatedNumber
    }
}

// --- Execution ---
let totalSamples = 10000
let maxRange: Double = 10000.0
let initialSeeds = [800.0, 25.0, 3005.0]
let lambdaVal = 1.97

let ita = ItamaracaPRNG(maxValue: maxRange, initialSeeds: initialSeeds, lambda: lambdaVal)

print("--- Itamaraca PRNG Swift Simulation ---")
print("Generating \(totalSamples) numbers...")

var csvContent = "Index,Value\n"

for i in 0..<totalSamples {
    let val = ita.next()
    
    // Append to CSV string
    csvContent += "\(i),\(String(format: "%.4f", val))\n"
    
    // Preview first 5
    if i < 5 {
        print("Sample \(i + 1): \(String(format: "%.4f", val))")
    }
}

// Save to CSV File
let fileName = "itamaraca_results.csv"
let path = FileManager.default.currentDirectoryPath + "/" + fileName

do {
    try csvContent.write(toFile: path, atomically: true, encoding: .utf8)
    print("--------------------------------------")
    print("Success! Data saved to '\(fileName)'.")
    print("Analyze Uniformity (Bars) and Dynamics (Lines) using the CSV.")
} catch {
    print("Failed to write file: \(error)")
}
