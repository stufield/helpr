
# Sets with no intersection
withr::with_seed(101, {
  a <- sample(LETTERS, 10)
  b <- sample(letters, 10)
})
diffs <- diff_vecs(a, b)

# Sets with an intersection
c <- LETTERS[1:10]
d <- LETTERS[5:15]
diffs2 <- diff_vecs(c, d)

test_that("diff_vecs() identifies intersections as expected", {
  expect_length(diffs$unique_a, 10L)
  expect_length(diffs$unique_b, 10L)
  expect_length(diffs2$inter, 6L) # There should be shared values
})

test_that("diff_vecs() identifies differences as expected", {
  expect_length(diffs$inter, 0L) # There should be no shared values
})

test_that("diff_vecs() produces similar output to setdiff()", {
  # unique_a is calc w/ setdiff(), so these outputs should be the same
  expect_setequal(setdiff(a, b), diffs$unique_a)
})

test_that("diff_vecs() prints summary to the console when 'verbose = TRUE'", {
  expect_snapshot_output(diff_vecs(a, b, verbose = TRUE))
})
