
# Setup ----
#   many tests below require Sys.setenv(TESTTHAT = "false")
#   b/c colors are not added in a testing context (is_testing() == TRUE)


test_that("`signal_*()` produces expected messages", {
  expect_snapshot({
    signal_done("Test done")
    signal_todo("Test todo")
    signal_info("Test info")
    signal_oops("Test oops")
    signal_rule("Test single rule")
    signal_rule("Test double rule",  lty = "double")
  })
})

test_that("all signaling can be silenced with the signal.quiet option", {
  withr::local_options(list(signal.quiet = TRUE))
  expect_silent(signal_done("Test done"))
  expect_silent(signal_todo("Test todo"))
  expect_silent(signal_info("Test info"))
  expect_silent(signal_oops("Test oops"))
  expect_silent(signal_rule("Test rule"))
  expect_invisible(signal_rule())
  expect_null(signal_rule())
})

test_that("the colors work correctly via `add_color()`", {
  withr::local_envvar(TESTTHAT = "false")
  expect_snapshot_output(add_color("string", "red"))
  expect_snapshot_output(add_color("string space", "red"))
})

test_that("error trips if invalid `col` argument is passed", {
  expect_error(
    add_color("blue", "foo"),   # args reversed
    "Problem with `col` argument. Possible values are:"
  )
  expect_error(
    add_color("foo", "reed"),  # typo
    "Problem with `col` argument. Possible values are:"
  )
  expect_error(
    add_color("foo", 1L),  # bad `col` argument
    "is.character(col) is not TRUE", fixed = TRUE
  )
  expect_error(
    add_color("foo", TRUE),  # bad `col` argument
    "is.character(col) is not TRUE", fixed = TRUE
  )
  expect_error(
    add_color("foo", c("red", "blue")),  # bad `col` argument
    "EXPR must be a length 1 vector"
  )
})

test_that("the font styles work correctly via `add_style()`", {
  withr::local_envvar(TESTTHAT = "false")
  expect_snapshot(add_style$bold("foo"))
  expect_snapshot(add_style$italic("foo"))
  expect_snapshot(add_style$underline("foo"))
  expect_snapshot(add_style$inverse("foo"))
  expect_snapshot(add_style$strikethrough("foo"))

})

test_that("the colors work correctly via `add_style()`", {
  withr::local_envvar(TESTTHAT = "false")
  expect_snapshot(add_style$blue("string"))
  expect_snapshot(add_style$blue("string space"))
})

test_that("combining colors works correctly", {
  withr::local_envvar(TESTTHAT = "false")
  # red `&` nothing
  x <- c(add_color("with red", "red"), "without red")
  expect_equal(x, c("\033[31mwith red\033[39m", "without red"))
  # red `&` blue
  a <- add_color("red", "red")
  b <- add_color("blue", "blue")
  expect_equal(c(a, b), c("\033[31mred\033[39m", "\033[34mblue\033[39m"))
  # blue `&` bold
  expect_snapshot(add_style$bold(a))
})

test_that("the colors with `signal_*()` functions works correctly", {
  withr::local_envvar(TESTTHAT = "false")
  expect_snapshot(
    signal_oops("You shall", add_style$red("not"), "pass!")
  )
})

test_that("style chains properly handled by the `$` dispatch", {
  withr::local_envvar(TESTTHAT = "false")
  expect_snapshot(add_style$bold("Success"))
  expect_snapshot(add_style$bold$green("Success"))
  expect_snapshot(add_style$bold$green$italic("Success"))
  expect_snapshot(add_style$bold$green$italic$red("Success"))
  # spelling errors are properly trapped by `$` dispatch
  expect_error(
    add_style$bold$greeen$italic("Success"),
    "Invalid argument in `$`, is \033[34m'greeen'\033[39m a typo?", fixed = TRUE
  )
})

test_that("testing and removing style", {
  # shouldn't have any style b/c TESTTHAT envvar
  str <- add_color("string", "red")
  expect_false(has_style(str))
  withr::local_envvar(TESTTHAT = "false")
  str <- add_color("string", "red")
  expect_true(has_style(str))
  expect_false(has_style(rm_style(str)))
})
