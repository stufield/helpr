#' Unit Test Helpers
#'
#' Manage whether certain tests are skipped during
#'   [devtools::check()], [devtools::test()], or
#'   during a temporary automated pipeline builds.
#'   This may be desired if certain tests are time
#'   consuming or special environment characteristics
#'   make them undesirable.
#'   See [testthat::skip_if()] and
#'   [testthat::skip_on_cran()] for details.
#'
#' @rdname unit-help
#' @references https://testthat.r-lib.org/reference/expect_snapshot_file.html
#'
#' @param ... Arguments passed to [testthat::expect_no_error()] or
#'   the logical `gg =` param if in [expect_snapshot_plot()].
#' @param code The code to execute.
#' @param name `character(1)`. A temporary file name to use during the test.
#' @param type `character(1)`. Either "png" or "pdf".
#'
#' @export
expect_error_free <- function(...) {
  signal_info(
    "`helpr::expect_error_free()` has been superceded by",
    "testthat::expect_no_error()"
  )
  testthat::expect_no_error(...)
}

#' @rdname unit-help
#' @export
skip_on_check <- function() {
  on_check <- !identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), "")
  testthat::skip_if(on_check, "On devtools::check()")
}

#' @rdname unit-help
#' @export
skip_on_test <- function() {
  on_test <- identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), "")
  testthat::skip_if(on_test, "On devtools::test()")
}

#' @rdname unit-help
#' @export
expect_snapshot_plot <- function(code, name, type = c("png", "pdf"), ...) {
  type <- match.arg(type)
  name <- paste0(name, ".", type)
  withr::defer(unlink(name, force = TRUE))
  # Announce the file before touching `code`. This way, if `code`
  # unexpectedly fails or skips, testthat will not auto-delete the
  # corresponding snapshot file
  testthat::announce_snapshot_file(name = name)
  # Officially test in Linux, this is necessary due to
  # minor changes in plotting defaults across OSs that cause
  # snapshot testing to fail
  testthat::skip_on_os(c("mac", "windows"))
  path <- save_fig(code, type, ...)
  testthat::expect_snapshot_file(path, name)
}

#' @importFrom grDevices png dev.off
#' @noRd
save_fig <- function(code, type, gg = TRUE) {
  device <- switch(type, png = grDevices::png, pdf = grDevices::pdf)
  hw <- ifelse(type == "png", 480, 5)
  path <- tempfile(fileext = ".png")
  device(path, height = hw, width = hw)   # square plot
  withr::defer(dev.off())
  if ( gg ) {
    print(force(code))
  } else {
    force(code)
  }
  path
}
