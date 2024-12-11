
# Setup ----
c_mat  <- matrix(c(4, 2, 3, 11), ncol = 2L)
c_list <- list(n11 = 4, n1_ = 7, n_1 = 6, n = 20)
x      <- enrich_test(c_mat)

# Testing ----
test_that("`enrich_test()` returns correct object and values", {
  expect_named(x, c("confusion", "result", "fisher_test", "alternative"))
  dimnames(c_mat) <- list(v1 = c("no", "yes"), v2 = c("no", "yes"))
  expect_equal(x$confusion, c_mat)
  res <- tibble::tibble(
    test = c("1-sided", "2-sided", "1-sided mid", "2-sided mid",
             "2-sided min lik", "2-sided min lik mid"),
    `p-value` = c(0.0776573787409701,
                  0.15531475748194,
                  0.0424406604747162,
                  0.0848813209494325,
                  0.121929824561404,
                  0.0867131062951497)
  )
  expect_equal(x$result, res)
})

test_that("`enrich_test()` errors out when it should", {
  expect_error(
    enrich_test(1:10L),
    "Unable to dispatch S3 method for class: 'integer'"
  )
  expect_error(
    enrich_test(letters),
    "Unable to dispatch S3 method for class: 'character'"
  )
  expect_error(
    enrich_test(matrix(0:1, ncol = 2L)),
    "`x` must be a 2x2 matrix."
  )
  expect_error(
    enrich_test(unname(c_list)),
    "List must be *named* with: 'n11', 'n1_', 'n_1', 'n'",
    fixed = TRUE
  )
})

test_that("`enrich_test()` S3 methods dispatch correctly", {
  expect_equal(x, enrich_test(c_list))  # S3 list
  expect_equal(x, enrich_test(data.frame(c_mat)))  # S3 data.frame
  # S3 print
  expect_snapshot(x)
})
