# Internal helpers shared by the exported calculators. Not exported.

# Validate that `data` is a data frame; stop with a clear message otherwise.
.check_data <- function(data) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame, not a ", class(data)[1], ".", call. = FALSE)
  }
  invisible(TRUE)
}

# Validate the `category` argument against the allowed set. Returns the
# lower-cased, de-duplicated categories or stops on an unrecognised value.
.check_category <- function(category, allowed) {
  category <- unique(tolower(category))
  bad <- setdiff(category, allowed)
  if (length(bad) > 0) {
    stop("Unknown `category`: ", paste(bad, collapse = ", "),
         ". Choose from: ", paste(allowed, collapse = ", "), ".",
         call. = FALSE)
  }
  category
}

# For the columns that are present among `required`, stop if any is
# non-numeric. Missing columns are handled separately (warn-and-skip).
.check_numeric <- function(data, required) {
  present <- intersect(required, names(data))
  non_numeric <- present[!vapply(data[present], is.numeric, logical(1))]
  if (length(non_numeric) > 0) {
    stop("These column(s) must be numeric: ",
         paste(non_numeric, collapse = ", "), ".", call. = FALSE)
  }
  invisible(TRUE)
}
