#' Cross Tabulate Counts
#'
#' Create a contingency table of counts generated
#'   by cross-classifying factors from groups
#'   splitting on the values passed in the `...` argument.
#'   The sums of each row and column are added to the result.
#'
#' @param x A `data.frame` (-like) object containing the
#'   data variables from which counts are desired.
#' @param ... A number of unquoted expressions or quoted strings
#'   separated by commas. Generally greater than 3 is not useful.
#' @param useNA See [table()].
#'
#' @return A table of grouped counts based on splitting
#'   variables with sums from each factor.
#'
#' @author Stu Field
#' @seealso [table()], [addmargins()]
#'
#' @examples
#' # 1 factor
#' cross_tab(mtcars, cyl)
#'
#' # quoted string
#' cross_tab(mtcars, "cyl")
#'
#' # with external variable
#' var <- "cyl"
#' cross_tab(mtcars, var)
#'
#' # 2 factors
#' cross_tab(mtcars, cyl, gear)
#'
#' cross_tab(mtcars, "cyl", "gear")
#'
#' cross_tab(mtcars, c("cyl", "gear"))
#'
#' # 3 factors
#' cross_tab(mtcars, cyl, gear, am)
#' @importFrom stats addmargins
#' @export
cross_tab <- function(x, ..., useNA = "ifany") {
  dot_vars <- tryCatch(unlist(list(...)), error = function(e) NULL)
  if ( is.null(dot_vars) ) {
    dot_vars <- as.character(match.call(expand.dots = FALSE)$...)
  }
  stopifnot(
    "All '...' variables must be in 'x'." = all(dot_vars %in% names(x))
  )
  table(x[, dot_vars, drop = FALSE],
        dnn = as.list(dot_vars),
        useNA = useNA) |>
    stats::addmargins()
}
