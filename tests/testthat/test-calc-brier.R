
# Setup ----
n <- 100L
p <- withr::with_seed(1, runif(n))
true <- 0.323246522092


# Testing ----
test_that("the default method dispatches and gives error", {
  expect_error(
    calc_brier("A", 0.4),   # pass char
    "`x` must be *only* numeric 0s and 1s, or able to be coerced",
    fixed = TRUE
  )
})

test_that("the numeric method dispatches and gives correct value", {
  x <- withr::with_seed(123, sample(0:1, n, replace = TRUE))
  expect_equal(calc_brier(x, p), true)
})

test_that("the integer method dispatches and gives correct value", {
  x <- withr::with_seed(123, sample(0:1L, n, replace = TRUE))
  expect_equal(calc_brier(x, p), true)
})

test_that("the factor method dispatches and gives correct value", {
  x <- withr::with_seed(123, sample(factor(c("A", "B")), n, replace = TRUE))
  expect_equal(calc_brier(x, p), true)
})

test_that("the logical method dispatches and gives correct value", {
  x <- withr::with_seed(123, sample(factor(c(FALSE, TRUE)), n, replace = TRUE))
  expect_equal(calc_brier(x, p), true)
})


test_that("error conditions trigger apprpriately with correct messages", {
  expect_error(
    calc_brier(c(0, 1), 0.4), # diff lengths
    "`x` and `p` must be the same length"
  )
  expect_error(
    calc_brier(c(0, 0.4, 1), c(0.4, 0.1, 0.2)), # 3 levels in `x`
    "`x` must contain have only 2 values, 0 and 1"
  )
  expect_error(
    calc_brier(c(2, 1), c(0.2, 0.4)),   # 2 values; but not 0 and 1
    "`x` must contain *only* 0 and 1",
    fixed = TRUE
  )
})
