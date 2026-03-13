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
#> # A tibble: 9 × 5
#>      v1    v2    v3    v4    v5
#>   <int> <int> <int> <int> <int>
#> 1   353   381   499   162   939
#> 2   891   586   208   499   656
#> 3    55    38   672   414   848
#> 4   869   578  1000   223   353
#> 5   270   710   297    30   240
#> 6    68   912   552    NA   591
#> 7    NA     8   256    NA    57
#> 8    NA    NA    48    NA   271
#> 9    NA    NA   194    NA    NA
```
