#' Calculate the Sum of Squared Errors
#'
#' Calculates the sum of the squared errors (SSE) for
#'   a vector of numeric data.
#'
#' @param x A numeric vector of data.
#' @return The Sum of Squared Errors (SSE) of `x`.
#' @author Stu Field
#' @examples
#' calc_ss(rnorm(100, 50, 5))
#' @export
calc_ss <- function(x) sum((x - mean(x, na.rm = TRUE))^2, na.rm = TRUE)
