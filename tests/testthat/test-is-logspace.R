
test_that("the `is_logspace()` numeric method gets it right", {
  expect_type(is_logspace(runif(100, 5, 10)), "logical")
  expect_false(is_logspace(matrix(rnorm(100, mean = 1000), ncol = 10)))
  expect_true(is_logspace(matrix(rnorm(100, mean = 10), ncol = 10)))
  expect_false(is_logspace(runif(100, 1000, 10000)))
})


test_that("the `is_logspace()` integer method gets it right", {
  expect_true(is_logspace(2:15))
  expect_false(is_logspace(500:600))
})


test_that("the `is_logspace()` S3 `soma_adat` method gets it right", {
  data <- withr::with_seed(1,
    structure(
      data.frame(id = LETTERS[1:5L],
                 ft_1234.56 = rnorm(5, mean = 5000, sd = 100)),
      class = c("soma_adat", "data.frame")
    )
  )
  expect_false(is_logspace(data))
  apts <- "ft_1234.56"
  new1 <- log10(data[, apts])
  expect_true(is_logspace(new1))
  new2 <- log(data[, apts])
  expect_true(is_logspace(new2))
  new3 <- log2(data[, apts])
  expect_true(is_logspace(new3))
})

test_that("the `is_logspace()` data.frame method gets it right", {
  df <- data.frame(1:15, 15:1)
  expect_true(is_logspace(df))
  df2 <- data.frame(a = round(runif(50, 500, 1000)),
                    b = round(runif(50, 550, 650)),
                    c = round(runif(50, 1000, 1500)))
  expect_false(is_logspace(df2))
})
