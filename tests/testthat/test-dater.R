test_that("dater() returns the date in the correct format", {
  expect_true(grepl("20[0-9]{2}\\-[01][0-9]\\-[0-3][0-9]", dater()))  # YYYY-MM-DD
})
