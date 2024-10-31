#' Diff Two Vectors
#'
#' A convenient diff tool to determine
#' how and where two character vectors differ.
#'
#' @param x First vector to compare.
#' @param y Second vector to compare.
#' @param verbose Should diff summary be printed directly to the console?
#'   Is `TRUE` for interactive sessions.
#' @return An invisible list is returned with the set diffs of each vector.
#'   The elements of the list are:
#'   \item{unique_x:}{Entries unique to the `x` vector.}
#'   \item{unique_y:}{Entries unique to the `y` vector.}
#'   \item{inter:}{The intersect of the two vectors.}
#'   \item{unique:}{All unique entries of the union of the two vectors.}
#' @author Stu Field
#' @seealso [setdiff()], [union()], [intersect()]
#' @examples
#' diff_vecs(LETTERS[1:10], LETTERS[5:15])
#'
#' diffs <- diff_vecs(LETTERS[1:10], LETTERS[5:15], verbose = FALSE)
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
    writeLines( "Vectors differ by:")
    left <- format(
      c(paste0("Unique to ", xname),
        paste0("Unique to ", yname),
        "Common Intersect", "Union")
    )
    right <- lengths(list(x_y_diff, y_x_diff, xy_inter, xy_union))
    writeLines(paste("  ", left, add_color(">>", "red"), right))
  }

  ret <- list(x_y_diff, y_x_diff, xy_inter, xy_union)
  names(ret) <- c(paste0("unique_", c(xname, yname)), "inter", "unique")
  invisible(ret)
}
