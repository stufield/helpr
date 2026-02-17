# Calculate Robust Gaussian Estimates

Estimates parameters of the Gaussian distribution (\\\mu\\, \\\sigma\\)
via non-linear least-squares, making Gaussian assumptions of the error
function, see [`pnorm()`](https://rdrr.io/r/stats/Normal.html). Initial
starting values are chosen via robust estimates,
[`median()`](https://rdrr.io/r/stats/median.html) and
[`mad()`](https://rdrr.io/r/stats/mad.html). If `mad = TRUE`, these
starting values are returned.

## Usage

``` r
fit_gauss(x, mad = FALSE)
```

## Arguments

- x:

  `numeric(n)`. A vector of numeric values to fit to Gaussian
  assumptions.

- mad:

  `logical(1)`. Should [`median()`](https://rdrr.io/r/stats/median.html)
  and [`mad()`](https://rdrr.io/r/stats/mad.html) `* 1.4826` be used as
  robust (i.e. distribution-free) estimates of population mean and
  standard deviation?

## Value

A named vector consisting of non-linear least-squares estimates of `mu`
and `sigma` for `x`.

## See also

[`nls()`](https://rdrr.io/r/stats/nls.html),
[`pnorm()`](https://rdrr.io/r/stats/Normal.html)

## Author

Stu Field

## Examples

``` r
x <- rnorm(100, 25, 3)
fit_gauss(x)
#>        mu     sigma 
#> 24.317513  2.956924 
fit_gauss(x, mad = TRUE)
#>        mu     sigma 
#> 24.485358  3.111577 
```
