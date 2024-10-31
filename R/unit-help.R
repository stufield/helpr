#' Unit Test Helpers
#'
#' Manage whether certain tests are skipped during
#' [devtools::check()], [devtools::test()], or during a temporary automated
#' pipeline builds. This may be desired if certain tests are time consuming
#' or special environment characteristics make them undesirable.
#' See [testthat::skip_if()] and [testthat::skip_on_cran()] for details.
#'
#' @rdname unit-help
#' @param ... Arguments passed to [testthat::expect_no_error()].
#' @export
expect_error_free <- function(...) {
  lifecycle::deprecate_warn(
    "0.0.1", "helpr::expect_error_free()", "testthat::expect_no_error()"
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
skip_on_jenkins <- function() {
  on_jenkins <- identical(tolower(Sys.getenv("ON_JENKINS")), "true")
  testthat::skip_if(on_jenkins, "On Jenkins!")
}
