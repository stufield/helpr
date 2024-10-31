
# https://testthat.r-lib.org/reference/expect_snapshot_file.html
expect_snapshot_csv2 <- function(code, name, ...) {
  name <- paste0(name, ".csv")
  # Announce the file before touching `code`. This way, if `code`
  # unexpectedly fails or skips, testthat will not auto-delete the
  # corresponding snapshot file.
  withr::defer(unlink(name, force = TRUE))
  announce_snapshot_file(name = name)
  path <- suppressMessages(write_list(code, file = name, ...))
  expect_snapshot_file(path, name)
}

# Setup ----
df_list <- list(Cars = head(mtcars), Iris = head(iris))

# Testing ----
test_that("`write_list()` only accepts a list with at least one named element", {
  expect_error(
    write_list(unname(df_list), "write-list-nonames-test.csv"), # un-named list
    "`x` argument must be a named list for at least one entry."
  )
})

test_that("`write_list()` triggers an error if `rn_title` isn't the right length", {
  expect_error(
    # `rn_title` must be vector of length 2
    write_list(df_list, "write-list-error.csv", rn_title = "Foo"),
    "Length of `rn_title =` argument (1) *must* be identical to", fixed = TRUE
  )
})

test_that("`write_list()` generates expected default *.csv", {
  expect_snapshot_csv2(df_list, "write-list-no-rn", rn_title = NULL)
})

test_that("`write_list()` generates expected *.csv if rowname col specified", {
  expect_snapshot_csv2(df_list, "write-list-rn",
                       rn_title = rep_len("Test", 2L))
})
