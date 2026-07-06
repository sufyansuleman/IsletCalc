# Simulates the bundled example_data used in ?example_data and in the
# package examples/vignette/tests. Not part of the installed package
# (see .Rbuildignore).

set.seed(123)
n <- 50

sex <- sample(c(0, 1), n, replace = TRUE)
bmi <- round(rnorm(n, mean = 26, sd = 4), 1)

G0 <- round(rnorm(n, mean = 5.2, sd = 0.5), 2)
G30 <- round(G0 + rnorm(n, mean = 3.2, sd = 0.8), 2)
G120 <- round(G0 + rnorm(n, mean = 1.2, sd = 1.2), 2)

I0 <- round(rgamma(n, shape = 6, scale = 10), 1)
I30 <- round(I0 * runif(n, 4, 7) + rnorm(n, 0, 20), 1)
I120 <- round(I0 * runif(n, 1.5, 3.5) + rnorm(n, 0, 20), 1)

Glucagon0 <- round(rnorm(n, mean = 10, sd = 3), 2)
suppression <- runif(n, 0.5, 1.15) # most subjects suppress; some do not (resistance)
Glucagon30 <- round(Glucagon0 * runif(n, 0.6, 0.9), 2)
Glucagon120 <- round(Glucagon0 * suppression, 2)

example_data <- data.frame(
  G0 = G0, G30 = G30, G120 = G120,
  I0 = I0, I30 = I30, I120 = I120,
  sex = sex, bmi = bmi,
  Glucagon0 = Glucagon0, Glucagon30 = Glucagon30, Glucagon120 = Glucagon120
)

usethis::use_data(example_data, overwrite = TRUE)
