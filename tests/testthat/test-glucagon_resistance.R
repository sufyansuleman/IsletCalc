test_that("suppression ratio and glucagon:insulin ratio are computed", {
  df <- data.frame(Glucagon0 = 10, Glucagon120 = 6, I0 = 60)
  res <- glucagon_resistance(df)
  expect_equal(res$Glucagon_suppression_ratio, 0.6)
  expect_equal(res$Glucagon_insulin_ratio, 10 / 60)
})

test_that("ratio at or above 1 flags failed suppression", {
  df <- data.frame(Glucagon0 = 10, Glucagon120 = 11, I0 = 60)
  res <- glucagon_resistance(df)
  expect_gte(res$Glucagon_suppression_ratio, 1)
})

test_that("missing columns warn and return data unchanged", {
  df <- data.frame(Glucagon0 = 10)
  expect_warning(res <- glucagon_resistance(df),
                  "Missing columns for glucagon resistance")
  expect_identical(res, df)
})
