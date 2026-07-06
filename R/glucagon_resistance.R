#' Glucagon Resistance Indices
#'
#' Calculates surrogate indices of glucagon resistance / failure of
#' glucose-induced glucagon suppression, reflecting impaired hepatic
#' glucagon signaling as described in the liver-alpha-cell-axis literature.
#'
#' @param data A data frame containing `"Glucagon0"`, `"Glucagon120"` and
#'   `"I0"`.
#'
#' @details
#' Expected units: glucagon and insulin in a consistent molar unit
#' (e.g. pmol/L), measured at fasting (0 min) and 120 min after a 75 g OGTT.
#' If a required column is missing, the corresponding index is skipped with
#' a warning.
#'
#' Indices calculated:
#' - `Glucagon_suppression_ratio`: `Glucagon120 / Glucagon0`. Values at or
#'   above 1 indicate failure to suppress glucagon after a glucose load, a
#'   marker of glucagon resistance.
#' - `Glucagon_insulin_ratio`: fasting `Glucagon0 / I0`, reported to
#'   correlate with whole-body insulin sensitivity and beta-cell function.
#'
#' @return The input data frame with the requested index columns appended.
#'
#' @references
#' Chen X, Maldonado E, DeFronzo RA, Tripathy D (2021). Impaired
#' Suppression of Glucagon in Obese Subjects Parallels Decline in Insulin
#' Sensitivity and Beta-Cell Function. J Clin Endocrinol Metab, 106(5),
#' 1398-1409. \doi{10.1210/clinem/dgab019}
#'
#' @examples
#' data(example_data)
#' glucagon_resistance(example_data)
#'
#' @export
glucagon_resistance <- function(data) {
  .check_data(data)
  .check_numeric(data, c("Glucagon0", "Glucagon120", "I0"))

  required_cols <- c("Glucagon0", "Glucagon120", "I0")
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    warning("Missing columns for glucagon resistance indices: ",
            paste(missing_cols, collapse = ", "))
    return(data)
  }

  data$Glucagon_suppression_ratio <- data$Glucagon120 / data$Glucagon0
  data$Glucagon_insulin_ratio <- data$Glucagon0 / data$I0

  data
}
