# Write List to CSV File

Write a list of data frames of vectors (or a mixture of both) to a
single `*.csv` file.

## Usage

``` r
write_list(x, file, rn_title = NULL, append = FALSE, ...)
```

## Arguments

- x:

  A list to be written to file, typically a list of data frames.

- file:

  either a character string naming a file or a
  [connection](https://rdrr.io/r/base/connections.html) open for
  writing. `""` indicates output to the console.

- rn_title:

  A title for the row names column (for data frames). Must match the
  length of the `x` argument.

- append:

  logical. Only relevant if `file` is a character string. If `TRUE`, the
  output is appended to the file. If `FALSE`, any existing file of the
  name is destroyed.

- ...:

  Additional arguments passed to
  [`write.table()`](https://rdrr.io/r/utils/write.table.html).

## Value

The `file`, invisibly.

## See also

[`write.table()`](https://rdrr.io/r/utils/write.table.html),
[`file()`](https://rdrr.io/r/base/connections.html)

## Author

Stu Field

## Examples

``` r
tmp <- lapply(LETTERS[1:5], function(x) rnorm(10, mean = 10, sd = 3))
names(tmp) <- LETTERS[1:5]
write_list(tmp, file = tempfile(fileext = ".csv"))
#> ✓ Writing 'tmp' to: '/var/folders/w0/cd8qgn052r16zsblrrxl1gxw0000gn/T//RtmpDmFy8T/file116e4af9687.csv'

# with a data frame in list
tmp$mtcars <- head(mtcars, 10)
write_list(tmp, file = tempfile(fileext = ".csv"))
#> ✓ Writing 'tmp' to: '/var/folders/w0/cd8qgn052r16zsblrrxl1gxw0000gn/T//RtmpDmFy8T/file116e23c37b78.csv'
```
