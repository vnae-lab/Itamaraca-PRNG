# ITAMARACÁ (ITA) PRNG - Ruby Implementation
# Based on: "A Novel Simple Way to Generate Pseudo Random Numbers" by D.H. Pereira

class ItamaracaPRNG
  def initialize(max_value, initial_seeds, lambda = 1.97)
    raise "Error: Exactly 3 seeds are required." if initial_seeds.length != 3
    
    @max_value = max_value.to_f
    @seeds = initial_seeds.map(&:to_f)
    @lambda = lambda.to_f
  end

  # Generates the next pseudo-random number and updates internal state
  def next
    # Step 1: Intermediate State (Pn)
    # Pn = ABS(S2 - S0)
    pn = (@seeds[2] - @seeds[0]).abs

    # Step 2: Final Calculation (FRNS)
    # FRNS = ABS[N - (Pn * lambda)]
    generated_number = (@max_value - (pn * @lambda)).abs

    # Step 3: Seed Update (Moving sequence logic)
    @seeds[0] = @seeds[1]
    @seeds[1] = @seeds[2]
    @seeds[2] = generated_number

    generated_number
  end
end

# --- Execution ---
total_samples = 10000
max_range = 10000.0
initial_seeds = [800.0, 25.0, 3005.0]
lambda_val = 1.97

ita = ItamaracaPRNG.new(max_range, initial_seeds, lambda_val)

puts "--- Itamaraca PRNG Ruby Simulation ---"
puts "Generating #{total_samples} numbers..."

# Save to CSV
begin
  File.open("itamaraca_results.csv", "w") do |file|
    file.puts "Index,Value"
    
    total_samples.times do |i|
      val = ita.next
      
      # Write index and value formatted to 4 decimal places
      file.puts "#{i},#{'%.4f' % val}"
      
      # Preview first 5 samples
      puts "Sample #{i + 1}: #{'%.4f' % val}" if i < 5
    end
  end
  
  puts "--------------------------------------"
  puts "Success! Data saved to 'itamaraca_results.csv'."
  puts "Analyze Uniformity (Bars) and Dynamics (Lines) using the CSV."
rescue => e
  puts "An error occurred: #{e.message}"
end
