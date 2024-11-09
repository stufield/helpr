#' Write to a Text File
#'
#' Writes as UTF-8 encoding and with `\n` line
#'   endings on UNIX systems and `\r\n` on Windows.
#'   This avoids some of the unintended side-effects of
#'   `usethis::write_over()` with R-projects.
#'
#' @inheritParams usethis::write_over
#'
#' @param overwrite `logical(1)`. If file exists, over-write it?
#' @export
write_text <- function(path, lines, overwrite = FALSE) {
  stopifnot(
    "`path` must be a character path to a file." = is.character(path),
    "`lines` must be a character of text to write." = is.character(lines),
    "`lines` must be a character of text to write." = length(lines) > 0L
  )
  path <- path.expand(path)
  if ( !overwrite && file.exists(path) ) {
    signal_oops(value(path), "already exists. Leaving as is.")
    return(invisible(FALSE))
  }
  signal_done("Writing", value(path))
  eol <- switch(tolower(.Platform$OS.type), windows = "\r\n", "\n")
  con <- file(path, open = "wb", encoding = "utf-8")
  on.exit(close(con))
  lines <- gsub("\r?\n", eol, lines)
  writeLines(enc2utf8(lines), con, sep = eol, useBytes = TRUE)
  invisible(TRUE)
}

#' @describeIn write_text
#'   a convenient wrapper to [readLines()] with default
#'   UTF-8 encoding for reading text into an R session.
#' @inheritParams base::readLines
#'
#' @export
read_text <- function(path, n = -1L) {
  base::readLines(path, n = n, encoding = "UTF-8", warn = FALSE)
}
