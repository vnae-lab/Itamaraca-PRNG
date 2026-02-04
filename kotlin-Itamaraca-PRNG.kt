import java.io.File
import java.util.*
import kotlin.math.abs

/**
 * ITAMARACÁ (ITA) PRNG - Kotlin Implementation
 * Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira
 */
class ItamaracaPRNG(
    private val maxValue: Double,
    initialSeeds: DoubleArray,
    private val lambda: Double = 1.97
) {
    private val seeds = initialSeeds.copyOf()

    init {
        require(seeds.size == 3) { "Error: Exactly 3 seeds are required." }
    }

    /**
     * Generates the next pseudo-random number and updates internal state
     */
    fun next(): Double {
        // Step 1: Intermediate State (Pn)
        // Pn = ABS(S2 - S0)
        val pn = abs(seeds[2] - seeds[0])

        // Step 2: Final Calculation (FRNS)
        // FRNS = ABS[N - (Pn * lambda)]
        val generatedNumber = abs(maxValue - (pn * lambda))

        // Step 3: Seed Update (Moving sequence logic)
        seeds[0] = seeds[1]
        seeds[1] = seeds[2]
        seeds[2] = generatedNumber

        return generatedNumber
    }
}

fun main() {
    // --- Configuration ---
    val totalSamples = 10000
    val maxRange = 10000.0
    val initialSeeds = doubleArrayOf(800.0, 25.0, 3005.0)
    val lambdaVal = 1.97

    val ita = ItamaracaPRNG(maxRange, initialSeeds, lambdaVal)

    println("--- Itamaraca PRNG Kotlin Simulation ---")
    println("Generating $totalSamples numbers...")

    val resultsFile = File("itamaraca_results.csv")
    
    // Writing to CSV
    resultsFile.printWriter().use { out ->
        out.println("Index,Value")
        
        for (i in 0 until totalSamples) {
            val valGenerated = ita.next()
            out.println("$i,${"%.4f".format(Locale.US, valGenerated)}")

            // Preview first 5
            if (i < 5) {
                println("Sample ${i + 1}: ${"%.4f".format(Locale.US, valGenerated)}")
            }
        }
    }

    println("--------------------------------------")
    println("Success! Data saved to 'itamaraca_results.csv'.")
    println("Analyze Uniformity (Bars) and Dynamics (Lines) using the CSV.")
}
