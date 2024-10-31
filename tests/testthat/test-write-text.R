# Setup ----
content <- c(LETTERS, letters)
withr::defer({
  unlink("out.txt", force = TRUE)
  unlink("content.txt", force = TRUE)
})

# Testing ----
test_that("`write_text()` writes correct text out to file", {
  expect_snapshot(
    write_text(path = "content.txt", lines = content)
  )
  expect_true(file.exists("content.txt"))
  new_content <- read_text("content.txt")
  expect_equal(content, new_content) # same as the original text
})

test_that("`write_text()` creates file when it isn't already present", {
  before <- ls_dir() # getting list of files prior to writing out the content
  expect_snapshot(
    write_text(path = "out.txt", lines = content)
  )
  after <- ls_dir() # obtaining an updated file list

  # this should only include the name of the text file
  diff <- setdiff(after, before)
  expect_equal(diff, "out.txt")
})

test_that("`write_text()` does not overwrite when 'overwrite' != TRUE", {
  suppressMessages(write_text(path = "out.txt", lines = content))
  # this file already exists
  expect_snapshot(
    write_text(path = "out.txt", lines = content, overwrite = FALSE)
  )
})

test_that("`write_text()` overwrites pre-existing files when asked to", {
  to_overwrite <- paste0(50:60, content)
  expect_snapshot(
    write_text(path = "out.txt", lines = to_overwrite, overwrite = TRUE)
  )
  # these should be equivalent if the file was successfully overwritten
  expect_equal(to_overwrite, read_text("out.txt"))
})
