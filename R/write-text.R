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
#'
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
#'
#' @inheritParams base::readLines
#'
#' @export
read_text <- function(path, n = -1L) {
  base::readLines(path, n = n, encoding = "UTF-8", warn = FALSE)
}

#' @describeIn write_text
#'   write a data frame to a *LaTeX* table.
#'
#' @inheritParams rownames
#'
#' @param append `logical(1)`. See [write.table()].
#'
#' @param include_rn `logical(1)`. Should row names
#'   of `data` be included?
#'
#' @param rn_label If row names are to be included,
#'   the title for that column.
#'
#' @param caption A possible caption for the table in *LaTeX*.
#'
#' @param long `logical(1)`. Should the table be written
#'   in long format. Better for very long tables.
#'
#' @param ... Arguments passed to [write.table()].
#'
#' @export
write_latex_tbl <- function(data, path, append = FALSE, include_rn = TRUE,
                            rn_label = "", caption = NULL, long = FALSE,  ...) {

  stopifnot(is.data.frame(data))
  withr::local_output_sink(path, append = append)

  table <- ifelse(long, "longtable", "tabular")

  data <- data |>
    set_Names(gsub, pattern = "_", replacement = "\\_", fixed = TRUE)
  data <- data |>
    set_rn(gsub("_", "\\_", rownames(data), fixed = TRUE))

  if ( include_rn ) {
    cols <- paste0("l", strrep("c", ncol(data)))
    header <- sprintf("\\hline\n\\textbf{%s} & \\textbf{%s} \\\\\n\\hline\n",
                      rn_label, paste(names(data), collapse = "} & \\textbf{"))
  } else {
    cols <- paste0("l", strrep("c", ncol(data) - 1L))
    header <- sprintf("\\hline\n\\textbf{%s} \\\\\n\\hline\n",
                      paste(names(data), collapse = "} & \\textbf{"))
  }

  cat(sprintf("\\begin{%s}{", table), cols, "}\n", sep = "")

  if ( !is.null(caption) ) {
    sprintf("\\multicolumn{%i}{c}", nchar(cols)) |>
      paste0("\n{\\small \\textbf{\\tablename\\ ") |>
      paste0("\\thetable{} -- ", caption, "}} \\\\\n") |>
      cat()
  }

  cat(header)

  if ( long ) {
    cat("\\endfirsthead\n\n")
    sprintf("\\multicolumn{%i}{c}", nchar(cols)) |>
      paste0("\n{{\\tablename\\ \\thetable{} -- ") |>
      paste0("continued from previous page}} \\\\\n") |>
      cat()
    cat(header)
    cat("\\endhead\n\n")
  }

  for ( i in seq_len(ncol(data)) ) {
    if ( is.numeric(data[[i]]) )
      data[[i]] <- format(data[[i]], nsmall = 2L, digits = 3L,
                          scientific = abs(min(data[[i]], na.rm = TRUE)) < 0.01)
  }

  is_fct <- which(vapply(data, is.factor, NA))
  for ( i in is_fct ) {
    data[[i]] <- as.character(data[[i]])
  }

  is_chr <- which(vapply(data, is.character, NA))
  for ( i in is_chr ) {
    data[[i]] <- gsub("%", "\\\\%", data[[i]])
  }

  write.table(data, sep = " & ", quote = FALSE, col.names = FALSE,
              row.names = include_rn, eol = "\\\\\n", ...)
  cat(sprintf("\\hline\n\\end{%s}\n", table))
}
