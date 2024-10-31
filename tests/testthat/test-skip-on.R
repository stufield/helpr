
expect_skip <- function(code) {
  tryCatch({
    skipped <- TRUE
    code
    skipped <- FALSE
    }, skip = function(e) NULL
  )
  expect(skipped, "skip not active")
}

test_that("Skip on check works with env vars", {
  expect_skip_with_env <- function(new, skip_fun) {
    withr::with_envvar(new, expect_skip(skip_fun()))
  }
  expect_skip_with_env(c("_R_CHECK_PACKAGE_NAME_" = "helpr"), skip_on_check)
  expect_skip_with_env(c("_R_CHECK_PACKAGE_NAME_" = ""), skip_on_test)
})
