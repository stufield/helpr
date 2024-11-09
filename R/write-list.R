#' Write List to CSV File
#'
#' Write a list of data frames of vectors (or a mixture
#'   of both) to a single `*.csv` file.
#'
#' @inheritParams utils::write.table
#'
#' @param x A list to be written to file,
#'   typically a list of data frames.
#' @param rn_title A title for the row names
#'   column (for data frames).
#'   Must match the length of the `x` argument.
#' @param ... Additional arguments passed to [write.table()].
#'
#' @return The `file`, invisibly.
#' @author Stu Field
#' @seealso [write.table()], [file()]
#'
#' @examples
#' tmp <- lapply(LETTERS[1:5], function(x) rnorm(10, mean = 10, sd = 3))
#' names(tmp) <- LETTERS[1:5]
#' write_list(tmp, file = tempfile(fileext = ".csv"))
#'
#' # with a data frame in list
#' tmp$mtcars <- head(mtcars, 10)
#' write_list(tmp, file = tempfile(fileext = ".csv"))
#' @importFrom utils write.table
#' @export
write_list <- function(x, file, rn_title = NULL, append = FALSE, ...) {

  withr::local_options(list(warn = -1))   # turn off warnings

  if ( is.null(names(x)) ) {
    stop(
      "The `x` argument must be a named list for at least one entry.",
      call. = FALSE
    )
  }

  if ( is.null(rn_title) ) {
    rn_title <- rep("", length(x))
  } else if ( length(rn_title) != length(x) &&
              any(vapply(x, inherits, what = "data.frame", NA)) ) {
    stop(
      "Length of `rn_title =` argument (", value(length(rn_title)),
      ") *must* be identical to length of `x` (", value(length(x)), ")."
    )
  }

  f <- file(file, open = ifelse(append, "at", "wt"))
  on.exit(close(f))

  add <- seq_along(x) > 1L

  .f <- function(.x, .name, .add, .title) {
    is_vec <- typeof(.x) %in% c("logical", "double", "character", "integer") &&
      is.null(dim(.x))     # if a vector
    .append <- (append || .add)
    if ( is_vec ) {
      if ( length(.x) == 0L ) {
        cat(sprintf("\n%s,", .name), file = f,
            append = .append, sep = "")
        cat(NA, file = f, append = TRUE, sep = "\n")
      } else {
        nm <- names(.x)
        .x <- data.frame(as.list(.x))
        names(.x) <- nm
        cat(sprintf("\n%s,", .name), file = f,
            append = .append, sep = "")
        write.table(.x, file = f, append = TRUE, sep = ",",
                    col.names = !is.null(nm), row.names = FALSE, ...)
      }
    } else {   # if df/matrix/tibble
      cat(sprintf("\n%s,\n%s,", .name, .title), file = f,
          append = .append, sep = "")
      write.table(.x, file = f, append = TRUE, sep = ",",
                  col.names = TRUE, row.names = TRUE, ...)
    }
  }
  mapply(.f, x, names(x), add, rn_title)
  signal_done("Writing", value(deparse(substitute(x))), "to:", value(file))
  invisible(file)
}
