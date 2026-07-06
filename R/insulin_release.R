#' Beta-Cell Insulin Release Indices
#'
#' Calculates surrogate indices of beta-cell insulin secretion from fasting
#' and oral glucose tolerance test (OGTT) glucose/insulin measurements.
#'
#' @param data A data frame containing the columns required for the requested
#'   `category` (see Details).
#' @param category Character vector selecting which indices to calculate.
#'   One or both of `"fasting"` and `"ogtt"`. Defaults to both.
#'
#' @details
#' Required columns per category:
#' - `fasting`: `"G0"`, `"I0"`
#' - `ogtt`: `"G0"`, `"I0"`, `"G30"`, `"I30"`, `"G120"`, `"I120"`, `"sex"`, `"bmi"`
#'
#' Expected units: glucose (`G0`, `G30`, `G120`) in mmol/L, insulin (`I0`,
#' `I30`, `I120`) in pmol/L, `bmi` in kg/m^2, and `sex` as a male indicator
#' (male = 1, female = 0). The BIGTT-AIR and BIGTT-SI terms enter `sex`
#' as a linear multiplier, so any value other than 1 is treated as female;
#' females coded as 2 are handled correctly. Internally, insulin is
#' converted from pmol/L to microU/mL (`value * 0.1667`) and glucose from
#' mmol/L to mg/dL (`value * 18`) where the source formula was derived in
#' those units.
#' If a required column is missing, the corresponding indices are skipped
#' with a warning; missing values within a present column yield `NA` only
#' for the indices that depend on them.
#'
#' Indices calculated:
#' - `Homa_beta` (`fasting`): HOMA-beta, an estimate of steady-state beta-cell
#'   function.
#' - `Cir` (`ogtt`): Corrected Insulin Response.
#' - `Stumvoll` (`ogtt`): Stumvoll first-phase insulin release index.
#' - `Xinsdg30` (`ogtt`): insulinogenic index using the 0-30 min glucose
#'   increment.
#' - `Xinsg30` (`ogtt`): insulinogenic index using the 30 min glucose value.
#' - `Di` (`ogtt`): Disposition Index (`Xinsg30`-based).
#' - `Bigtt_air` (`ogtt`): BIGTT Acute Insulin Response.
#' - `Dibig` (`ogtt`): Disposition Index (`Bigtt_air`-based).
#'
#' @return The input data frame with the requested index columns appended.
#'
#' @references
#' Madsen AL, et al. (2024). Genetic architecture of oral glucose-stimulated
#' insulin release provides biological insights into type 2 diabetes
#' aetiology. Nature Metabolism. \doi{10.1038/s42255-024-01140-6}
#'
#' @examples
#' data(example_data)
#' insulin_release(example_data, category = "fasting")
#' insulin_release(example_data, category = c("fasting", "ogtt"))
#'
#' @export
insulin_release <- function(data, category = c("fasting", "ogtt")) {
  .check_data(data)
  category <- .check_category(category, c("fasting", "ogtt"))

  required_fasting <- c("G0", "I0")
  required_ogtt <- c("G0", "I0", "G30", "I30", "G120", "I120", "sex", "bmi")
  needed <- character(0)
  if ("fasting" %in% category) needed <- union(needed, required_fasting)
  if ("ogtt" %in% category) needed <- union(needed, required_ogtt)
  .check_numeric(data, needed)

  if ("fasting" %in% category) {
    missing_cols <- setdiff(required_fasting, names(data))
    if (length(missing_cols) > 0) {
      warning("Missing columns for fasting insulin release indices: ",
              paste(missing_cols, collapse = ", "))
    } else {
      I0_uUml <- data$I0 * 0.1667
      data$Homa_beta <- (I0_uUml * 20) / (data$G0 - 3.5)
    }
  }

  if ("ogtt" %in% category) {
    missing_cols <- setdiff(required_ogtt, names(data))
    if (length(missing_cols) > 0) {
      warning("Missing columns for OGTT insulin release indices: ",
              paste(missing_cols, collapse = ", "))
    } else {
      G0 <- data$G0; G30 <- data$G30; G120 <- data$G120
      I0 <- data$I0; I30 <- data$I30; I120 <- data$I120
      bmi <- data$bmi
      # BIGTT was derived with sex as a male indicator (male = 1, female = 0),
      # so coerce to 0/1 to stay correct even if females are coded 2.
      sex <- as.integer(data$sex == 1)

      G30_mgdl <- G30 * 18
      mean_G <- rowMeans(cbind(G0, G30, G120), na.rm = TRUE)
      mean_I <- rowMeans(cbind(I0, I30, I120), na.rm = TRUE)

      data$Cir <- (I30 * 0.1667 * 100) / (G30_mgdl * (G30_mgdl - 70))
      data$Stumvoll <- 1283 + 1.829 * I30 - 138.7 * G30 + 3.772 * I0
      data$Xinsdg30 <- ((I30 - I0) * 0.1667) / ((G30 - G0) * 18)
      data$Xinsg30 <- ((I30 - I0) * 0.1667) / G30
      data$Di <- (data$Xinsg30 * 1000) /
        (sqrt((G0 * 18) * I0 * 0.1667) * ((mean_G * 18) * mean_I * 0.1667))
      data$Bigtt_air <- exp(8.20 + 0.00178 * I0 + 0.00168 * I30 -
                               0.000383 * I120 - 0.314 * G0 - 0.109 * G30 +
                               0.0781 * G120 + 0.180 * sex + 0.032 * bmi)
      data$Dibig <- data$Bigtt_air * exp(4.90 - 0.00402 * I0 - 0.000556 * I30 -
                                            0.00127 * I120 - 0.152 * G0 -
                                            0.00871 * G30 - 0.0373 * G120 -
                                            0.145 * sex - 0.0376 * bmi)
    }
  }

  data
}
