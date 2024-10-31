
test_that("`give_praise()` generates expected output", {
  # must temporarily turn off the testing env var
  withr::local_envvar(TESTTHAT = "false")
  expect_snapshot(withr::with_seed(1, give_praise()))
  expect_snapshot(withr::with_seed(2, give_praise()))
})

test_that("color is turned off in knitr/rmarkdown", {
  withr::local_options(c(knitr.in.progress = TRUE))
  expect_snapshot(withr::with_seed(4, give_praise()))
  expect_snapshot(withr::with_seed(8, give_praise()))
})

test_that("give_praise() is silenced with `praise_usr` option", {
  expect_silent(
    withr::with_options(c(praise_usr = FALSE), give_praise())
  )
  expect_null(
    withr::with_options(c(praise_usr = FALSE), give_praise())
  )
})
