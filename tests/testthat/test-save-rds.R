
# Setup ----
withr::defer({
  unlink("out.rds", force = TRUE)
  unlink("out.rda", force = TRUE)
  unlink("test.rda", force = TRUE)
})

# Testing ----
test_that("save_rda() only accepts the correct file extension(s)", {
  expect_error(save_rda(mtcars, file = "test.rds"),
               regexp = "Incorrect file extension to `*.rda` file", fixed  = TRUE)
})

test_that("file extensions are coerced properly", {
  x <- c("out.rds", "out.RDS", "out.Rds", "out.RDs")
  test <- vapply(x, function(.f) save_rds(LETTERS, .f), "")
  expect_true(rep_lgl(test))
})

test_that("compression type is 'xz' and file saved correstly", {
  expect_true(file.exists("out.rds"))
  expect_equal(getCompression("out.rds"), "xz")
})

test_that("error trips if invalid file path passed", {
  expect_error(
    save_rds(LETTERS, "out.RData"),
    "Incorrect file extension to `*.rds` file: 'RData'",
    class = "simpleError", fixed = TRUE
  )
})

test_that("getCompression() returns proper compression type", {
  x <- seq(100)
  save(x, file = "test.rda")
  expect_equal(getCompression("test.rda"), "gzip")
  save(x, file = "test.rda", compress = "bzip2")
  expect_equal(getCompression("test.rda"), "bzip2")
  save(x, file = "test.rda", compress = "xz")
  expect_equal(getCompression("test.rda"), "xz")
})

test_that("save_rda() saves serialized objects properly", {
  x <- seq(100)
  y <- LETTERS
  save_rda(x, y, file = "out.rda")
  expect_true(file.exists("out.rda"))
  expect_equal(getCompression("out.rda"), "xz")
})
