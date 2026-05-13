# --- (a) Vectors and Data Frame ---

# Create numeric vectors
x <- c(1, 2, 3, 4, 5)
y <- c(10, 20, 30, 40, 50)

# Create a data frame from the two vectors
df <- data.frame(id = x, value = y)
print(df)

# --- (b) User-Defined Function ---

# Define a function that computes the mean of a vector
my_mean <- function(v) {
  return(sum(v) / length(v))
}

# Call the function and display the result
result <- my_mean(x)
cat("Mean of x:", result, "\n")
