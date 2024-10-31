# Example dataset to test operators that check
# object attributes ex. `%==%` and `%===%`
cars2 <- mtcars
attr(cars2, "am") <- "foo" # Modified attribute will be used for testing

# Example vectors
x <- 1:20
y <- 16:35
a <- c("dog", "cat", "fox")
b <- c("cow", "cat", "horse")

test_that("%||% (now in base R) returns the correct value", {
  foo <- NULL
  expect_equal(foo %||% "bar", "bar")
  expect_equal("foo" %||% "bar", "foo")
})

test_that("%@@% unit tests", {
  cars3 <- mtcars
  expect_null(cars3 %@@% am)
  cars3 %@@% am <- "foo"
  expect_equal(cars3 %@@% am, cars3 %@@% "am") # Shouldn't matter if the attr is quoted
  expect_equal(attr(cars3, which = "am"), "foo")
  expect_equal(attr(cars3, which = "am"), attr(cars2, which = "am"))
  expect_identical(cars2, cars3)
})

test_that("%==% unit tests", {
  df1 <- data.frame(col1 = seq_len(10L), col2 = seq_len(10L))
  expect_true(df1$col1 %==% df1$col2)
  expect_false(df1 %==% cars2) # Should never evaluate to TRUE
  expect_true(cars2 %==% mtcars) # This operator doesn't check attrs
})

test_that("%===% correctly checks attributes", {
  expect_false(cars2 %===% mtcars) # This operator DOES check attrs
})

test_that("%!=% unit tests", {
  x <- seq_len(10L)
  y <- LETTERS[1:10]
  withr::with_seed(101, {
                   df <- data.frame(rnorm(50, mean = 5, sd = 3),
                                    rnorm(50, mean = 2, sd = 1))
                   vec <- rnorm(50, mean = 5, sd = 3)
  })
  expect_true(x %!=% y)
  expect_true(df %!=% vec)
  expect_false(x %!=% x)
})

test_that("%set% unit tests", {
  expect_equal(x %set% y, 16:20)
  expect_equal(a %set% b, "cat")
  expect_equal(b %set% a, "cat")
})

test_that("%!set% unit tests", {
  expect_equal(x %!set% y, 1:15)
  expect_equal(a %!set% b, c("dog", "fox"))
  expect_equal(b %!set% a, c("cow", "horse"))
})

test_that("%[[% unit tests", {
  x <- list(a = 1:3, b = 4:6, c = 7:9)
  df <- data.frame(x)
  expect_equal(x %[[% 2L, c(a = 2, b = 5, c = 8))
  expect_equal(df %[[% 2L, df[2L, ])
})
