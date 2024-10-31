
# Setup ----
x <- head(LETTERS)

# Testing ----
test_that("default behavior adds names", {
  expect_named(set_Names(x, head(letters)), tolower(x))
})

test_that("default behavior adds names its OWN names to itself when nothing passed", {
  expect_named(set_Names(x), x)
})

test_that("passing a function applies the function to the names", {
  expect_named(set_Names(x, tolower), tolower(x))
})

test_that("passing `...` to a function applies the `...` to the function", {
  expect_named(
    set_Names(x, paste, "X", sep = "-"),
    paste(x, "X", sep = "-")
  )
})

test_that("passing `...` assigns names according to `c(nms, ...)`", {
  expect_named(set_Names(x, "a", "b"), rep(c("a", "b"), length.out = length(x)))
  expect_named(set_Names(x, "a", "b", c("c", "d"), "e", "f"), tolower(x))
  expect_equal(set_Names(x, "a", "b"), set_Names(x, c("a", "b")))
})

test_that("passing `nms = NULL` removes names", {
  y <- set_Names(x)
  expect_null(names(set_Names(y, NULL)))
  expect_null(names(set_Names(x, NULL, "a", "b")))
})

test_that("passing `nms = NULL` overrides all other arguments", {
  y <- set_Names(x)
  expect_null(names(set_Names(y, NULL, "foo")))
})
