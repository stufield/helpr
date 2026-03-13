# Unit Test Helpers

Manage whether certain tests are skipped during `devtools::check()`,
`devtools::test()`, or during a temporary automated pipeline builds.
This may be desired if certain tests are time consuming or special
environment characteristics make them undesirable. See
[`testthat::skip_if()`](https://testthat.r-lib.org/reference/skip.html)
and
[`testthat::skip_on_cran()`](https://testthat.r-lib.org/reference/skip.html)
for details.

## Usage

``` r
expect_error_free(...)

skip_on_check()

skip_on_test()

expect_snapshot_plot(code, name, type = c("png", "pdf"), ...)
```

## Arguments

- ...:

  Arguments passed to
  [`testthat::expect_no_error()`](https://testthat.r-lib.org/reference/expect_no_error.html)
  or the logical `gg =` param if in `expect_snapshot_plot()`.

- code:

  The code to execute.

- name:

  `character(1)`. A temporary file name to use during the test.

- type:

  `character(1)`. Either `"png"` or `"pdf"`.

## References

https://testthat.r-lib.org/reference/expect_snapshot_file.html
