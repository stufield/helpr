#' Activate and Deactivate Lib Mode
#'
#' When activated, [lib_mode()] adds a new library location
#' (aka `lib.loc`) to the top of the library tree.
#' This allows you to run code in an "sandbox", without
#' interfering with the other packages you have installed previously.
#' See `vignette("lib-mode")` for more details with examples.
#'
#' @param path A directory location of an R library.
#' @seealso [.libPaths()], [withr::with_libpaths()]
#' @examples
#' \dontrun{
#'   dir.create("new-lib")
#'   lib_mode("new-lib")  # ON; activate
#'   lib_mode("new-lib")  # OFF; deactivate
#'   lib_mode("new-lib")  # ON; re-activate
#' }
#' @export
lib_mode <- local({
  .prompt <- NULL
  function(path = getOption("helpr_path")) {

    if ( is.null(path) ) {
      path <- .create_libpath()
    } else {
      stopifnot(
        "`path` must be a single path to a valid directory." =
          is_chr(path) & !is.na(path)
      )
      path <- tryCatch(
        normalizePath(path, mustWork = TRUE),
        error = function(e) stop("Please create ", value(path), call. = FALSE))
    }

    lib_paths <- lib_tree()
    on <- !(path %in% lib_paths)

    if ( on ) {   # switching ON
      if ( !is_lib(path) ) {
        warning(
          value(path), " does not appear to be a library. ",
          "Are sure you specified the correct directory?",
          call. = FALSE
        )
      }
      signal_done("Analysis mode:", add_style$green("ON"))
      signal_done("Using:", value(path))
      options(tmp_helpr_path = path)
      if ( is.null(.prompt) ) {
        .prompt <<- getOption("prompt") # nolint: undesirable_operator_linter.
      }
      options(prompt = add_style$bold("am-lib \033[31m> \033[39m"))
      libs <- utils::installed.packages(path)[, c("Package", "Version"), drop = FALSE]
      if ( nrow(libs) > 0L ) {
        .pad <- max(vapply(libs[, 1L], nchar, 1L), 1L)
        apply(libs, 1L,
              function(.x) signal_todo(pad(.x[1L], width = .pad), value(.x[2L]))
        )
      }
      .libPaths(c(path, lib_paths))
    } else {
      # switching OFF
      signal_done("Analysis mode:", add_style$red("OFF"))
      options(tmp_helpr_path = NULL)
      if ( !is.null(.prompt) ) {
        options(prompt = .prompt)
      }
      .prompt <<- NULL # nolint: undesirable_operator_linter.
      .libPaths(setdiff(lib_paths, path))
    }
  }
})

#' @describeIn lib_mode
#'   A thin wrapper around `.libPaths()` to quickly and easily
#'   view the *current* library tree of directories the session knows about.
#' @export
lib_tree <- function() {
  .libPaths()
}

#' @describeIn lib_mode
#'   Determines whether a session is *currently* in "lib mode".
#' @export
is_lib_mode <- function() {
  !is.null(getOption("tmp_helpr_path", NULL))
}

.create_libpath <- function() {
  path <- file.path("aux-lib")
  if ( !dir.exists(path) ) {
    dir.create(path, recursive = TRUE, mode = "755")
    signal_done("Creating", value(normalizePath(path)))
  }
  normalizePath(path)
}

is_lib <- function(path) {
  # empty directories can be libraries
  if ( length(dir(path)) == 0L ) return(TRUE)
  # otherwise check that the directories are compiled R directories
  #   i.e. that they contain a Meta directory
  dirs        <- dir(path, full.names = TRUE)
  dirs        <- dirs[utils::file_test("-d", dirs)]
  has_pkg_dir <- function(path) length(dir(path, pattern = "Meta")) > 0L
  help_dirs   <- vapply(dirs, has_pkg_dir, NA)
  all(help_dirs)
}
