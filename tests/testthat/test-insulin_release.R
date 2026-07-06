test_that("fasting category computes Homa_beta correctly", {
  df <- data.frame(G0 = 5, I0 = 60)
  res <- insulin_release(df, category = "fasting")
  expected <- ((60 * 0.1667) * 20) / (5 - 3.5)
  expect_equal(res$Homa_beta, expected)
  expect_false("Cir" %in% names(res))
})

test_that("ogtt category computes all expected columns", {
  df <- data.frame(
    G0 = 5, G30 = 8, G120 = 6,
    I0 = 60, I30 = 300, I120 = 150,
    sex = 1, bmi = 25
  )
  res <- insulin_release(df, category = "ogtt")
  expect_true(all(c("Cir", "Stumvoll", "Xinsdg30", "Xinsg30", "Di",
                     "Bigtt_air", "Dibig") %in% names(res)))
  expect_true(all(vapply(res[c("Cir", "Stumvoll", "Xinsdg30", "Xinsg30",
                                "Di", "Bigtt_air", "Dibig")],
                          function(x) is.finite(x), logical(1))))
})

test_that("missing columns trigger a warning and skip the category", {
  df <- data.frame(G0 = 5, I0 = 60)
  expect_warning(res <- insulin_release(df, category = "ogtt"),
                  "Missing columns for OGTT")
  expect_false("Cir" %in% names(res))
})

test_that("both categories can be requested together", {
  df <- data.frame(
    G0 = 5, G30 = 8, G120 = 6,
    I0 = 60, I30 = 300, I120 = 150,
    sex = 0, bmi = 25
  )
  res <- insulin_release(df, category = c("fasting", "ogtt"))
  expect_true(all(c("Homa_beta", "Cir", "Dibig") %in% names(res)))
})

test_that("Homa_beta matches the Madsen formula numerically", {
  df <- data.frame(G0 = 5.2, I0 = 72)
  res <- insulin_release(df, category = "fasting")
  expect_equal(res$Homa_beta, (72 * 0.1667 * 20) / (5.2 - 3.5))
})

test_that("Cir uses the canonical mg/dL parenthesisation", {
  df <- data.frame(G0 = 5, G30 = 8, G120 = 6, I0 = 60, I30 = 300,
                   I120 = 150, sex = 1, bmi = 25)
  res <- insulin_release(df, category = "ogtt")
  g30 <- 8 * 18
  expect_equal(res$Cir, (300 * 0.1667 * 100) / (g30 * (g30 - 70)))
})

test_that("Di matches the as-reported Madsen table formula", {
  df <- data.frame(G0 = 5, G30 = 8, G120 = 6, I0 = 60, I30 = 300,
                   I120 = 150, sex = 1, bmi = 25)
  res <- insulin_release(df, category = "ogtt")
  xinsg30 <- ((300 - 60) * 0.1667) / 8
  mg <- mean(c(5, 8, 6)); mi <- mean(c(60, 300, 150))
  expected <- (xinsg30 * 1000) /
    (sqrt((5 * 18) * 60 * 0.1667) * ((mg * 18) * mi * 0.1667))
  expect_equal(res$Di, expected)
})

test_that("sex enters as a male indicator (female 0 and 2 are equivalent)", {
  base <- data.frame(G0 = 5, G30 = 8, G120 = 6, I0 = 60, I30 = 300,
                     I120 = 150, sex = 0, bmi = 25)
  alt <- base; alt$sex <- 2
  r0 <- insulin_release(base, category = "ogtt")
  r2 <- insulin_release(alt, category = "ogtt")
  expect_equal(r0$Bigtt_air, r2$Bigtt_air)
  expect_equal(r0$Dibig, r2$Dibig)
})

test_that("non-data-frame input errors", {
  expect_error(insulin_release(list(G0 = 5, I0 = 60)),
               "must be a data frame")
})

test_that("unknown category errors with the allowed set", {
  df <- data.frame(G0 = 5, I0 = 60)
  expect_error(insulin_release(df, category = "meal"),
               "Unknown `category`")
})

test_that("category is case-insensitive", {
  df <- data.frame(G0 = 5, I0 = 60)
  res <- insulin_release(df, category = "FASTING")
  expect_true("Homa_beta" %in% names(res))
})

test_that("non-numeric required column errors", {
  df <- data.frame(G0 = "high", I0 = 60)
  expect_error(insulin_release(df, category = "fasting"),
               "must be numeric")
})
