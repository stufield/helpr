#' Logical Testing
#'
#' These functional checks return boolean `TRUE/FALSE`
#'   depending on the result of their test.
#'
#' @name logicals
#'
#' @param x A vector, data frame or `tibble` to be tested.
#'   or integers.
#'
#' @author Stu Field
#'
#' @return Logical/boolean
NULL


#' Is Vector Integer?
#'
#' @describeIn logicals
#'   A general test of whether a numeric
#'   vector object contains only integer values.
#'   This is a fix for the generally
#'   undesired behavior of [is.integer()] which
#'   doesn't actually test for integer numbers (see its ?help).
#'
#' @seealso [floor()], [is.integer()], [all()], [is.numeric()]
#' @examples
#' is_int_vec(10)         # does not return TRUE
#' is_int_vec(10L)        # does not return TRUE
#' is_int_vec(10)
#' is_int_vec(1:10)
#' is_int_vec(c(3.2, 1:10))
#' is_int_vec(rnorm(10))
#'
#' @export
is_int_vec <- function(x) {
  if ( !is.numeric(x) ) {
    return(FALSE)
  }
  all(floor(x) == x, na.rm = TRUE)
}


#' Check for log-space
#'
#' @describeIn logicals
#'   Checks if an object containing numeric data is already in log space.
#'   This check assumes proteomic values are being passed and that the
#'   median of a vector, or of an entire data matrix, will be greater than
#'   15 if in linear space and less than 10 if log-transformed.
#'
#' @examples
#' # log-space
#' x <- rnorm(30, mean = 1000)
#' is_logspace(x)
#' is_logspace(log(x))
#'
#' df <- data.frame(a = 1:5, ft_1234 = round(rnorm(5, mean = 5000, sd = 100), 1))
#' is_logspace(df)
#' df <- data.frame(a = 1:5, ft_3456 = round(rnorm(5, mean = 3, sd = 1), 1))
#' is_logspace(df)
#'
#' @export
is_logspace <- function(x) UseMethod("is_logspace")

#' @noRd
#' @export
is_logspace.default <- function(x) {
  stop(
    paste("Could not find the appropriate S3 method for class:",
          value(class(x)),
          "\nShould be `numeric` or convertable to `numeric`."),
    call. = FALSE
  )
}

#' @importFrom stats median
#' @noRd
#' @export
is_logspace.numeric <- function(x) {
  stats::median(x, na.rm = TRUE) < 15
}

#' @noRd
#' @export
is_logspace.data.frame <- function(x) {
  seln <- vapply(x, is.numeric, NA)
  is_logspace(data.matrix(x[, seln]))
}

#' @noRd
#' @export
is_logspace.matrix <- function(x) {
  is_logspace(as.numeric(x))
}

#' @noRd
#' @export
is_logspace.soma_adat <- function(x) {
  seln <- is_seq(names(x))
  is_logspace(data.matrix(x[, seln]))
}


#' Is Monotonic?
#'
#' @describeIn logicals
#'   A general test of whether the numeric vector `x` is
#'   monotonically *increasing* or *decreasing* in value.
#' @examples
#' # monotonic
#' is_monotonic(1:10)      # TRUE
#' is_monotonic(10:1)      # TRUE
#' is_monotonic(rnorm(10)) # FALSE
#' is_monotonic(seq(10, -10, by = -1)) # TRUE
#' @seealso [diff()], [all()]
#' @export
is_monotonic <- function(x) {
  stopifnot(is.numeric(x))
  up   <- diff(x) >= 0
  down <- diff(x) <= 0
  all(up) || all(down)
}


#' @describeIn logicals
#'   check that `length > 0`.
#' @export
has_length <- function(x) {
  length(x) > 0L
}

#' @describeIn logicals
#'   check that length = 1.
#' @export
len_one <- function(x) {
  length(x) == 1L
}

#' @describeIn logicals
#'   check for scalar + character type.
#' @export
is_chr <- function(x) {
  identical(typeof(x), "character") && len_one(x)
}

#' @describeIn logicals
#'   check for scalar + double type.
#' @export
is_dbl <- function(x) {
  identical(typeof(x), "double") && len_one(x)
}

#' @describeIn logicals
#'   check for scalar + logical type.
#' @export
is_lgl <- function(x) {
  identical(typeof(x), "logical") && len_one(x)
}

#' @describeIn logicals
#'   check for scalar + integer type.
#' @export
is_int <- function(x) {
  identical(typeof(x), "integer") && len_one(x)
}
