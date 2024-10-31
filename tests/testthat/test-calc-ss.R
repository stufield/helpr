
test_that("`calc_ss()` unit tests", {
  ss <- withr::with_seed(101, calc_ss(rnorm(100)))
  dub <- withr::with_seed(101, calc_ss(c(rnorm(10), NA_real_)))
  expect_equal(ss, 86.376369060622)
  expect_equal(dub, 3.0737364727062) # NAs are ignored/removed
})
