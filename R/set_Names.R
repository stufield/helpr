#' Set Names of an Object
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Similar to [stats::setNames()], but with more features.
#' You can specify names in the following ways:
#'   * a character vector (recycled if `length(nms) != length(x)`)
#'   * a function to be applied to names of `x`
#'   * via `...` if not passing a function, `c(nms, ...)`
#'
#' @param x The object to name.
#' @param nms The names to apply to `x`. Recycled as necessary.
#' @param ... Arguments passed to `nms` if a function.
#' @examples
#' set_Names(head(letters), head(LETTERS)) # apply names
#'
#' set_Names(head(letters))                # names self
#'
#' set_Names(head(letters), toupper)       # apply fn
#'
#' set_Names(set_Names(head(letters)), NULL)     # NULL always removes names
#'
#' set_Names(head(letters), "foo")               # repeat to length
#'
#' set_Names(head(letters), c("foo", "bar"))     # repeat to length
#'
#' set_Names(head(letters), "foo", "bar", "baz") # repeat to length via `...`
#' @export
set_Names <- function(x, nms = x, ...) {

  if ( is.null(nms) ) {
    return(structure(x, names = NULL))
  }

  if ( is.function(nms) ) {
    nms <- nms(names(x) %||% x, ...)
  } else {
    nms  <- as.character(nms)
    dots <- list(...)
    if ( length(dots) > 0L ) {
      nms <- c(nms, unlist(dots, use.names = FALSE))
    }
  }

  if (  length(nms) != length(x) ) {
    nms <- rep_len(nms, length(x))
  }
  structure(x, names = nms)
}
