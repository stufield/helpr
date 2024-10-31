test_that("`logit()` returns warnings and errors as expected", {
  # negative values should produce NaNs
  expect_warning(logit(c(-1.5, 0.1, 0.8)), "NaNs produced")

  # values > 1 should produce NaNs
  expect_warning(logit(c(0.1, 0.8, 1.5)), "NaNs produced")

  # values at limits of range should produce Infs
  expect_warning(logit(c(0, 0.5, 1.0)), "Some values are infinite.")

  # input must be numeric
  expect_error(logit("A"), "`x` must be numeric.")

  # should not work for integers
  expect_error(logit(50L), "`x` must be numeric.")
})

test_that("`logit()` behaves as expected with valid inputs", {
  # vector input
  x <- withr::with_seed(1234L, stats::runif(100L))
  expect_equal(logit(x), log(x / (1.0 - x)))

  # scalar input
  expect_equal(logit(0.5), log(1.0))

  # NAs and NaNs return as NAs and NaNs
  expected <- log(x / (1.0 - x))
  x[1L] <- NaN
  expected[1L] <- NaN
  expect_warning(out <- logit(x),
                 "`x` contains NaNs.",
                 fixed = TRUE)
  expect_equal(out, expected)

  x[1L] <- NA
  expected[1L] <- NA
  expect_warning(out <- logit(x),
                 "`x` contains NAs.",
                 fixed = TRUE)
  expect_equal(out, expected)
})

test_that("`expit()` returns warnings and errors as expected", {
  # input must be numeric
  expect_error(expit("A"),
               "`x` must be numeric.",
               fixed = TRUE)
})

test_that("`expit()` behaves as expected with valid inputs", {
  # vector input
  x <- withr::with_seed(1234L, stats::rnorm(100L))
  expect_equal(expit(x), exp(x) / (1.0 + exp(x)))

  # scalar input
  expect_equal(expit(0.0), 0.5)

  # should work for integers
  y <- c(1L, 3L, 5L)
  expect_equal(expit(y), exp(y) / (1.0 + exp(y)))

  # NAs and NaNs return as NAs and NaNs
  expected <- exp(x) / (1.0 + exp(x))
  x[1L] <- NaN
  expected[1L] <- NaN
  expect_warning(out <- expit(x),
                 "`x` contains NaNs.",
                 fixed = TRUE)
  expect_equal(out, expected)

  x[1L] <- NA
  expected[1L] <- NA
  expect_warning(out <- expit(x),
                 "`x` contains NAs.",
                 fixed = TRUE)
  expect_equal(out, expected)
})

test_that("`expit(logit(x))` and `logit(expit(x))` return x", {
  x <- withr::with_seed(1234L, stats::rnorm(100L))
  expect_equal(logit(expit(x)), x)

  y <- withr::with_seed(1234L, stats::runif(100L))
  expect_equal(expit(logit(y)), y)
})
