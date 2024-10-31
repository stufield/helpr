#' Calculate the Brier Score
#'
#' Calculates the Brier Score, i.e. MSE of probabilities in
#' \verb{[0, 1]} of a vector of probabilities.
#' The brier score attempts to account for not only wither
#' a prediction correctly predicts a class label at some
#' arbitrary evaluation cutoff, but als *how close* the prediction
#' is to predicting the label, i.e. distinguishing between
#' \eqn{p = 0.51} and \eqn{p = 0.99}, despite both predicting
#' a positive class label.
#'
#' @param x A vector of binary class data representing
#'   the true classes. Must be all 0 or 1 or numeric coerceable.
#' @param p A vector of the predicted probabilities, i.e. in \verb{[0, 1]}.
#' @return The Brier Score, a value in \verb{[0, 1]}, representing
#'   the error in predictions, `0` being best possible score.
#' @references https://en.wikipedia.org/wiki/Brier_score
#' @examples
#' withr::with_seed(1, {
#'   n <- 100L
#'   p <- runif(n)
#'   x <- sample(0:1, n, replace = TRUE)
#' })
#' calc_brier(x, p)
#' @export
calc_brier <- function(x, p) UseMethod("calc_brier")

#' @noRd
#' @export
calc_brier.default <- function(x, p) {
  stop(
    "`x` must be *only* numeric 0s and 1s, ",
    "or able to be coerced into a numeric vector.\n",
    "`x` class: ", value(class(x)),
    call. = FALSE
  )
}

#' @noRd
#' @export
calc_brier.numeric <- function(x, p) {
  stopifnot(
    "`x` must contain have only 2 values, 0 and 1." = length(c(table(x))) == 2L,
    "`x` must contain *only* 0 and 1." = all(x %in% 0:1),
    "`x` and `p` must be the same length." = length(x) == length(p)
  )
  mean((p - x)^2)
}

#' @noRd
#' @export
calc_brier.integer <- function(x, p) {
  x <- as.numeric(x)
  calc_brier(x, p)
}

#' @noRd
#' @export
calc_brier.factor <- function(x, p) {
  x <- as.numeric(x) - 1  # 1,2 -> 0,1
  calc_brier(x, p)
}

#' @noRd
#' @export
calc_brier.logical <- function(x, p) {
  x <- as.numeric(x)
  calc_brier(x, p)
}

