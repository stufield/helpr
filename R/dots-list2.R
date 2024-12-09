#' Dynamic List Param Collection Rename Elements of a List
#'
#' Helper to collect the `...` params internally
#'   passed that support non-standard evaluation
#'   and splicing. See `rlang::dots_list()`
#'   and `rlang::list2()`.
#'   In general this is a stripped down version
#'   to avoid the `rlang` import keeping the
#'   package footprint minimal.
#'
#' @param ... Arguments to collect in a list.
#'   These arguments are dynamic
#'
#' @return A named list corresponding to the
#'   expressions passed to the `...` inputs.
#'
#' @examples
#' foo <- function(...) {
#'   print(dots_list2(...))
#'   invisible()
#' }
#' foo(a = 2, b = 4)
#'
#' foo(a = 2, b = 4, fun = function(x) mean(x))
#'
#' foo(data.frame(a = 1, b = 2), data.frame(a = 8, b = 4))
#'
#' # supports !!! splicing
#' args <- list(a = 2, b = 4, fun = function(x) mean(x))
#' foo(!!!args)
#' @export
dots_list2 <- function(...) {
  x <- deparse(substitute(...))
  env <- parent.frame(n = 2)
  tryCatch(list(...), error = function(e) splice_dots(x, env))
}

splice_dots <- function(x, env) {
  lang <- str2lang(sub("^[!]{,3}", "", x))  # strip leading !!!
  eval(lang, envir = env)
}
