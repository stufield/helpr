#' File System Utilities
#'
#' Generalized file system utilities and operations customized for
#' data structures.
#' It was heavily influenced by the
#' \pkg{fs} package: \url{https://github.com/r-lib/fs}.
#'
#' @name filesystem
#'
#' @param file,x,dir A file-system location, directory, or path.
#'   Vectorized paths are allowed where possible.
NULL


#' @describeIn filesystem
#'   Construct a path to a file.
#'
#' @param ext,value An optional extension to append to the generated path.
#' @param ... Character vectors to construct paths, `length == 1`
#'   values are recycled as appropriate too complete pasting.
#'   Alternatively, arguments passed to [dir()] (for [ls_dir()]).
#'
#' @examples
#' # paths
#' mv_path("foo", "bar", "baz")    # no ext
#'
#' mv_path("foo", "bar", "baz", ext = "zip")  # ext
#'
#' mv_path("foo", letters[1:3], ext = "txt")  # recycled args
#'
#' @export
mv_path <- function(..., ext = "") {
  args <- list(...)
  stopifnot(
    "All '...' must be character." = all(vapply(args, is.character, NA))
  )
  args$sep <- .Platform$file.sep
  res <- do.call(paste, args)
  res <- ifelse(grepl("NA", res), NA_character_, res)  # put back NAs after paste
  if ( !missing(ext) ) {
    set_file_ext(res, ext)
  } else {
    as_mv_path(res)
  }
}

#' @noRd
#' @export
print.mv_path <- function(x, ..., max = getOption("max.print")) {
  x <- x[seq_len(min(length(x), max))]
  if ( length(x) == 0L ) {
    print(character(0))
  }
  cat(multicol(colorize_paths(x)), sep = "")
  invisible(x)
}

#' @describeIn filesystem
#'   Coerce to a `mv_path` object.
#'
#' @export
as_mv_path <- function(x) {
  x <- enc2utf8(as.character(x))
  x <- gsub("/+", "/", x)   # nuke duplicate slashes
  names(x) <- x
  structure(x, class = c("mv_path", "character"))
}

#' @noRd
#' @export
`+.mv_path` <- function(e1, e2) {
  e1 <- path.expand(e1)
  x <- paste0(e1, "/", e2)
  as_mv_path(x)
}

#' @noRd
#' @export
`/.mv_path` <- function(e1, e2) {
  e1 <- path.expand(e1)
  x <- paste0(e1, "/", e2)
  as_mv_path(x)
}

#' @noRd
#' @export
`[.mv_path` <- function(x, i, ...) {
  as_mv_path(NextMethod("["))
}

#' @noRd
#' @export
`[[.mv_path` <- function(x, i, ...) {
  as_mv_path(NextMethod("["))
}

pillar_shaft.mv_path <- function(x, ..., min_width = 15) {
  pillar::new_pillar_shaft_simple(colorize_paths(x), ..., min_width = min_width)
}



#' @describeIn filesystem
#'   Test if location is a directory.
#'
#' @examples
#' # directories
#' ls_dir()
#'
#' is.dir(ls_dir())
#'
#' info_dir()
#'
#' @export
is.dir <- function(x) {
  info <- file.info(x, extra_cols = FALSE)
  res  <- !is.na(info$isdir) & info$isdir
  names(res) <- x
  res
}

#' @describeIn filesystem
#'   List the directory contents.
#'
#' @param regexp A regular expression, e.g. "`[.]csv$`", see the `pattern`
#'   argument to [dir()]. Files are collated according to `"C"` locale rules,
#'   so that they are ordered consistently with [fs::dir_ls()].
#'
#' @param all If `TRUE` hidden files are also returned.
#' @export
ls_dir <- function(dir = ".", regexp = NULL, all = FALSE, ...) {
  withr::local_collate("C")
  dir(
    path.expand(dir),
    pattern = regexp,
    all.files = all,
    full.names = dir != ".",   # consistent with `fs`
    include.dirs = TRUE,
    no.. = TRUE, ...
  ) |> as_mv_path()
}

#' @describeIn filesystem
#'   Lists the directory contents similar to `ls -l`.
#'
#' @export
info_dir <- function(dir = ".", ...) {
  x <- ls_dir(dir, ...)
  if ( length(x) == 0L ) {
    return(character(0))
  }
  tbl <- file.info(x)[, c("size", "isdir", "mode", "ctime",
                          "mtime", "atime", "uname", "grname")]
  names(tbl) <- c("size", "isdir", "permissions", "changed", "modified",
                  "accessed", "user", "group")
  tbl <- rn2col(tbl, "path")
  tbl$path <- as_mv_path(tbl$path)   # use S3 print
  tbl$size <- as_mv_bytes(tbl$size)  # use S3 print
  tbl$type <- ifelse(tbl$isdir, "directory", "file")
  tbl$type[Sys.readlink(x) != ""] <- "symlink"
  tbl$permissions <- as_symperm(tbl$permissions)
  tbl <- tbl[, c("path", "type", "size", "permissions", "modified",
                 "user", "group", "changed", "accessed")]
  tibble::as_tibble(tbl)
}


#' @describeIn filesystem
#'   Extracts the file extension from a file path.
#'
#' @examples
#' # extensions
#' file_ext("foo.txt")
#'
#' rm_file_ext("foo/bar.txt")
#'
#' set_file_ext("foo/bar.csv", "tsv")
#' set_file_ext(c("foo.txt", NA, "bar.csv"), "R")   # NAs unchanged & 'R' recycled
#'
#' x <- "foo.txt"
#' file_ext(x) <- "csv"
#' x
#' @export
file_ext <- function(file) {
  if ( length(file) == 0L ) {
    return(character(0))
  }
  ext <- capture(file, "(?<!^|[.]|/)[.]([^.]+)$")[[1L]]
  ifelse(is.na(ext), "", ext)
}

#' @describeIn filesystem
#'   Replaces an existing extension. See [set_file_ext()].
#'
#' @export
`file_ext<-` <- function(file, value) {
  set_file_ext(file, value)
}

#' @describeIn filesystem
#'   Removes the file extension from a file path.
#'
#' @export
rm_file_ext <- function(file) {
  file <- sub("[.](gz|bz2|xz)$", "", file)
  sub("([^.]+)\\.[[:alnum:]]+$", "\\1", file)
}

#' @describeIn filesystem
#'   Replaces the existing file extension with `ext`.
#'   Extensions of `length == 1` are recycled.
#'
#' @export
set_file_ext <- function(file, ext) {
  stopifnot(is.character(ext), !is.na(ext))
  if ( length(ext) > 1L && length(file) != length(ext) ) {
    stop(
      "The `ext` length must match the number of files provided. ",
      value(length(file)), " != ", value(length(ext)), ".", call. = FALSE
    )
  }
  if ( typeof(file) == "list" ) file <- unlist(file)
  file <- rm_file_ext(file)
  ext  <- sub("[.]", "", ext)
  add  <- !is.na(file) & nzchar(ext)
  ext  <- ifelse(add, ext, "")
  dot  <- ifelse(add, ".", "")
  res  <- paste0(file, dot, ext)
  res[is.na(file)] <- NA_character_    # put NAs back
  as_mv_path(res)
}



# Bytes ----
units <- c("B" = 1, "K" = 1024, "M" = 1024^2, "G" = 1024^3, "T" = 1024^4,
           "P" = 1024^5, "E" = 1024^6, "Z" = 1024^7, "Y" = 1024^8)

#' @describeIn filesystem
#'   Coerce to a `mv_bytes` object.
#'
#' @export
as_mv_bytes <- function(x) {
  x <- as.numeric(x)
  structure(x, class = c("mv_bytes", "numeric"))
}

#' @export
format.mv_bytes <- function(x, scientific = FALSE, digits = 3,
                            drop0trailing = TRUE, ...) {
  bytes <- unclass(x)
  exponent <- pmin(floor(log(bytes, 1024)), length(units) - 1L)
  res  <- round(bytes / 1024^exponent, 2)
  unit <- ifelse(exponent == 0, "B", names(units)[exponent + 1])

  # Zero bytes
  res[bytes == 0]  <- 0
  unit[bytes == 0] <- ""

  # NA and NaN bytes
  res[is.na(bytes)]  <- NA_real_
  res[is.nan(bytes)] <- NaN
  unit[is.na(bytes)] <- ""            # Includes NaN as well

  res <- format(res, scientific = scientific, digits = digits,
                drop0trailing = drop0trailing, ...)
  res <- paste0(res, unit)
  colormap <- function(.x) {
    switch(.x, K = "\033[01;34m", M = "\033[01;31m", G = "\033[01;35m",
               "T" = "\033[01;32m", P = "\033[01;36m", "")
  }
  colors <- vapply(unit, colormap, "", USE.NAMES = FALSE)
  close  <- ifelse(colors == "", "", "\033[0m")
  paste0(colors, res, close)
}

#' @export
print.mv_bytes <- function(x, ...) {
  y <- format.mv_bytes(x)
  cat(y, "\n")
  invisible(x)
}

#' @export
sum.mv_bytes <- function(x, ...) {
  as_mv_bytes(NextMethod())
}

#' @export
min.mv_bytes <- function(x, ...) {
  as_mv_bytes(NextMethod())
}

#' @export
max.mv_bytes <- function(x, ...) {
  as_mv_bytes(NextMethod())
}

#' @export
`[.mv_bytes` <- function(x, i, ...) {
  as_mv_bytes(NextMethod("["))
}

#' @export
`[[.mv_bytes` <- function(x, i, ...) {
  as_mv_bytes(NextMethod("[["))
}

pillar_shaft.mv_bytes <- function(x, ...) {
  pillar::new_pillar_shaft_simple(format.mv_bytes(x), align = "right", ...)
}


# file utils ----

# From gaborcsardi/crayon/R/utils.r
multicol <- function(x) {
  if ( length(x) == 0L ) {
    return(character(0))
  }
  xs <- vapply(x, rm_style, "", USE.NAMES = FALSE)
  max_len <- max(nchar(xs, keepNA = FALSE)) + 1
  screen_width <- getOption("width")
  num_cols <- min(length(x), max(trunc(screen_width / max_len), 1L))
  if ( num_cols > 1 ) {
    pad <- max_len - nchar(xs, keepNA = FALSE)
    x   <- paste0(x, strrep(" ", pad))
  }
  num_rows <- ceiling(length(x) / num_cols)
  x  <- c(x, rep("", num_cols * num_rows - length(x)))
  xm <- matrix(x, ncol = num_cols, byrow = TRUE)
  paste0(apply(xm, 1, paste0, collapse = ""), "\n")
}

# x = a triplet of codes in octal format, e.g. "755", see [file.mode()]
# convert to symbol permissions
as_symperm <- function(x) {
  y <- sprintf("%o", as.octmode(x))
  y <- substr(y, nchar(y) - 2L, nchar(y))
  y <- strsplit(y, "")
  res <- lapply(y, function(.m) vapply(.m, oct2sym, ""))
  unlist(lapply(res, paste, collapse = ""))
}

# s = a single element of the file permissions; e.g. "6"
oct2sym <- function(s) {
  stopifnot(s >= 0 && s <= 7)
  s <- as.character(s)
  switch(s, "0" = "---", "1" = "--x", "2" = "-w-", "3" = "-wx",
         "4" = "r--", "5" = "r-x", "6" = "rw-", "7" = "rwx")
}

# Add color a vector of paths
colorize_paths <- function(paths) {
  ext    <- file_ext(basename(paths))
  green  <- "\033[32m"
  red    <- "\033[01;31m"
  yellow <- "\033[33m"
  blue   <- "\033[01;34m"
  cyan   <- "\033[01;36m"
  magenta  <- "\033[01;35m"
  colormap <- c(ADat = red, adat = red, zip = red, sh = red,
                bz = red, gz = red, png = blue, jpeg = blue, tiff = blue,
                py = yellow, json = yellow,
                R = green, Rmd = green, md = green, yml = green)
  colors <- colormap[ext]
  colors[is.na(colors)] <- ""
  colors[grepl("^\\.", paths)] <- magenta     # do this first
  colors[is.dir(paths)]        <- blue
  colors[Sys.readlink(paths) != ""] <- cyan   # do this last
  close <- ifelse(colors == "", "", "\033[0m")
  paste0(colors, paths, close)
}
