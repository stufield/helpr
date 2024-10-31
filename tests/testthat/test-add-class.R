
test_that("add_class() adds the class label to the object", {
  x <- add_class(mtcars, "foo")
  expect_equal(class(x), c("foo", "data.frame"))
  expect_equal(class(add_class(x, "foo")), class(x))   # no change

  expect_equal(
    class(add_class(mtcars, c("foo", "foo"))),  # no duplicates
    c("foo", "data.frame")
  )
  expect_equal(
    class(add_class(mtcars, c("foo", "bar"))), # multiple classes
    c("foo", "bar", "data.frame")
  )
  expect_equal(
    class(add_class(mtcars, c("bar", "foo"))), # multiple classes in order
    c("bar", "foo", "data.frame")
  )

  expect_equal(
    class(add_class(x, "data.frame")), c("data.frame", "foo") # re-orders
  )

  expect_warning(
    expect_equal(class(add_class(mtcars, NULL)), "data.frame"), # NULL case no change
    "Passing `class = NULL` leaves class(x) unchanged.",
    fixed = TRUE
  )
  expect_warning(
    expect_equal(class(add_class(x, NULL)), class(x)),  # NULL case no change
    "Passing `class = NULL` leaves class(x) unchanged.",
    fixed = TRUE
  )

  expect_error(
    add_class(mtcars, NA_character_),
    "The `class` param cannot contain `NA`: NA"
  )
  expect_error(
    add_class(mtcars, c("foo", NA_character_)),
    "The `class` param cannot contain `NA`: 'foo', NA"
  )
})
