
test_that("be_safe() returns the correct captures", {
  safelog <- be_safe(log2)
  foo <- safelog("a")
  bar <- safelog("foo" + 10)
  ok  <- safelog(32)
  expect_equal(foo,
               list(result = NULL,
                    error = "non-numeric argument to mathematical function"))
  expect_equal(bar,
               list(result = NULL,
                    error = "non-numeric argument to binary operator"))
  expect_equal(ok, list(result = 5, error = NULL))
})

test_that("be_safe() otherwise= argument passed to result", {
  safelog <- be_safe(log2, NA_real_)
  foo <- safelog("foo")
  expect_equal(foo,
               list(result = NA_real_,
                    error = "non-numeric argument to mathematical function"))
})

test_that("be_quiet() returns the correct captures", {
  # create a chatty function:
  fun <- function(x) {
    message("Message #1.")
    message("Message #2.")
    warning("Warning!")
    warning("Second warning!")
    cat("Multiplying pi:\n")
    pi * x
  }
  f <- be_quiet(fun)
  expect_equal(f(5),
               list(result   = 15.707963267949,
                    output   = "Multiplying pi:",
                    warnings = c("Warning!", "Second warning!"),
                    messages = c("Message #1.\n", "Message #2.\n"))
               )
})

test_that("be_quiet() can still error out", {
  fun <- function(x) x * pi
  f <- be_quiet(fun)
  expect_error(f("foo"), "non-numeric argument to binary operator")
})

test_that("be_quiet() can still error out", {
  x <- withr::with_seed(1, rnorm(100))
  fun <- be_hard(quantile, probs = c(0.025, 0.975), names = FALSE)
  expect_s3_class(fun, "hard_coded")
  expect_equal(fun(x), c(-1.6712975103719, 1.7974683277310))
  fun <- be_hard(median, na.rm = TRUE)
  expect_s3_class(fun, "hard_coded")
  expect_true(is.na(median(c(x, NA_real_))))
  expect_equal(fun(c(x, NA_real_)), median(x))
})
