#' Standardize Date Format
#'
#' A convenient wrapper to print the current date in a
#'   consistent format for all package suite functionality.
#'
#' @param x An alternative format to the standard format.
#'
#' @return The current date in `YYYY-MM-DD` format (default).
#' @seealso [format()]
#'
#' @examples
#' # with default format
#' dater()
#'
#' # pass alternative format
#' dater("%Y-%m-%d || %H:%M:%S")
#' @export
dater <- function(x = "%Y-%m-%d") {
  format(Sys.time(), x)
}
