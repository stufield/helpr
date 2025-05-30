#' Diff Two Vectors
#'
#' A convenient diff tool to determine
#'   how and where two character vectors differ.
#'
#' @param x `character(n)`. First vector to compare.
#' @param y `character(n)`. Second vector to compare.
#' @param verbose `logical(1).` Should diff summary
#'   be printed directly to the console?
#'   Is `TRUE` for interactive sessions.
#'
#' @return An invisible list is returned with the set diffs of each vector.
#'   The elements of the list are:
#'   \item{unique_x:}{Entries unique to `x`.}
#'   \item{unique_y:}{Entries unique to `y`.}
#'   \item{inter:}{The intersect `x` and `y`.}
#'   \item{unique:}{The [union()] of `x` and `y`.}
#'
#' @author Stu Field
#' @seealso [setdiff()], [union()], [intersect()]
#'
#' @examples
#' diff_vecs(LETTERS[1:10L], LETTERS[5:15L])
#'
#' diffs <- diff_vecs(LETTERS[1:10L], LETTERS[5:15L], verbose = FALSE)
#' diffs
#' @export
diff_vecs <- function(x, y, verbose = interactive()) {

  x_y_diff <- setdiff(x, y)
  y_x_diff <- setdiff(y, x)
  xy_inter <- intersect(x, y)
  xy_union <- union(x, y)
  xname    <- deparse(substitute(x))
  yname    <- deparse(substitute(y))

  if ( verbose ) {
    signal_info( "Vectors differ by:")
    left <- format(
      c(paste0("Unique to ", xname),
        paste0("Unique to ", yname),
        "Common Intersect", "Union")
    )
    right <- lengths(list(x_y_diff, y_x_diff, xy_inter, xy_union))
    signal_todo(paste(left, add_style$cyan(">>"), right))
  }

  invisible(
    structure(
      list(x_y_diff, y_x_diff, xy_inter, xy_union),
      names = c(paste0("unique_", c(xname, yname)), "inter", "unique")
    )
  )
}
