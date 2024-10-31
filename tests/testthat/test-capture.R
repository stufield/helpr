
test_that("capture returns basic output as expected", {
  x <- capture(c("foo", "bar", "boo", "oops"), "(oo)$")
  expect_s3_class(x, "data.frame")
  expect_equal(x, data.frame(`1` = c("oo", NA, "oo", NA), check.names = FALSE))
})

test_that("capture returns multiple match output as expected", {
  x <- capture(c("fooAAA", "foobar", "boo", "oops"), "(oo)(.*)")
  expect_s3_class(x, "data.frame")
  expect_equal(x, data.frame(`1` = c("oo", "oo", "oo", "oo"),
                             `2` = c("AAA", "bar", "", "ps"),
                             check.names = FALSE))
})

test_that("capture error trip if no group regex pattern passed", {
  expect_error(
    capture(c("foo", "bar", "boo", "moops"), "oo$"),
    "Bad pattern argument! Must contain a group capture regex"
  )
})
