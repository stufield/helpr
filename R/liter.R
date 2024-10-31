#' List Iteration
#'
#' A thin wrapper around [mapply()] that iterates over *paired* `.x` and `.y`
#' values. They *must* have the same length elements but can be any
#' R object to iterate over. Similar to [purrr::map2()] without having to
#' import the \pkg{purrr} package.
#' If `.y` is missing and `.x` is named, this is equal to
#' `liter(.x, names(.x), ...)`, which is equal to [purrr::imap()].
#'
#' @param .x,.y Vectors or objects of the same length.
#' @param .f A function to map values over.
#' @param ... Additional arguments passed on to the mapped function.
#' @return Always returns a list. The returned list is named by the
#' names of `.x` or by `.x` itself if possible.
#' @examples
#' x <- LETTERS
#' names(x) <- letters
#' liter(x, 1:26, paste, sep = "-") |> head()
#'
#' # .y = NULL; uses names(.x)
#' liter(x, .f = paste, sep = "-") |> head()
#'
#' # .y = index 1:3
#' liter(c("a", "b" , "c"), .f = paste, sep = "=")
#'
#' # anonymous on-the-fly .f()
#' liter(1:6, rnorm(6), function(.x, .y) .x + .y^2) |> unlist()
#' @export
liter <- function(.x, .y = NULL, .f, ...) {
  .y <- .y %||% names(.x) %||% seq_along(.x) # 1st try .x names; then go by index
  stopifnot(
    "Lengths of `.x` and `.y` must be equal." = length(.x) == length(.y),
    "`.f` must be a function."                = is.function(.f)
  )
  mapply(.x, .y, FUN = .f, MoreArgs = ..., USE.NAMES = TRUE, SIMPLIFY = FALSE)
}
