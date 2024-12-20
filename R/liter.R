#' List Iteration
#'
#' [piter()] iterates over an arbitrary number of
#'   list elements evaluating identically indexed
#'   components and is an analogue to [purrr::pmap()]
#'   without loading the \pkg{purrr} namespace.
#'   [liter()] is a thin wrapper around [mapply()] intended
#'   specifically for *paired* `.x` and `.y` values
#'   (similar to [purrr::map2()]).
#'   If `.y` is missing and `.x` is named,
#'   this is equal to `liter(.x, names(.x), ...)`,
#'   which is the behavior of [purrr::imap()].
#'   Both [piter()] and [liter()] support the
#'   formula construction (`~`).
#'
#' @param .x,.y Vectors or objects of the same length.
#' @param .l A *named* list of elements, each to iterate over. Must
#'   have the same length. Also supports a data frame, whose
#'   rows will iterate over using names as parameters.
#' @param .f A function to be applied to each element of `x`.
#' @param ... Additional arguments passed to `.f`.
#'
#' @return Both functions always return a list, sometimes named
#'   if possible by rules similar to [sapply()].
#'
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
#' v <- rnorm(6)
#' liter(1:6, v, function(a, b) a + b^2) |> unlist()
#'
#' # if .y is explicit; formula syntax
#' # must use `.x` and `.y` in formula
#' liter(1:6, v, ~ .x + .y^2) |> unlist()
#'
#' @export
liter <- function(.x, .y = NULL, .f, ...) {
  .y <- .y %||% names(.x) %||% seq_along(.x) # 1st try .x names; then go by index
  stopifnot(
    "Lengths of `.x` and `.y` must be equal." = length(.x) == length(.y),
    "`.f` must be a function or formula." = is.function(.f) || inherits(.f, "formula")
  )
  mapply(.x, .y, FUN = .get_mapper(.f, c(".x", ".y")), MoreArgs = ...,
         USE.NAMES = TRUE, SIMPLIFY = FALSE)
}

#' @describeIn liter
#'   [piter()] iterates over a *named* list of identical lengths.
#' @examples
#' piter(list(a = head(LETTERS), b = head(letters)), function(a, b) paste0(a, b)) |>
#'   unlist()
#'
#' # supports ~formula syntax
#' piter(list(a = head(LETTERS), b = head(letters)), ~ paste0(a, b)) |> unlist()
#'
#' # supports data frames
#' df <- data.frame(a = head(LETTERS), b = rev(tail(letters)))
#' piter(df, ~ paste0(a, b)) |> unlist()
#' @export
piter <- function(.l, .f, ...) {
  if ( is.data.frame(.l) ) {
    .l <- as.list(.l)
  }
  stopifnot(
    "`.l` must be a list." = is.list(.l),
    "`.l` must be a *named* list." = !is.null(names(.l))
  )
  if ( !rep_lgl(lengths(.l)) ) {
    stop("All elements of `.l` must be of equal length.", call. = FALSE)
  }

  dots <- dots_list2(...)
  fun  <- .get_mapper(.f, names(.l))
  out  <- .mapply(dots = .l, FUN = fun, MoreArgs = dots)
  nms1 <- names(.l[[1L]])
  if ( is.null(nms1) && is.character(.l[[1L]]) ) {
    nms2 <- if ( length(out) ) .l[[1L]] else character(0)
    names(out) <- nms2
  } else if ( !is.null(nms1) ) {
    names(out) <- nms1
  }
  out
}

.get_mapper <- function(f, params) {
  if ( inherits(f, "formula") ) {
    as.function(
      c(setNames(replicate(length(params), substitute()), params), f[[2L]])
    )
  } else {
    f
  }
}
