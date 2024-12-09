#' `Logit` and `Expit` Transformations
#'
#' `logit()` computes the binary logit function.
#'   This is a simple wrapper for `stats::qlogis()`
#'   with default input arguments.
#'
#' @rdname logit
#'
#' @param x `numeric(n)`.
#' @return A `numeric(n)` corresponding to transformed `x`.
#'
#' @examples
#' x <- stats::runif(n = 100L)
#' logit(x)
#'
#' @importFrom stats qlogis runif
#' @export
logit <- function(x) {

  stopifnot("`x` must be numeric." = inherits(x, "numeric"))

  if ( any(is.nan(x)) ) {
    warning("`x` contains NaNs.", call. = FALSE)
  }

  if ( any(is.na(x) & !is.nan(x)) ) {
    warning("`x` contains NAs.", call. = FALSE)
  }

  .f <- be_quiet(.f = stats::qlogis)

  result <- .f(p = x)

  if ( length(result$warnings) != 0L ) {
    warning(result$warnings, call. = FALSE)
  }

  if ( any(is.infinite(result$result)) ) {
    warning("Some values are infinite.", call. = FALSE)
  }

  result$result
}

#' Logit and Expit Transformations
#'
#' `expit()` computes the logistic function. This is a
#'   simple wrapper for `stats::plogis()` with
#'   default input arguments.
#'
#' @rdname logit
#'
#' @examples
#' x <- stats::rnorm(n = 100L)
#' expit(x)
#' @importFrom stats plogis rnorm
#' @export
expit <- function(x) {

  stopifnot("`x` must be numeric." = is.numeric(x))

  if ( any(is.nan(x)) ) {
    warning("`x` contains NaNs.", call. = FALSE)
  }

  if ( any(is.na(x) & !is.nan(x)) ) {
    warning("`x` contains NAs.", call. = FALSE)
  }

  .f <- be_quiet(.f = stats::plogis)

  result <- .f(q = x)

  if ( length(result$warnings) != 0L ) {
    warning(result$warnings, call. = FALSE)
  }

  result$result
}
