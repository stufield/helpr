# Save Compressed `*.rds` File

A thin wrapper around [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)
that ensures two things:

- The path extension is consistent and lowercase `*.rds`

- The compression used is `"xz"`, which is often optimal for proteomic
  data

## Usage

``` r
save_rds(object, file)

save_rda(..., file)

get_compression(file)
```

## Arguments

- object:

  R object to serialize.

- file:

  a [connection](https://rdrr.io/r/base/connections.html) or the name of
  the file where the R object is saved to or read from.

- ...:

  the names of the objects to be saved (as symbols or character
  strings).

## Value

Returns `file`, invisibly.

## Functions

- `save_rda()`: similar to `save_rds()`, but for saving serialized
  `*.rda` compressed files.

- `get_compression()`: determine the type of compression for a
  serialized binary file.

## Examples

``` r
if (FALSE) { # \dontrun{
# all are the same
save_rds(x, "outfile.rds")
save_rds(x, "outfile.RDS")
save_rds(x, "outfile.Rds")

# similar functionality for rda
# as with `save()`, must specify file argument explicitly
save_rda(x, file = "outfile.rda")

# determine the compression ('xz')
get_compression("outfile.rda")
} # }
```
