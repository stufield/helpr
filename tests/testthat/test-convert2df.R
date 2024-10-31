
lst <- list(C1 = c(48.385, 28.998), C2 = c(42.491, 99.284, 17.959, 33.837))
df  <- data.frame(lst)
dbl <- df$C1
int <- 1:4L
lgl <- c(TRUE, FALSE, FALSE, TRUE, TRUE, TRUE)
tbl <- table(lgl)
chr <- LETTERS[seq(1, 11, by = 2)]
fct <- as.factor(chr)
mtx <- as.matrix(df)

test_that("convert2df() returns the correct data class for all inputs", {
  # For all input classes, returned object should be a data frame
  expect_s3_class(convert2df(lst), "data.frame")
  expect_s3_class(convert2df(tbl), "data.frame")
  expect_s3_class(convert2df(fct), "data.frame")
  expect_s3_class(convert2df(mtx), "data.frame")

  # These classes are all converted using the 'numeric' method
  expect_s3_class(convert2df(dbl), "data.frame")
  expect_s3_class(convert2df(chr), "data.frame")
  expect_s3_class(convert2df(lgl), "data.frame")
})

test_that("convert2df() returns the correct values for the classes it dispatches on", {
  # Should throw warning if object is already a df
  expect_warning(
    x <- convert2df(df),
    "`x` is already a `data.frame`. Returning 'df'",
    fixed = TRUE
  )
  expect_equal(x, df)
  expect_equal(convert2df(tbl),
               data.frame("FALSE" = 2, "TRUE" = 4, check.names = FALSE))
  expect_equal(convert2df(lst), data.frame(lst))
  x <- setNames(data.frame("A", "C", "E", "G", "I", "K"), paste0("v", 1:6))
  expect_equal(convert2df(chr), x)
  attr(x, "levels") <- levels(fct)
  expect_equal(convert2df(fct), unname(x))
  expect_equal(convert2df(mtx), df)
  x <- setNames(data.frame(as.list(c(lst$C1, lst$C1))), paste0("v", 1:4))
  expect_equal(convert2df(dbl), x)
})
