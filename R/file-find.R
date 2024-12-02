#' Determine Path to File
#'
#' Determine the path of a defined file via brute force search of
#'   (optionally) the root directory.
#'
#' @rdname filesystem
#'
#' @param pattern `character(1)`. The pattern as a regex.
#' @param root The path of the root directory to start
#'   the highest level search.
#'
#' @return The path(s) containing the regular expression
#'   specified in `pattern`.
#'
#' @examples
#'
#' # wrapper around `ls_dir()`
#' \dontrun{
#'   file_find("Makefile", ".")
#'   file.create("myfile.txt")
#'   file_find("myfile.txt", "..")
#'   unlink("myfile.txt", force = TRUE)
#' }
#' @export
file_find <- function(pattern, root = Sys.getenv("HOME")) {
  ls_dir(root, regexp = pattern, recursive = TRUE)
}
