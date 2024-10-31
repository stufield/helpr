
test_that("All symbols are present in 'symbol_utf8' and 'symbol_ascii'", {
  expect_length(symbol_utf8, 52L)
  expect_length(symbol_ascii, 76L)
})

test_that("All ASCII symbols are present in 'symbl' list object", {
  expect_snapshot_output(symbl) # Outputs symbols as ASCII, by default
})

test_that("All UTF-8 symbols are present in 'symbl' list object", {
  local_reproducible_output(unicode = TRUE) # Ensures test uses Unicode symbols
  expect_snapshot_output(symbl)
})

test_that("show_symbols() prints symbols to the console with various widths", {
  withr::with_options(
    list(width = 20), expect_snapshot_output(show_symbols())
  )
  withr::with_options(
    list(width = 60), expect_snapshot_output(show_symbols())
  )
  withr::with_options(
    list(width = 80), expect_snapshot_output(show_symbols())
  )
  withr::with_options(
    list(width = 120), expect_snapshot_output(show_symbols())
  )
})
