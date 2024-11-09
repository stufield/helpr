#' Special Infix Operators
#'
#' A series of useful infix operators, aka "grapes", that
#'   can be used to facilitate core functionality, test equality,
#'   perform set operations, etc.
#'
#' @name grapes
#'
#' @param x The left hand side of the infix operator.
#' @param y The right hand side of the infix operator.
#'
#' @seealso [intersect()], [setdiff()], [all.equal()], [isTRUE()]
#'
#' @examples
#' factor(1:3) %@@@@% levels
#' factor(1:3, levels = LETTERS[1:3L]) %@@@@% levels
#'
#' mtcars %==% mtcars       # equal
#' cars2 <- mtcars
#' cars2 %@@@@% a <- "foo"  # attr assignment; with unquoted 'a'
#' mtcars %==% cars2        # attr not checked; TRUE
#' mtcars %===% cars2       # attr checked; FALSE
#'
#' x <- list(a = "b", c = "d", e = "f")
#' x %set% c("a", "c", "d")   # 'c' match
#' x %!set% c("a", "c", "d")  # 'b' match
#' unlist(x) %!set% c("a", "c", "d")   # 'c' match; vector-vector
#'
#' # extract elements of a list
#' x <- list(a = 1:3, b = 4:6, c = 7:9)
#' x %[[% 2L
#'
#' data.frame(x) %[[% 2L     # data frame -> same as x[2L, ]
NULL


#' @describeIn grapes
#'   A friendly version of `attr(x, y)` to extract `"@@ribute"` elements.
#'  `y` can be unquoted.
#'
#' @export
`%@@%` <- function(x, y) {
  name <- as.character(substitute(y))
  attr(x, which = name, exact = TRUE)
}

#' @describeIn grapes
#'   Assign `"@@ributes"` via infix operator.
#'   A friendly version of `attr(x, y) <- value`. `y` can be unquoted.
#'
#' @param value New value for attribute `y`.
#' @usage x \%@@@@\% y <- value
#'
#' @export
`%@@%<-` <- function(x, y, value) {
  name <- as.character(substitute(y))
  attr(x, which = name) <- value
  x
}

#' @describeIn grapes
#'   A gentler logical test for equality of two objects.
#'   Attributes are *not* checked. Use `%===%` to check attributes.
#'
#' @export
`%==%` <- function(x, y) {
  isTRUE(all.equal(x, y, check.attributes = FALSE))
}

#' @describeIn grapes
#'   A logical test that two objects are *not* equal.
#'
#' @export
`%!=%` <- function(x, y) {
  !isTRUE(all.equal(x, y, check.attributes = FALSE))
}

#' @describeIn grapes
#'   Also tests attributes of `x` and `y`.
#'
#' @export
`%===%` <- function(x, y) {
  isTRUE(all.equal(x, y, check.attributes = TRUE))
}

#' @describeIn grapes
#'   Subset values in `x` by `y`. Alias for `x[x %in% y]`.
#'   Similar to `intersect(x, y)` except names and class of `x` are maintained.
#'
#' @export
`%set%` <- function(x, y) {
  x[x %in% y]
}

#' @describeIn grapes
#'   Subset values in `x` *not* in `y`. Alias for `x[!x %in% y]`.
#'   Similar to `setdiff(x, y)` except names and class of `x` are maintained.
#'
#' @export
`%!set%` <- function(x, y) {
  x[!x %in% y]
}

#' @describeIn grapes
#'   Extracts the `ith` element for each of `n` elements of
#'   a list or data frame, returning either a vector of length `n` or a single
#'   row data frame with `n` columns. Efficient alias for `purrr::map_*(x, y)`.
#'
#' @export
`%[[%` <- function(x, y) {
  stopifnot(typeof(x) == "list")
  if ( inherits(x, "data.frame") ) {
    x[y, ]
  } else {
    vals <- vapply(x, typeof, "")
    stopifnot(length(unique(vals)) == 1L)  # ensure type stable; no coercion
    unlist(lapply(x, `[[`, i = y))
  }
}

# non-exported:
#   this infix allows you to `borrow`
#   non-exported functions from  a package but
#   avoids the CMD check warning regarding ':::'
`%:::%` <- function(p, f) {
  get(f, envir = asNamespace(p))
}
