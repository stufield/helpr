
df <- withr::with_seed(1,
  data.frame(
    stringsAsFactors = FALSE,
    id        = 1:20L,
    Sample    = sample(LETTERS[1:3L], 20, replace = TRUE),
    TimePoint = sample(c("1wk", "2wk", "3wk", "4wk"), 20, replace = TRUE)
  )
)

test_that("`cross_tab` with 1 variable has correct dimensions and names", {
  tbl <- cross_tab(df, Sample)
  expect_equal(dim(tbl), 4)
  expect_length(tbl, 4L)
  expect_named(tbl, c("A", "B", "C", "Sum"))
  expect_named(dimnames(tbl), "Sample")
})

test_that("`cross_tab` with 1 variable has correct values", {
  tbl <- cross_tab(df, Sample)
  expect_equal(sum(tbl), 40)
  expect_equal(c(tbl), c(A = 7, B = 7, C = 6, Sum = 20))
})

test_that("`cross_tab` with 2 variables has correct dimensions and names", {
  tbl <- cross_tab(df, Sample, TimePoint)
  expect_equal(dim(tbl), c(4, 5))
  expect_length(tbl, 20L)
  expect_null(names(tbl))
  expect_named(dimnames(tbl), c("Sample", "TimePoint"))
  expect_equal(dimnames(tbl),
               list(Sample = c("A", "B", "C", "Sum"),
                    TimePoint = c("1wk", "2wk", "3wk", "4wk", "Sum")))
})

test_that("`cross_tab` with 2 variables has correct dimensions and names", {
  tbl <- cross_tab(df, Sample, TimePoint)
  expect_equal(sum(tbl), 80)
  expect_equal(c(tbl), c(3, 3, 2, 8, 1, 2, 4, 7,
                         2, 1, 0, 3, 1, 1, 0, 2, 7, 7, 6, 20))
})

test_that("`cross_tab()` errors when quoted strings passed", {
  expect_error(
    cross_tab(df, "Sample"),
    "Must pass naked strings to"
  )
  var <- "Sample"
  expect_error(
    cross_tab(df, var),
    "Must pass naked strings to"
  )
})

test_that("`cross_tab()` stops if variable absent", {
  expect_error(
    cross_tab(df, foo), "object 'foo' not found"
  )
})
