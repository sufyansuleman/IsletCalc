test_that("Fasting_glucagon is a pass-through of Glucagon0", {
  df <- data.frame(Glucagon0 = 10, Glucagon30 = 8, Glucagon120 = 9)
  res <- glucagon_release(df)
  expect_equal(res$Fasting_glucagon, 10)
})

test_that("Glucagon_auc is computed with all three timepoints", {
  df <- data.frame(Glucagon0 = 10, Glucagon30 = 7, Glucagon120 = 6)
  res <- glucagon_release(df)
  expected <- 0.5 * ((7 + 10) * 30 + (6 + 7) * 90)
  expect_equal(res$Glucagon_auc, expected)
})

test_that("missing Glucagon0 warns and returns data unchanged", {
  df <- data.frame(x = 1)
  expect_warning(res <- glucagon_release(df), "Glucagon0")
  expect_identical(res, df)
})

test_that("missing AUC timepoints warns but keeps Fasting_glucagon", {
  df <- data.frame(Glucagon0 = 10)
  expect_warning(res <- glucagon_release(df), "Glucagon_auc")
  expect_equal(res$Fasting_glucagon, 10)
  expect_false("Glucagon_auc" %in% names(res))
})
