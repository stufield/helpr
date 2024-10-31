
test_that("`is_int_vec()` unit tests", {
  expect_true(is_int_vec(1:10))
  expect_true(is_int_vec(seq(10, 50, 1)))
  expect_false(is_int_vec(rnorm(10)))
  expect_false(is_int_vec(head(letters)))
  expect_false(is_int_vec(factor(head(letters))))
})
