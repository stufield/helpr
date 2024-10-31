
# Setup ----
#   many tests below require Sys.setenv(TESTTHAT = "false")
#   b/c colors are not added in a testing context, i.e. `is_testing() == TRUE`


test_that("value returns characters correctly", {
  withr::local_envvar(TESTTHAT = "false")
  x <- value(head(LETTERS, 3L))
  expect_s3_class(x, "str_value")
  expect_equal(
    unclass(x),
    "\033[34m'A'\033[39m, \033[34m'B'\033[39m, \033[34m'C'\033[39m"
  )
})

test_that("value returns paths correctly", {
  withr::local_envvar(TESTTHAT = "false")
  x <- value("~/git/package/inst")   # no trailing '/'
  expect_equal(unclass(x), "\033[34m'~/git/package/inst'\033[39m")
  # trailing '/' indicates a directory; no quotes
  x <- value("~/git/package/inst/")
  expect_equal(unclass(x), "\033[34m~/git/package/inst/\033[39m")
  # double internal '/' are removed
  x <- value("~/git//package//inst/")
  expect_equal(unclass(x), "\033[34m~/git/package/inst/\033[39m")
})

test_that("existing directory removes quotes and adds trailing '/", {
  withr::local_dir(test_path())   # must do this first
  withr::local_envvar(TESTTHAT = "false")
  # '_snaps' is an existing directory: 'testthat/_snaps'
  x <- value("_snaps")
  expect_equal(unclass(x), "\033[34m_snaps/\033[39m")
  # combinations are returned correctly
  x <- value(c("FOO", "ABCD"))       # neither exist; string formatting
  expect_equal(unclass(x), "\033[34m'FOO'\033[39m, \033[34m'ABCD'\033[39m")
  x <- value(c("FOO/", "ABCD/"))     # neither exist; override with '/'
  expect_equal(unclass(x), "\033[34mFOO/\033[39m, \033[34mABCD/\033[39m")
  x <- value(c("_snaps", "ABCD"))    # ABCD doesn't exist; nukes path format
  expect_equal(unclass(x), "\033[34m'_snaps'\033[39m, \033[34m'ABCD'\033[39m")
  x <- value(c("_snaps", "ABCD/"))   # ABCD doesn't exist; override with '/'
  expect_equal(unclass(x), "\033[34m_snaps/\033[39m, \033[34mABCD/\033[39m")
})
