# Create a Jagged Tibble

Combine a list of uneven (jagged) vectors into one 2-dim object,
`tibble` or `data frame`, and fill in lengths with `NA`.

## Usage

``` r
jagged_tbl(x)
```

## Arguments

- x:

  A *named* list of vectors with unequal lengths, to be recast as a
  `tibble`.

## Value

A `tibble` object with dimensions `c(max(lengths(x)), length(x))`. Extra
entries are replaced with `NA`.

## Author

Stu Field

## Examples

``` r
p <- 5   # cols
n <- 10  # rows
x <- replicate(p, sample(1:1000, sample(1:n, 1))) |>
  set_Names(paste0("v", seq(p)))

tbl <- jagged_tbl(x)
tbl
#> # A tibble: 10 × 5
#>       v1    v2    v3    v4    v5
#>    <int> <int> <int> <int> <int>
#>  1   162   939   341   622   188
#>  2   499   656   624   100    55
#>  3   414   848   234   153    75
#>  4   223   353   980   469   656
#>  5    30   240   443    92   780
#>  6    NA   591   603   494    35
#>  7    NA    57   472    86   648
#>  8    NA   271   555   415    NA
#>  9    NA    NA   293   884    NA
#> 10    NA    NA   458    81    NA
```
