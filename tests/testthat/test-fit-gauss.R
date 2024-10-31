
test_that("`fit_gauss()` generates the correct values", {
  vec <- withr::with_seed(101, stats::rnorm(100, mean = 50, sd = 10))
  est_pars <- fit_gauss(vec)
  expect_type(est_pars, "double")
  expect_match(names(est_pars)[1], "mu")
  expect_match(names(est_pars)[2], "sigma")
  expect_equal(est_pars["mu"], c(mu = 49.8780223247234 ))
  expect_equal(est_pars["sigma"], c(sigma = 9.6203414939696))
  est2 <- fit_gauss(1:10)
  expect_equal(est2["mu"], c(mu = 4.96711451938914 ))
  expect_equal(est2["sigma"], c(sigma = 3.35364325340742))
})
