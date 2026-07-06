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

test_that("non-data-frame input errors", {
  expect_error(insulin_release(list(G0 = 5, I0 = 60)),
               "must be a data frame")
})
