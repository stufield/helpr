#' Convert R Objects to a Data Frame
#'
#' Attempt to "smartly" convert an arbitrary object
#' into a `data.frame` object while keep the dimensions
#' of the same style.
#'
#' @param x Currently one of the following class objects:
#'   * `list`
#'   * `table`
#'   * `matrix`
#'   * `numeric`
#'   * `integer`
#'   * `factor`
#'   * `character`
#' @return The original object `x` converted into a `data.frame` class.
#' @author Stu Field
#' @seealso [as.data.frame()]
#' @examples
#' # Compare outputs:
#'
#' # Character
#' char <- head(letters, 10)
#' char
#'
#' as.data.frame(char)
#' convert2df(char)
#'
#' # table
#' tab <- table(sample(c("A", "B"), 30, replace = TRUE))
#' tab
#'
#' as.data.frame(tab)
#' convert2df(tab)
#'
#' # matrix
#' mat <- matrix(1:9, ncol = 3L)
#' mat
#'
#' as.data.frame(mat)
#' convert2df(mat)
#' @export
convert2df <- function(x) UseMethod("convert2df")


#' @noRd
#' @export
convert2df.default <- function(x) {
  stop(
    paste("No method available for class:", value(class(x))),
    call. = FALSE
  )
}

#' @noRd
#' @export
convert2df.data.frame <- function(x) {
  warning(
    paste("`x` is already a `data.frame`. Returning",
          value(deparse(substitute(x)))),
    call. = FALSE
  )
  x
}

#' @noRd
#' @export
convert2df.list <- function(x) {
  data.frame(x)
}

#' @noRd
#' @export
convert2df.table <- function(x) {
  if ( length(dim(x)) == 1L ) {
    convert2df(c(x))       # convert to integer with `c()`
  } else {
    convert2df(unclass(x)) # unclass >> 'matrix'
  }
}

#' @noRd
#' @export
convert2df.matrix <- function(x) {
  nms <- dimnames(x)
  structure(
    as.data.frame(x, row.names = nms[[1L]]),
    names = nms[[2L]]
  )
}

#' @noRd
#' @export
convert2df.numeric <- function(x) {
  structure(
    data.frame(as.list(x)),
    names = names(x) %||% paste0("v", seq_len(length(x)))
  )
}

#' @noRd
#' @export
convert2df.factor <- function(x) {
  structure(
    convert2df(as.character(x)),
    names  = names(x),
    levels = levels(x)
  )
}

#' @noRd
#' @export
convert2df.character <- function(x) convert2df.numeric(x)

#' @noRd
#' @export
convert2df.logical <- function(x) convert2df.numeric(x)

#' @noRd
#' @export
convert2df.integer <- function(x) convert2df.numeric(x)
