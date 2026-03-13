#' Cross Tabulate Counts
#'
#' Create a contingency table of counts generated
#'   by cross-classifying factors from groups
#'   splitting on the values passed in the `...` argument.
#'   A thin wrapper around [table()] but with simplifying
#'   features. The sums of each row and column are added to the result.
#'
#' @param data A `data.frame` (-like) object containing the
#'   data variables from which counts are desired.
#' @param ... A number (1 to 2) unquoted strings separated by commas.
#'   Greater than 2 is generally not useful. Or additional
#'   parameters passed to [table()].
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
#' # 2 factors
#' cross_tab(mtcars, cyl, gear)
#'
#' \dontrun{
#'   # No quoted strings (!)
#'   cross_tab(mtcars, "cyl")
#'
#'   # No external variable (!)
#'   var <- "cyl"
#'   cross_tab(mtcars, var)
#' }
#' @importFrom stats addmargins
#' @export
cross_tab <- function(data, ..., useNA = "ifany") {
  lgl <- tryCatch(list(...), error = function(e) NULL)
  if ( !is.null(lgl) ) {
    stop("Must pass naked strings to `cross_tab()`, not ",
         value(lgl), ".", call. = FALSE)
  }
  table2 <- be_hard(table, useNA = useNA)
  expr   <- substitute(table2(...))
  with(data, eval(expr)) |> addmargins()
}
