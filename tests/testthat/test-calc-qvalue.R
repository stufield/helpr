
x <- withr::with_seed(101, c(seq(0.0001, 0.05, length = 50), runif(950)))
q <- calc_qvalue(x)

test_that("calc_qvalue() returns all expected list elements", {
  expect_named(q, c("call", "p.value", "m", "lambda", "lambda.eval",
                    "pi.lambda", "spline.fit", "pi0", "q.value"))
})

test_that("calc_qvalue() output vector is the same length as inputted p-values", {
  expect_equal(length(x), length(q$p.value))
})

test_that("calc_qvalue() outputs the expected values", {
  expect_equal(sum(q$q.value), 785.22142788827)
})
