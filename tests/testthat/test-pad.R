
test_that("long strings are unchanged", {
  lengths <- sample(40:100, 10)
  strings <- vapply(
    lengths,
    function(.x) paste(letters[sample(26, .x, replace = TRUE)], collapse = ""),
    ""
  )
  padded <- pad(strings, width = 30)
  expect_equal(nchar(padded), nchar(strings))
})

test_that("padding right gives proper string", {
  expect_equal(pad("foo", 4), "foo ")
  expect_equal(pad("foo", 4, side = "l"), " foo")
  x <- "this is a test"
  expect_equal(pad(x, nchar(x)), x)           # does nothing b/c width => pad
  expect_equal(pad(x, nchar(x), "l"), x)   # does nothing b/c width => pad
  # expanded
  expect_equal(pad(x, 25), "this is a test           ")
  expect_equal(pad(x, 25, "l"), "           this is a test")
  # length greater than 1
  expect_equal(pad(letters, 5), paste(letters, "   "))
  expect_equal(pad(letters, 5, "l"), paste("   ", letters))
})

test_that("directions work for simple case", {
  w <- 10
  pad2 <- function(x) pad("stu", width = w, side = x)
  expect_equal(pad2("right"),  "stu       ")
  expect_equal(pad2("left"),   "       stu")
  expect_equal(pad2("both"),   "   stu    ")
  # nchar is same
  expect_equal(nchar(pad2("right")), w)
  expect_equal(nchar(pad2("left")), w)
  expect_equal(nchar(pad2("both")), w)
})

test_that("padding based of length works", {
  # \u4e2d is a 2-characters-wide Chinese character
  tmp <- function(...) pad("\u4e2d", ..., side = "both")
  expect_equal(tmp(width = 6), "  \u4e2d  ")
  expect_equal(tmp(width = 5), " \u4e2d  ")   # unequal padding to the right
})
