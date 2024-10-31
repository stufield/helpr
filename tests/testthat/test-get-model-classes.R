# Setup -----------
n <- 100
expit <- function(x) exp(x) / (1 + exp(x))

withr::with_seed(298734, {
  x    <- matrix(rnorm(n * 5), n, 5)
  beta <- rnorm(5)
  p    <- expit(x %*% beta)

  class_integer <- rbinom(n, 1, prob = p)
  class_logical <- as.logical(class_integer)
  class_labels  <- factor(ifelse(class_integer == 1, "positive", "negative"),
                         levels = c("negative", "positive"))

  pos_size <- rbinom(n, 100, prob = p)
  neg_size <- 100 - pos_size
})

# Testing -----------
test_that("`get_model_classes()` works for glm with binomial family", {
  fit   <- glm(class_integer ~ x, family = "binomial")
  preds <- predict(fit, data.frame(x = x), type = "response")
  expect_equal(get_model_classes(fit), c(0, 1))
  # Check that predictions line up with response values by taking the
  # mean of their difference
  expect_equal(mean(preds - class_integer), -2.62629002747e-16)

  fit   <- glm(class_logical ~ x, family = "binomial")
  preds <- predict(fit, data.frame(x = x), type = "response")
  expect_equal(get_model_classes(fit), c(FALSE, TRUE))
  expect_equal(mean(preds - as.numeric(class_logical)), -2.62629002747e-16)

  fit   <- glm(class_labels ~ x, family = "binomial")
  preds <- predict(fit, data.frame(x = x), type = "response")
  expect_equal(get_model_classes(fit), c("negative", "positive"))
  expect_equal(mean(as.numeric(class_labels) - 1 - preds), -2.70897128514e-16)

  fit   <- glm(cbind(pos_size, neg_size) ~ x, family = "binomial")
  preds <- predict(fit, data.frame(x = x), type = "response")
  obs   <- pos_size / (pos_size + neg_size)
  expect_equal(get_model_classes(fit), c("neg_size", "pos_size"))
  expect_equal(mean(preds - obs), -5.72639822388e-15)

  # expect error
  fit <- glm(pos_size ~ x, family = "poisson")
  expect_error(get_model_classes(fit),
               "`glm` models with family 'poisson' are not supported.")

  fit <- glm(class_integer ~ x, family = "binomial", model = FALSE)
  expect_error(get_model_classes(fit),
               "Unable to determine the classes for this `glm` model.")
})
