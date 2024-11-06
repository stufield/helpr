
test_that("helpr is in style compliance", {
  skip_on_check()    # don't run in devtools::check()
  skip_on_covr()     # don't run if in 'covr'
  skip_if_not_installed("lintr")
  skip_if_not(packageVersion("lintr") >= "3.0.2")
  skip_if_not_installed("megaverse")

  # linters and exclusions are controlled by
  # the .lintr file in pkg root
  t_lints <- withr::with_dir(
    ifelse(is_testing(), ".", "tests/testthat"),
    lintr::lint_dir(pattern = "^test-")
  )
  r_lints <- withr::with_dir(
    ifelse(is_testing(), "../../R", "R"),
    lintr::lint_dir(pattern = "[.][Rr]$")
  )
  expect_length(t_lints, 0L)
  expect_length(r_lints, 0L)
})
