# Standardize Date Format

A convenient wrapper to print the current date in a consistent format
for all package suite functionality.

## Usage

``` r
dater(x = "%Y-%m-%d")
```

## Arguments

- x:

  An alternative format to the standard format.

## Value

The current date in `YYYY-MM-DD` format (default).

## See also

[`format()`](https://rdrr.io/r/base/format.html)

## Examples

``` r
# with default format
dater()
#> [1] "2026-03-13"

# pass alternative format
dater("%Y-%m-%d || %H:%M:%S")
#> [1] "2026-03-13 || 22:38:14"
```
