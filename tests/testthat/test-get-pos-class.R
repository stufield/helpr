# Setup -------
n <- 100
withr::with_seed(298734, {
  x             <- matrix(rnorm(n * 20), n, 20)
  class_integer <- sample(c(0, 1), n, replace = TRUE)
  # factors intentionally inverted to test warning message:
  class_factor <- factor(class_integer, levels = c("1", "0"))
  class_labels  <- factor(ifelse(class_integer == 1, "positive", "negative"),
                          levels = c("negative", "positive"))
  pos_size      <- sample(1:100, size = n, replace = TRUE)
  neg_size      <- 100 - pos_size
})

# Testing -----
# binomial
test_that("`get_pos_class.glm()` works for glm with binomial family", {
  # supplying binary 0, 1 vector
  fit <- glm(class_integer ~ x, family = "binomial")
  expect_equal(get_pos_class(fit), 1)

  fit <- glm(class_labels ~ x, family = "binomial")
  expect_equal(as.character(get_pos_class(fit)), "positive")

  fit <- glm(cbind(pos_size, neg_size) ~ x, family = "binomial")
  expect_equal(get_pos_class(fit), "pos_size")
})

test_that("`get_pos_class.glm()` warns about strange results", {
  reverse_labels <- factor(class_labels, levels = c("positive", "negative"),
                              ordered = TRUE)
  fit <- glm(reverse_labels ~ x, family = "binomial")
  expect_warning(out <- get_pos_class(fit), fixed = TRUE,
                 "Check how the response was supplied to `glm()`.")
  expect_equal(out, "negative")

  fit <- glm(cbind(N = neg_size, Y = pos_size) ~ x, family = "binomial")
  expect_warning(out <- get_pos_class(fit), fixed = TRUE,
                 "Check how the response was supplied to `glm()`.")
  expect_equal(out, "N")

  fit <- glm(class_factor ~ x, family = "binomial")
  expect_warning(get_pos_class(fit),
                 "Extracted positive class is `0`, `N`, `neg`, or `negative`")
})
