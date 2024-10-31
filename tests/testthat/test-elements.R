
test_that("compact_it() reduces expected elements", {
  lst <- list(a = "a", b = NULL, c = integer(0), d = NA, e = list())
  expect_equal(compact_it(lst), list(a = "a", d = NA))
})

test_that("discard_it() is not exactly like compact_it()", {
  lst <- list(a = "a", b = NULL, c = integer(0), d = NA, e = list())
  expect_equal(discard_it(lst, is.null),
               list(a = "a", c = integer(0), d = NA, e = list()))
  # this is necessary b/c is.na(NULL) returns logical(0), not FALSE
  is_na <- function(x) is.na(x) && has_length(is.na(x))
  expect_equal(discard_it(lst, is_na),
               list(a = "a", b = NULL, c = integer(0), e = list()))
})

test_that("keep_it() selects the correct elements when logical vector passed", {
  lst <- list(a = "a", b = 5, c = 1L)
  expect_equal(keep_it(lst, c(TRUE, FALSE, TRUE)), list(a = "a", c = 1L))
})

test_that("keep_it() selects the correct elements when logical built on-the-fly", {
  vec <- c(a = "a", b = 5, c = 1L)
  expect_equal(keep_it(vec, vec != 5), c(a = "a", c = 1L))
})

test_that("keep_it() selects the correct elements when function passed", {
  lst <- withr::with_seed(9, replicate(10, sample(10, 5), simplify = FALSE))
  expect_equal(
    keep_it(lst, function(x) mean(x) > 6),
    list(c(10, 3, 9, 6, 7), c(10, 7, 8, 2, 5))
  )
})

test_that("keep_it() selects correctly when `...` args passed to `lgl` function", {
  lst <- list(a = 1:5, b = 1:5)
  lst$a[1] <- NA
  lst$b[5] <- NA
  # named empty list b/c mean() can't handle NAs
  expect_equal(keep_it(lst, function(x) mean(x) > 3), setNames(list(), character(0)))
  # check same via `...` pass-thru
  expect_equal(
    keep_it(lst, function(x) mean(x, na.rm = TRUE) > 3),
    keep_it(lst, function(x, ...) mean(x, ...) > 3, na.rm = TRUE)
  )
  expect_equal(
    keep_it(lst, function(x, ...) mean(x, ...) > 3, na.rm = TRUE),
    list(a = c(NA, 2:5))
  )
})

test_that("keep_it() selects correctly when NAs kick in lgl", {
  expect_equal(
    keep_it(list(a = "A", b = 5, c = 4L), c(TRUE, FALSE, NA)), list(a = "A")
  )
})

test_that("keep_it() works on data frames", {
  df <- data.frame(a = "A", b = "B", c = 10, d = 20)
  expect_equal(keep_it(df, is.numeric), data.frame(c = 10, d = 20))
})

test_that("discard_it() is the inverse of keep_it()", {
  df <- data.frame(a = "A", b = "B", c = 10, d = 20)
  expect_equal(discard_it(df, is.numeric), data.frame(a = "A", b = "B"))
})

test_that("keep_it() self-selects if `x` is a logcial vector itself", {
  expect_equal(
    keep_it(c(a = TRUE, b = FALSE, c = TRUE), identity), c(a = TRUE, c = TRUE)
  )
  expect_equal(
    keep_it(list(a = TRUE, b = FALSE, c = TRUE), identity), list(a = TRUE, c = TRUE)
  )
})
