#' Alpha-Cell Glucagon Release Indices
#'
#' Calculates surrogate indices of alpha-cell glucagon secretion magnitude
#' from fasting and oral glucose tolerance test (OGTT) glucagon measurements.
#'
#' @param data A data frame containing `"Glucagon0"`, and optionally
#'   `"Glucagon30"` and `"Glucagon120"` for the area-under-curve index.
#'
#' @details
#' Expected units: glucagon values in pmol/L (or another consistent molar
#' unit), measured at fasting (0 min), 30 min and 120 min after a 75 g OGTT.
#' `Fasting_glucagon` requires only `Glucagon0`. `Glucagon_auc` additionally
#' requires `Glucagon30` and `Glucagon120`; if either is missing, `Glucagon_auc`
#' is skipped with a warning.
#'
#' Indices calculated:
#' - `Fasting_glucagon`: fasting plasma glucagon (pass-through of `Glucagon0`).
#' - `Glucagon_auc`: trapezoidal area under the glucagon curve across 0, 30
#'   and 120 min.
#'
#' @return The input data frame with the requested index columns appended.
#'
#' @examples
#' data(example_data)
#' glucagon_release(example_data)
#'
#' @export
glucagon_release <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a data frame.")
  }

  if (!"Glucagon0" %in% names(data)) {
    warning("Missing column for glucagon release indices: Glucagon0")
    return(data)
  }

  data$Fasting_glucagon <- data$Glucagon0

  auc_cols <- c("Glucagon0", "Glucagon30", "Glucagon120")
  missing_cols <- setdiff(auc_cols, names(data))
  if (length(missing_cols) > 0) {
    warning("Missing columns for Glucagon_auc: ", paste(missing_cols, collapse = ", "))
  } else {
    data$Glucagon_auc <- 0.5 * ((data$Glucagon30 + data$Glucagon0) * 30 +
                                   (data$Glucagon120 + data$Glucagon30) * 90)
  }

  data
}
