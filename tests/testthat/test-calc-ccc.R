
test_that("`calc_ccc()` returns the correct values", {
  withr::with_seed(101, {
    x <- rnorm(100)
    y <- rnorm(100)
  })
  ccc <- calc_ccc(x, y)
  expect_error(calc_ccc(x, c(y, 1)))
  expect_named(ccc, c("rho_c", "ci95", "Z", "p_value"))
  expect_equal(ccc$ci95, c(lower = -0.089276638680582,
                           upper = 0.296252008416967))
  expect_equal(ccc$rho_c, 0.10752819)
  expect_equal(ccc$Z, 0.10794551224656)
  expect_equal(ccc$p_value, 0.91403891446702)
})
