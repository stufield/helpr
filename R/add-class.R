#' Add a Class to an Object
#'
#' Utility to *prepend* a new class(es) to existing objects.
#'
#' @param x The object to receive new class(es).
#' @param class `character(n)`. The name of additional class(es).
#'
#' @return An object with new classes.
#' @author Stu Field
#'
#' @seealso [class()], [typeof()], [structure()]
#' @examples
#' class(iris)
#'
#' add_class(iris, "new") |> class()
#'
#' add_class(iris, c("A", "B")) |> class()    # 2 classes
#'
#' add_class(iris, c("A", "data.frame")) |> class()    # no duplicates
#'
#' add_class(iris, c("data.frame", "A")) |> class()    # re-orders if exists
#' @export
add_class <- function(x, class) {
  if ( is.null(class) ) {
    warning("Passing `class = NULL` leaves class(x) unchanged.",
            call. = FALSE)
  }
  if ( any(is.na(class)) ) {
    stop("The `class` param cannot contain `NA`: ", value(class),
         call. = FALSE)
  }
  new_class <- union(class, class(x))
  structure(x, class = new_class)
}
