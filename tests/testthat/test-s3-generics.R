
test_that("S3 generics are set up properly and available for method dispatch", {
  skip_on_covr()     # don't run if in 'covr'
  expect_true(isS3stdGeneric(fit))
  expect_true(isS3stdGeneric(tune))
  expect_true(isS3stdGeneric(get_model_classes))
  expect_true(isS3stdGeneric(get_model_features))
  expect_true(isS3stdGeneric(get_model_coef))
  expect_true(isS3stdGeneric(get_model_type))
  expect_true(isS3stdGeneric(get_pos_class))
  expect_true(isS3stdGeneric(calc_model_metrics))
  expect_true(isS3stdGeneric(calc_predictions))
})
