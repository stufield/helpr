#' Open File Interactively
#'
#' Opens a text file in an `RStudio` interactive session. Must be using
#' `RStudio` interactively. Similar to `rstudioapi::navigateToFile()` but
#' without the added dependency.
#'
#' @param file A path to a file.
#' @return The file path, invisibly.
#' @export
openR <- function(file) {
  if ( !(identical(.Platform$GUI, "RStudio") && interactive()) ) {
    stop(
     "Must be in an interactive RStudio session to use `openInteractive()`.",
      call. = FALSE
    )
  }
  file  <- normalizePath(file, mustWork = TRUE)
  .open <- get(".rs.api.navigateToFile", "tools:rstudio")
  .open(file)
  invisible(file)
}
