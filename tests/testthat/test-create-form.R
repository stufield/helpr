
# Setup ----
ft <- c("ft_2802.68", "ft_9251.29", "ft_1942.70", "ft_5751.80", "ft_9608.12")

# Testing ----
test_that("it is a formula with the correct elements", {
  form <- create_form("Group", ft)
  expect_s3_class(form, "formula")
  expect_equal(as.character(form),
               c("~", "Group",
                 paste(ft, collapse = " + ")))
})

test_that("it is as light as possible", {
  form <- create_form("class", ft)
  expect_equal(ls(environment(form)), c("env", "expr"))
  expect_equal(get("expr", environment(form)), unclass(form), ignore_attr = TRUE)
  expect_equal(get("env", environment(form)), attr(form, ".Environment"))
})

test_that("non-default collapse argument is properly parsed", {
  form <- create_form("Group", ft, "*")
  expect_s3_class(form, "formula")
  expect_equal(as.character(form),
               c("~", "Group",
                 paste(ft, collapse = " * ")))
})

test_that("the calling environment can be easliy captured", {
  x    <- 1:100
  form <- create_form("class", ft, env = environment())
  expect_equal(ls(environment(form)), c("form", "x"))
  expect_equal(get("x", environment(form)), 1:100)
})
