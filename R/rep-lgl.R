#' All Values Same
#'
#' Returns a logical as to whether all values *within* a vector
#' are identical. This function does NOT compare two independent
#' vectors. Please use `isTRUE(all.equal())` for such comparisons.
#'
#' @param x A vector of values. Can be one of the following objects
#'   classes: `numeric`, `character`, `factor`, or `logical`.
#'   If the vector is of type `double` and NA values are present,
#'   they will be removed.
#' @return Logical.
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


#' S3 rep_lgl method for numeric
#'
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

#' S3 rep_lgl method for character
#'
#' @noRd
#' @export
rep_lgl.character <- function(x) {
  isTRUE(all(vapply(x, function(.i) .i == x[1L], NA)))
}

#' S3 rep_lgl method for factor
#'
#' @noRd
#' @export
rep_lgl.factor <- function(x) {
  rep_lgl(as.character(x))
}

#' S3 rep_lgl method for logical
#'
#' @noRd
#' @export
rep_lgl.logical <- function(x) {
  rep_lgl(as.numeric(x))
}
