#' Easily Subset Elements of Objects
#'
#' Alternatives to [purrr::keep()], [purrr::discard()],
#'   and [purrr::compact()], but without having to load
#'   the \pkg{purrr} namespace.
#'   The syntax and behavior is generally the same, with some
#'   exceptions (see `Details`). For example, [compact_it()]
#'   is similar to [purrr::compact()], however only supports
#'   the default behavior where non-empty elements are retained.
#'
#' These functions are not a simple drop-in replacement,
#'   as they do not support quasi-quotation or formula syntax, but
#'   should be a sufficient replacement in most cases.
#'
#' @section purrr analogues:
#' \tabular{ll}{
#'   \pkg{helpr}     \tab \pkg{purrr} \cr
#'   [keep_it()]     \tab [purrr::keep()] \cr
#'   [discard_it()]  \tab [purrr::discard()] \cr
#'   [compact_it()]  \tab [purrr::compact()] \cr
#' }
#'
#' @param x A list, data frame, or vector.
#' @param lgl `logical(n)`.  A vector or a function
#'   that returns a logical vector when applied to
#'   the elements of `x`.
#' @param ... Named arguments passed to `lgl` if it is a function.
#'
#' @examples
#' # pass a logical vector
#' lst <- list(A = 1, B = 2, C = 3)
#' keep_it(lst, c(TRUE, FALSE, TRUE))
#'
#' # logical vector on-the-fly
#' vec <- unlist(lst)
#' keep_it(vec, vec != 2)
#'
#' # subset itself
#' keep_it(c(a = TRUE, b = FALSE, c = TRUE), identity)
#'
#' # pass a simple function
#' lst <- replicate(10, sample(10, 5), simplify = FALSE)
#' keep_it(lst, function(x) mean(x) > 6)
#'
#' # will work on data frames
#' df <- data.frame(a = 5, b = 2, c = 10)
#' keep_it(df, function(x) x >= 5)
#'
#' df <- data.frame(a = "A", b = "B", c = 10, d = 20)
#' keep_it(df, is.numeric)
#'
#' # compact_it() selects elements with non-zero length
#' lst <- list(A = 5, B = character(0), C = 6, D = NULL, E = NA, F = list())
#' compact_it(lst)

#' # discard_it() works nicely with `be_safe()`
#' .f <- be_safe(log10)
#' res <- .f("5")
#' discard_it(res, is.null)
#' @name elements
NULL

#' @describeIn elements
#'   keeps elements corresponding to `lgl`.
#' @export
keep_it <- function(x, lgl, ...) {
  if ( is.function(lgl) ) {
    lgl <- vapply(x, lgl, ..., NA)
  }
  x[!is.na(lgl) & lgl]
}

#' @describeIn elements
#'   the inverse of [keep_it()].
#' @export
discard_it <- function(x, lgl, ...) {
  if ( is.function(lgl) ) {
    lgl <- vapply(x, lgl, ..., NA)
  }
  x[!(is.na(lgl) | lgl)]
}

#' @describeIn elements
#'   subsets elements that have non-zero length.
#' @export
compact_it <- function(x) {
  Filter(has_length, x)
}
