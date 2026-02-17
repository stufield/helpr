# Calculate the Sum of Squared Errors

Calculates the sum of the squared errors (SSE) for a vector of numeric
data.

## Usage

``` r
calc_ss(x)
```

## Arguments

- x:

  A numeric vector of data.

## Value

The Sum of Squared Errors (SSE) of `x`.

## Author

Stu Field

## Examples

``` r
calc_ss(rnorm(100, 50, 5))
#> [1] 2481.844
```
