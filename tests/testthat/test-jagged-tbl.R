
# Setup ----
withr::with_seed(101, {
  p <- 5L   # cols
  n <- 10L  # rows
  x <- replicate(p, sample(seq(1000), sample(seq(n), 1))) |>
    set_Names(paste0("v", seq(p)))
  df <- jagged_tbl(x)
})

# Testing ----
test_that("`jagged_tbl()` returns correct and expected output", {
  expect_s3_class(df, "tbl_df")
  expect_named(df, names(x))
  expect_equal(dim(df), c(9L, p))   # 10 wasn't sampled with this seed
  expect_equal(sum(is.na(df)), 16)
  expect_true(0 %in% colSums(is.na(df)))   # 1 column must be full length
  expect_equal(which(colSums(is.na(df)) == 0), c(v1 = 1L))  # and it is column 1
})

test_that("`jagged_tbl()` errors out without names", {
  expect_error(
    jagged_tbl(unname(x)),
    "Names of `x` can't be empty. Please provide names."
  )
})
