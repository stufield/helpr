
#' @keywords internal package
"_PACKAGE"





.dummy <- function() { }   # nolint: brace_linter.

.onLoad <- function(...) {
  # this is to register the S3 methods for the tibble print methods
  # so that the print methods are obeyed inside tibbles
  register_s3_method("pillar", "pillar_shaft", "helpr_path")
  register_s3_method("pillar", "pillar_shaft", "helpr_bytes")

  # this is to make the active binding switch between
  # UTF-8 and ASCII symbol encodings
  `%enc%` <- function(utf, ascii) {
    if ( getOption("cli.unicode", TRUE) && l10n_info()$`UTF-8` ) {
      utf
    } else {
      ascii
    }
  }
  pkgenv <- environment(.dummy)
  makeActiveBinding(
    "symbl", function() symbol_utf8 %enc% symbol_ascii, pkgenv
  )
  invisible()
}


# this wrapper registers the methods during pkg load
# but ensures the package passes R CMD check that it can
# be installed even though pillar & testthat aren't imported
register_s3_method <- function(pkg, generic, class, fun = NULL) {
  stopifnot(is.character(pkg), length(pkg) == 1L)
  stopifnot(is.character(generic), length(generic) == 1L)
  stopifnot(is.character(class), length(class) == 1L)

  if ( is.null(fun) ) {
    fun <- get(paste0(generic, ".", class), envir = parent.frame())
  } else {
    stopifnot(is.function(fun))
  }

  if ( pkg %in% loadedNamespaces() ) {
    registerS3method(generic, class, fun, envir = asNamespace(pkg))
  }

  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, fun, envir = asNamespace(pkg))
    }
  )
}
