# Write to a Text File

Writes as UTF-8 encoding and with `\n` line endings on UNIX systems and
`\r\n` on Windows. This avoids some of the unintended side-effects of
`usethis::write_over()` with R-projects.

## Usage

``` r
write_text(path, lines, overwrite = FALSE)

read_text(path, n = -1L)

write_latex_tbl(
  data,
  path,
  append = FALSE,
  include_rn = TRUE,
  rn_label = "",
  caption = NULL,
  long = FALSE,
  ...
)
```

## Arguments

- path:

  Path to target file. It is created if it does not exist, but the
  parent directory must exist.

- lines:

  Character vector of lines. For `write_union()`, these are lines to add
  to the target file, if not already present. For `write_over()`, these
  are the exact lines desired in the target file.

- overwrite:

  `logical(1)`. If file exists, over-write it?

- n:

  integer. The (maximal) number of lines to read. Negative values
  indicate that one should read up to the end of input on the
  connection.

- data:

  An object that inherits from class `data.frame`.

- append:

  `logical(1)`. See
  [`write.table()`](https://rdrr.io/r/utils/write.table.html).

- include_rn:

  `logical(1)`. Should the row names (if present) of `data` be included?
  Passed to [`write.table()`](https://rdrr.io/r/utils/write.table.html)
  as `row.names =` parameter.

- rn_label:

  `character(1)`. If row names are to be included, the column title to
  be used.

- caption:

  `character(1)`. A caption for the table once in *LaTeX* format.

- long:

  `logical(1)`. Should the table be written in long format. Better for
  very data frames with many rows.

- ...:

  Arguments passed to
  [`write.table()`](https://rdrr.io/r/utils/write.table.html).

## Functions

- `read_text()`: a convenient wrapper to
  [`readLines()`](https://rdrr.io/r/base/readLines.html) with default
  UTF-8 encoding for reading text into an R session.

- `write_latex_tbl()`: write the contents of a data frame to a *LaTeX*
  table.
