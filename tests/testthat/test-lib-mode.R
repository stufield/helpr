
# Setup ----
withr::local_options(list(signal.quiet = TRUE))   # silence signalling
libdir <- test_path("lib-testing")
dir.create(libdir, mode = "755", showWarnings = FALSE)
withr::defer(unlink(libdir, recursive = TRUE, force = TRUE))

# Testing ----
test_that("`lib_mode()` runs in base mode in any project", {
  withr::local_dir(libdir)
  dir.create("base-lib")
  expect_false(is_lib_mode())             # FALSE: not yet init
  expect_no_error(lib_mode("base-lib")) # ON: expect no errors
  expect_true(is_lib_mode())              # TRUE: now on
  expect_true(normalizePath("base-lib") %in% lib_tree())
  expect_equal(getOption("tmp_helpr_path"), normalizePath("base-lib"))
  expect_no_error(lib_mode("base-lib")) # OFF: expect no errors
  expect_false(is_lib_mode())             # FALSE: now off again
  expect_false(normalizePath("base-lib") %in% lib_tree())
  expect_null(getOption("helpr_path"))    # path option unset; reverts
})

test_that("`lib_mode()` defaults behave as expected", {
  path <- file.path(libdir, "analysis")
  dir.create(path, mode = "755")           # create analysis dir
  withr::local_dir(path)                   # and switch to it
  expect_false(dir.exists("aux-lib"))      # expect dir absent
  expect_false(is_lib_mode())              # FALSE: not yet init
  expect_no_error(lib_mode())            # ON: expect no errors
  expect_true(is_lib_mode())               # TRUE: now on
  expect_true(normalizePath("aux-lib") %in% lib_tree())
  expect_equal(getOption("tmp_helpr_path"), normalizePath("aux-lib"))
  expect_true(dir.exists("aux-lib"))       # new dir now exists
  expect_no_error(lib_mode())            # OFF: expect no errors
  expect_false(is_lib_mode())              # FALSE: not yet init
  expect_false(normalizePath("aux-lib") %in% lib_tree())
  expect_true(dir.exists("aux-lib"))       # new dir persists after mode OFF
  expect_null(getOption("helpr_path"))     # path option unset; reverts
})

test_that("is_lib() testing", {
  path <- file.path(libdir, "is-lib")
  dir.create(path, mode = "755")
  expect_true(is_lib(path))    # empty could be a library
  dir.create(file.path(path, "foo"), mode = "755")
  expect_false(is_lib(path))   # foo/ has no Meta/ sub-directory
  dir.create(file.path(path, "foo", "Meta"), mode = "755")
  expect_true(is_lib(path))    # now foo/ has Meta/ sub-directory
  dir.create(file.path(path, "bar"), mode = "755")
  expect_false(is_lib(path))   # bar/ doesn't have Meta/ sub-directory (all must)
})

test_that("using the `getOption('helpr_path')` option", {
  path <- file.path(libdir, "my-lib-test-foo-blah")
  dir.create(path)
  withr::with_options(list(helpr_path = path), lib_mode())
  expect_true(normalizePath(path) %in% lib_tree())
})

test_that("error tripped if passed `path` does not exist or `length > 1`", {
  expect_error(
    lib_mode("abcd"), "Please create 'abcd'"
  )
  expect_error(
    lib_mode(letters),
    "`path` must be a single path to a valid directory."
  )
  expect_error(
    lib_mode(NA_character_),
    "`path` must be a single path to a valid directory."
  )
})

test_that("warning condition triggered", {
  path <- file.path(libdir, "warning-trigger")
  dir.create(file.path(path, "pkg"), recursive = TRUE)
  file.create(file.path(path, "foo.txt"))      # file indicates not a lib
  expect_warning(
    withr::with_dir(libdir, lib_mode("warning-trigger")),
    "does not appear to be a library. Are sure you specified the correct directory?"
  )
  dir.create(file.path(path, "pkg", "Meta"))   # now looks like a lib
  expect_warning(withr::with_dir(libdir, lib_mode("warning-trigger")), NA)
})
