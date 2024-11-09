#' All Values Same
#'
#' Returns a boolean testing if all values of a vector
#'   are identical. This function does NOT compare two independent
#'   vectors. Use `isTRUE(all.equal())` for such comparisons.
#'
#' @param x A vector of values. Can be one of:
#'   `numeric`, `character`, `factor`, or `logical`.
#'   If the vector is type `double` and NA values are present,
#'   they are first removed.
#' @return `logical(1)`.
#' @author Stu Field
#' @seealso [rep()], [isTRUE()], [all.equal()]
#' @examples
#' rep_lgl(1:4)
#'
#' rep_lgl(rep(5, 10))
#'
#' rep_lgl(rep("A", 10))
#'
#' rep_lgl(letters)
#'
#' rep_lgl(c(TRUE, TRUE, TRUE))
#'
#' rep_lgl(c(TRUE, TRUE, FALSE))
#' @export
rep_lgl <- function(x) UseMethod("rep_lgl")


#' @noRd
#' @export
rep_lgl.numeric <- function(x) {
  if ( all(floor(x) == x, na.rm = TRUE) ) {
    # if integer
    isTRUE(diff(range(x, na.rm = TRUE)) == 0)
  } else {
    # if double
    isTRUE(diff(range(x, na.rm = TRUE)) < .Machine$double.eps^0.5)
  }
}

#' @noRd
#' @export
rep_lgl.character <- function(x) {
  isTRUE(all(vapply(x, function(.i) .i == x[1L], NA)))
}

#' @noRd
#' @export
rep_lgl.factor <- function(x) {
  rep_lgl(as.character(x))
}

#' @noRd
#' @export
rep_lgl.logical <- function(x) {
  rep_lgl(as.numeric(x))
}
