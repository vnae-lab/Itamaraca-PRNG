itamaraca_prng <- function(max_value, seeds, λ = 1.97) {
  # Error Checking
  if (length(seeds) != 3) {
    stop("Error: The number of seeds must be 3.")
  }
  if (any(sapply(seeds, is.numeric)) == FALSE) {
    stop("Error: The seeds must be numeric values.")
  }
  if (max_value <= 0) {
    stop("Error: The maximum value must be positive.")
  }
  if (λ <= 0) {
    stop("Error: The constant λ must be positive. λ must have an x-value close to 2 (1.97, 1.9258, 1.99883)")
  }

  # Infinite loop to generate pseudo-random numbers
  while (TRUE) {
    # Calculating the pseudo-random value
    pn <- seeds[[3]] - seeds[[1]]
    generated_number <- abs(max_value - abs(pn * λ))

    # Printing the generated number
    print(generated_number)

    # Seed update
    seeds[[1]] <- seeds[[2]]
    seeds[[2]] <- seeds[[3]]
    seeds[[3]] <- generated_number
  }
}

# Example of use
max_value <- 10000
seeds <- c(800, 25, 3005)
λ <- 1.97

itamaraca_prng(max_value, seeds, λ)
