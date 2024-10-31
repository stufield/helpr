
# Setup ----
x  <- withr::with_seed(101, round(rnorm(26, 15, 2), 1L))
lo <- median(x) / 5.01
hi <- median(x) * 5.01
x  <- c(lo, x, hi)

# Testing ----
test_that("get_outliers() unit test 'parametric' default returns as expected", {
  y <- get_outliers(x, type = "para")
  expect_type(y, "integer")
  expect_null(names(y))
  expect_equal(y, c(1, 28), ignore_attr = TRUE)
  expect_equal(attributes(y),
               list(mu    = 14.625201157333,
                    sigma = 2.035172248935,
                    crit  = c(8.5196844105275, 20.7307179041375))
  )
})

test_that("get_outliers() unit test 'non-parametric' returns as expected", {
  a <- get_outliers(x)
  expect_type(a, "integer")
  expect_equal(get_outliers(x[-a], type = "non"), integer(0))     # no outliers
  y <- get_outliers(x, mad.crit = 1, fold.crit = 1, type = "non") # 2 outliers
  expect_type(y, "integer")
})
