#' Create a Jagged Tibble
#'
#' Combine a list of uneven (jagged) vectors into
#'   one 2-dim object, `tibble` or `data frame`,
#'   and fill in lengths with `NA`.
#'
#' @param x A *named* list of vectors with unequal lengths, to be
#'   recast as a `tibble`.
#'
#' @return A `tibble` object with dimensions
#'   `c(max(lengths(x)), length(x))`. Extra entries are
#'    replaced with `NA`.
#'
#' @author Stu Field
#'
#' @examples
#' p <- 5   # cols
#' n <- 10  # rows
#' x <- replicate(p, sample(1:1000, sample(1:n, 1))) |>
#'   set_Names(paste0("v", seq(p)))
#'
#' tbl <- jagged_tbl(x)
#' tbl
#' @export
jagged_tbl <- function(x) {

  if ( is.null(names(x)) ) {
    stop(
      "Names of `x` can't be empty. Please provide names.",
      call. = FALSE
    )
  }

  tibble::as_tibble(lapply(x, "length<-", max(lengths(x))))
}
