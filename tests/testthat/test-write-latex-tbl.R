
# Setup wrapper ----
# cols chosen to expose vector types
tbl <- head(mtcars)[, c("mpg", "cyl", "wt", "vs", "gear", "carb")]
tbl$gear <- factor(tbl$gear)
tbl$carb <- as.character(tbl$carb)

# https://testthat.r-lib.org/reference/expect_snapshot_file.html
expect_snapshot_tex <- function(data, file, ...) {
  # Announce the file before touching `code`. If `code`
  # fails or skips, testthat will not clean up the
  # corresponding snapshot file.
  withr::defer(unlink(path, force = TRUE))
  announce_snapshot_file(name = file)
  path <- write_latex_tbl(data, path = file, ...)
  expect_snapshot_file(path, file)
}


# Testing ----
test_that("`write_latex_tbl()` generates the correct tables in LaTeX format", {
  expect_snapshot_tex(tbl, "defaults.tex")
})

test_that("`write_latex_tbl()` generates a proper rownames title column", {
  expect_snapshot_tex(tbl, "label-rownames-column.tex", rn_label = "Car Model")
})

test_that("`write_latex_tbl()` generates the correct table without rownames", {
  expect_snapshot_tex(tbl, "no-rownames.tex", include_rn = FALSE)
})

test_that("`write_latex_tbl()` adds a caption collrectly to LaTeX format", {
  expect_snapshot_tex(tbl, "table-with-caption.tex",
                      caption = "This is a really important table.")
})

test_that("`write_latex_tbl()` long table format written to LaTeX format", {
  expect_snapshot_tex(mtcars[, 1:4L], "long-table-format.tex", long = TRUE)
})

test_that("`write_latex_tbl()` correctly appends LaTeX table to an existing file", {
  desc <- get("desc", envir = parent.frame(3))
  texfile <- "append-true.tex"
  expect_snapshot_tex({
    cat(file = test_path(texfile),
        paste("%", desc),
        "%",
        "% This is the snapshot output for `write_latex_tbl()`",
        "%   when `append = TRUE`.",
        "%",
        "% The LaTeX table should begin below this double line.", sep = "\n",
        "======================================================")
    tbl
    }, texfile, append = TRUE)
})
