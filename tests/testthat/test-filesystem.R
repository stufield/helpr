# Setup ----
# Needed to avoid checking the class of `helpr_path` objects in tests
expect_path_equal <- function(actual, expected) {
  if ( identical(class(expected), "character") ) {
    class(actual) <- NULL
  }
  names(actual) <- NULL
  names(expected) <- NULL
  expect_equal(actual, expected)
}


# Testing ----
test_that("`helpr_path()` returns correct objects", {
  x <- helpr_path("foo", "bar", "baz")
  expect_s3_class(x, "helpr_path")
  expect_s3_class(x, "character")
  expect_path_equal(x, "foo/bar/baz")
  y <- helpr_path("foo", "bar", "baz", ext = "zip")
  expect_path_equal(y, "foo/bar/baz.zip")
})

test_that("`helpr_path()` does recycles the ext= argument if possible", {
  x <- helpr_path("foo", letters[1:3], ext = "txt")
  expect_path_equal(x, c("foo/a.txt", "foo/b.txt", "foo/c.txt"))
  y <- helpr_path("foo", letters[1:3], ext = c("txt", "csv", "zip"))
  expect_path_equal(y, c("foo/a.txt", "foo/b.csv", "foo/c.zip"))
})

test_that("`helpr_path()` removes duoble '//' in paths", {
  true <- helpr_path("foo/bar")
  expect_path_equal(helpr_path("foo", "/bar"), true)
  expect_path_equal(helpr_path("foo", "/", "bar"), true)
  expect_path_equal(helpr_path("foo/", "bar"), true)
})

test_that("`helpr_path()` handles empty path edge cases", {
  expect_path_equal(helpr_path(""), "")
  expect_path_equal(helpr_path("."), ".")
  expect_path_equal(helpr_path(), character(0))
  expect_path_equal(helpr_path(character(0)), character(0))
})

test_that("`helpr_path()` correctly propogates NAs", {
  expect_path_equal(helpr_path(NA_character_), NA_character_)
  expect_path_equal(helpr_path("foo", NA_character_), NA_character_)
  expect_path_equal(helpr_path(c("foo", "bar"), c("baz", NA_character_)),
               c("foo/baz", NA_character_))
  expect_path_equal(helpr_path(c("foo", NA_character_, "bar")), c("foo", NA, "bar"))
  expect_path_equal(
    helpr_path("foo", c(NA_character_, "bar"), "baz"),
    c(NA_character_, "foo/bar/baz")
  )
  expect_path_equal(helpr_path("foo", NA_character_, "bar"), NA_character_)
})

test_that("fails with non-character inputs", {
  msg <- "All '...' must be character."
  expect_error(helpr_path(1), msg)
  expect_error(helpr_path(1L), msg)
  expect_error(helpr_path(factor("A")), msg)
  expect_error(helpr_path(TRUE), msg)
  expect_error(helpr_path(NULL), msg)
  expect_error(helpr_path("a", NULL), msg)
})

test_that("`colorize_paths()` returns the correct coloring", {
  withr::defer({
    unlink("foo", recursive = TRUE, force = TRUE)
    unlink("bar", force = TRUE)
  })
  expect_snapshot(colorize_paths("foo.txt"))
  expect_snapshot(colorize_paths("foo.R"))
  expect_snapshot(colorize_paths("foo.zip"))
  expect_snapshot(colorize_paths("foo.Rmd"))
  expect_snapshot(colorize_paths("foo.md"))
  expect_snapshot(colorize_paths("foo.yml"))
  expect_snapshot(colorize_paths(".foo"))
  expect_snapshot(colorize_paths("foo.sh"))
  expect_snapshot(colorize_paths("foo.py"))
  expect_snapshot(colorize_paths("foo.json"))
  expect_snapshot(colorize_paths("foo.jpeg"))
  expect_snapshot(colorize_paths("foo.png"))
  expect_snapshot(colorize_paths("foo.adat"))
  expect_snapshot(colorize_paths("foo.tar.gz"))
  # directories and symlinks
  system2("mkdir", "foo", stdout = FALSE, stderr = FALSE)
  system2("ln", "-s foo bar", stdout = FALSE, stderr = FALSE)
  expect_snapshot(colorize_paths("foo"))
  expect_snapshot(colorize_paths("bar"))
})

test_that("preserves the class with both subset and subset2", {
  expect_s3_class(helpr_path("foo")[1L], "helpr_path")
  expect_s3_class(helpr_path("foo")[[1L]], "helpr_path")
})

test_that("S3 `+` builds paths correctly", {
  expect_path_equal(helpr_path("foo") + "bar", "foo/bar")
  expect_s3_class(helpr_path("foo") + "bar", "helpr_path")
  expect_path_equal(helpr_path("foo") + "bar/baz", "foo/bar/baz")
  expect_s3_class(helpr_path("foo") + "bar/baz", "helpr_path")
})

test_that("S3 `/` builds paths correctly", {
  expect_path_equal(helpr_path("foo") / "bar", "foo/bar")
  expect_s3_class(helpr_path("foo") / "bar", "helpr_path")
  expect_path_equal(helpr_path("foo") / "bar/baz", "foo/bar/baz")
  expect_s3_class(helpr_path("foo") / "bar/baz", "helpr_path")
})

test_that("S3 `/` and `+` are the same path building", {
  expect_path_equal(helpr_path("foo") + "bar", helpr_path("foo") / "bar")
})

test_that("path permissions conversions are correctly mapped", {
  expect_equal(oct2sym(7), "rwx")
  expect_equal(oct2sym(7), oct2sym("7"))    # converted to octmode inside
  expect_equal(oct2sym("6"), "rw-")
  expect_equal(oct2sym(0), "---")
  expect_error(oct2sym("8"), "s >= 0 && s <= 7 is not TRUE", fixed = TRUE)
  # as_symperm
  expect_equal(as_symperm(as.octmode("755")), "rwxr-xr-x")
  expect_equal(as_symperm(as.octmode("2755")), "rwxr-xr-x")
  expect_equal(as_symperm(as.octmode("775")), "rwxrwxr-x")
  expect_equal(as_symperm(as.octmode("2775")), "rwxrwxr-x")
  expect_equal(as_symperm(as.octmode("644")), "rw-r--r--")
  expect_equal(as_symperm(as.octmode(c("755", "644"))), c("rwxr-xr-x", "rw-r--r--"))
})

test_that("`is.dir()` identifies directories", {
  test <- c(".", NA_character_, "DESCRIPTION",
            test_path("test-filesystem.R"), test_path("_snaps"))
  bool <- is.dir(test)
  expect_type(bool, "logical")
  expect_named(bool, test)
  expect_equal(unname(bool), c(TRUE, FALSE, FALSE, FALSE, TRUE))
})

test_that("`is.dir()` identifies directories", {
  nms <- c("path", "type", "size", "permissions", "modified",
           "user", "group", "changed", "accessed")
  ls <- info_dir()
  expect_named(ls, nms)
  expect_equal(dim(ls), c(length(ls_dir()), 9L))
  liter(ls, c("helpr_path", "character", "helpr_bytes",
              "character", "POSIXct", "character",
              "character", "POSIXct", "POSIXct"),
        function(.x, .y) expect_true(inherits(.x, .y))) |> invisible()
})

test_that("`file_ext()` pulls the correct extension", {
  expect_equal(file_ext("foo.txt"), "txt")
  expect_equal(file_ext(c("foo.txt", "bar.csv")), c("txt", "csv"))  # vectorized
  expect_equal(file_ext("foo/bar/baz.txt"), "txt")    # as a path
  expect_equal(file_ext(character()), character(0))
  expect_equal(file_ext(""), "")
  expect_equal(file_ext("foo/bar"), "")
  expect_equal(file_ext(NULL), character(0))
  expect_equal(file_ext(NA_character_), "")
  expect_error(file_ext(1L), "is.character(text) is not TRUE", fixed = TRUE)
})

test_that("`rm_file_ext()` removes the correct extension", {
  expect_equal(rm_file_ext("foo/bar.txt"), "foo/bar")
  expect_equal(rm_file_ext(c("foo.txt", "bar.csv")), c("foo", "bar"))  # vectorized
  expect_equal(rm_file_ext(c("foo/bar.txt", "bar/foo.csv")),
               c("foo/bar", "bar/foo"))
  expect_equal(rm_file_ext(""), "")
  expect_equal(rm_file_ext(""), "")
  expect_equal(rm_file_ext(NULL), character(0))
  expect_equal(rm_file_ext(NA_character_), NA_character_)
})

test_that("`rm_file_ext()` pulls the correct extension for compressed files", {
  expect_equal(rm_file_ext("foo.tar.gz"), "foo")
  expect_equal(rm_file_ext("foo.bz2.gz"), "foo")
  expect_equal(rm_file_ext("foo.bz2"), "foo")
  expect_equal(rm_file_ext("foo.xz.gz"), "foo")
  expect_equal(rm_file_ext("foo.xz"), "foo")
})

test_that("`set_file_ext()` adds the correct extension", {
  x <- set_file_ext("foo/bar.csv", "tsv")
  expect_path_equal(x, "foo/bar.tsv")
})

test_that("`set_file_ext()` and rm_file_ext() retrun identical if ext = ''", {
  expect_path_equal(set_file_ext("foo/bar.csv", ""), rm_file_ext("foo/bar.csv"))
})

test_that("`set_file_ext()` adds noting if ext is empty", {
  expect_path_equal(set_file_ext("foo/bar.csv", ""), "foo/bar")
})

test_that("`set_file_ext()` handles files passed as a list", {
  expect_path_equal(
    set_file_ext(list("foo.csv", "bar.csv"), "zip"),
    c("foo.zip", "bar.zip")
  )
  expect_path_equal(
    set_file_ext(list("foo.csv", NULL, "bar.csv"), "zip"),  # with NULL in list
    c("foo.zip", "bar.zip")
  )
})

test_that("`set_file_ext()` recycles ext argument if appropriate", {
  expect_s3_class(set_file_ext("foo.txt", "csv"), "helpr_path")
  expect_path_equal(
    set_file_ext(c("foo.txt", "bar.csv"), "csv"),
    c("foo.csv", "bar.csv")
  )
  # ext matched length 2 x 2
  expect_path_equal(
    set_file_ext(c("foo.txt", "bar.csv"), c("zip", "tsv")),
    c("foo.zip", "bar.tsv")
  )
})

test_that("`set_file_ext()` handles NAs correctly", {
  x <- set_file_ext(c("foo.txt", NA_character_, "bar.csv"), "R")
  expect_s3_class(x, "helpr_path")
  expect_path_equal(x, c("foo.R", NA_character_, "bar.R")
  )
})

test_that("`set_file_ext()` trips error if ext non-recyclable length", {
  expect_error(
    set_file_ext("foo.csv", c("txt", "zip")),
    "The `ext` length must match the number of files provided\\."
  )
})

test_that("`set_file_ext()` trips error bad ext argument passed", {
  expect_error(
    set_file_ext("foo.csv", NULL),
    "is.character(ext) is not TRUE", fixed = TRUE)
  expect_error(
    set_file_ext("foo.csv", NA),
    "is.character(ext) is not TRUE", fixed = TRUE)
  expect_error(
    set_file_ext("foo.csv", NA_character_),
    "!is.na(ext) is not TRUE", fixed = TRUE)
  expect_error(
    set_file_ext("foo.csv", 1),
    "is.character(ext) is not TRUE", fixed = TRUE)
})

test_that("`file_ext<-()` sets extension via assignment", {
  x <- "foo.txt"
  file_ext(x) <- "tar"
  expect_path_equal(x, "foo.tar")
  expect_error(
    file_ext(x) <- c("tar", "zip"),
    "The `ext` length must match the number of files provided\\."
  )
})

# Bytes ----
x <- 10^(0:9)

test_that("`as_helpr_bytes()` converts class", {
  expect_s3_class(as_helpr_bytes(x), "helpr_bytes")
})

test_that("`as_helpr_bytes()` accepts numerics and returns them unchanged", {
  expect_equal(unclass(as_helpr_bytes(123)), 123)
  expect_equal(unclass(as_helpr_bytes(123L)), 123)
})

test_that("`as_helpr_bytes()` converts character values to numeics", {
  expect_equal(unclass(as_helpr_bytes("1")), 1)
  expect_equal(unclass(as_helpr_bytes("1000")), 1000)
  expect_equal(unclass(as_helpr_bytes("1000000")), 1e+06)
})

test_that("`format.helpr_bytes()` formats values < 1024 to their identity values", {
  expect_equal(format(as_helpr_bytes(0)), "0")
  expect_equal(format(as_helpr_bytes(1)), "1B")
  expect_equal(format(as_helpr_bytes(1023)), "1023B")
})

test_that("`format.helpr_bytes()` formats values > 1024 to group and colors", {
  expect_snapshot(format(as_helpr_bytes(1024)))
  expect_snapshot(format(as_helpr_bytes(1025)))
  expect_snapshot(format(as_helpr_bytes(1024 * 1024)))
  expect_snapshot(format(as_helpr_bytes(2^16)))
  expect_snapshot(format(as_helpr_bytes(2^24)))
  expect_snapshot(format(as_helpr_bytes(2^24 + 555555)))
  expect_snapshot(format(as_helpr_bytes(2^32)))
  expect_snapshot(format(as_helpr_bytes(2^48)))
  expect_snapshot(format(as_helpr_bytes(2^64))) # 'E' is not colored
})

test_that("`format.helpr_bytes()` is vectorized and colored", {
  expect_snapshot(format(as_helpr_bytes(x)))
})

test_that("`format.helpr_bytes()` handles edge cases", {
  expect_equal(unclass(as_helpr_bytes(NA)), NA_real_)
  expect_equal(format(as_helpr_bytes(NA)), "NA")
  expect_equal(unclass(as_helpr_bytes(NaN)), NaN)
  expect_equal(format(as_helpr_bytes(NaN)), "NaN")
  expect_equal(unclass(as_helpr_bytes(NULL)), numeric(0))
  expect_equal(format(as_helpr_bytes(NULL)), character(0))
})

test_that("`helpr_bytes()` sum method is dispatched", {
  expect_equal(sum(as_helpr_bytes(0)), as_helpr_bytes(sum(0)))
  expect_equal(sum(as_helpr_bytes(1:10)), as_helpr_bytes(sum(1:10)))
  expect_equal(sum(as_helpr_bytes(c(1, NA))), as_helpr_bytes(NA_real_))
  expect_equal(unclass(sum(as_helpr_bytes(x))), sum(x))
  expect_snapshot(format(sum(as_helpr_bytes(x))))
})

test_that("`helpr_bytes()` min method is dispatched", {
  expect_equal(min(as_helpr_bytes(0)), as_helpr_bytes(0))
  expect_equal(min(as_helpr_bytes(c(1, 2))), as_helpr_bytes(1))
  expect_equal(min(as_helpr_bytes(c(1, NA))), as_helpr_bytes(NA_real_))
  expect_equal(unclass(min(as_helpr_bytes(x))), 1)
  expect_equal(format(min(as_helpr_bytes(x))), "1B")
})

test_that("`helpr_bytes()` max method is dispatched", {
  expect_equal(max(as_helpr_bytes(0)), as_helpr_bytes(0))
  expect_equal(max(as_helpr_bytes(c(1, 2))), as_helpr_bytes(2))
  expect_equal(max(as_helpr_bytes(c(1, NA))), as_helpr_bytes(NA_real_))
  expect_equal(unclass(max(as_helpr_bytes(x))), 1e+09)
  expect_snapshot(format(max(as_helpr_bytes(x))))
})

test_that("`[.as_helpr_bytes`", {
  x <- as_helpr_bytes(x)
  expect_equal(x[], x)
  expect_equal(x[5], as_helpr_bytes(10000))
  expect_equal(unclass(x[5]), 10000)
  expect_snapshot(format(x[5]))
  expect_equal(x[c(3, 6, 9)], as_helpr_bytes(c(1e+02, 1e+05, 1e+08)))
  expect_equal(unclass(x[c(3, 6, 9)]), c(1e+02, 1e+05, 1e+08))
  expect_snapshot(format(x[c(3, 6, 9)]))
})

test_that("`[[.as_helpr_bytes` retains the fs_bytes class", {
  x <- as_helpr_bytes(c(100, 200, 300))
  expect_equal(x[[1L]], as_helpr_bytes(100))
  expect_equal(x[[2L]], as_helpr_bytes(200))
  expect_equal(x[[3L]], as_helpr_bytes(300))
})
