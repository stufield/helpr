# Get Indices of Statistical Outliers

Calculates the indices of a vector of values that exceed a specified
statistical outlier criterion. This criterion is defined by differently
depending on the type of outlier detection implemented (see section on
outlier detection below).

## Usage

``` r
get_outliers(
  x,
  n_sigma = 3,
  mad_crit = 6,
  fold_crit = 5,
  type = c("nonparametric", "parametric")
)
```

## Arguments

- x:

  \`numeric(n). A vector of values to evaluate.

- n_sigma:

  `numeric(1)`. The the number of standard deviations from the mean a
  `n_sigma` threshold for outliers. Ignored if `type = "nonparametric"`.

- mad_crit:

  The median absolute deviation ("MAD") criterion to use. Ignored if
  `type = "parametric"`. Defaults to `(6 * mad)`.

- fold_crit:

  The fold-change criterion to evaluate. Ignored if
  `type = "parametric"`. Defaults to `5x`.

- type:

  `character(1)`. Matched. Either "parametric" or "nonparametric" to
  determine the type of outliers detection implementation.

## Value

If "nonparametric": an integer vector of indices corresponding to
detected outliers.

If "parametric": an integer vector of indices with these additional
attributes:

- mu:

  the robustly fit mean (\\\mu\\).

- sigma:

  the robustly fit standard deviation (\\\sigma\\).

- crit:

  the 2 critical values beyond which a value is considered an outlier.

## outlier detection

There are 2 possible methods used to define an outlier measurement and
the return value depends on which method is implemented:

1.  The non-parametric case (default): agnostic to the distribution.
    Outlier measurements are defined as falling outside `mad_crit * mad`
    from the median *and* a specified number of fold-changes from the
    median (i.e. `fold_crit`; e.g. \\5x\\).  
    **Note:** `n_sigma` is ignored.

2.  The parametric case: the mean and standard deviation are calculated
    robustly via
    [`fit_gauss()`](https://stufield.github.io/helpr/reference/fit_gauss.md).
    Outliers are defined as measurements falling *outside* +/- `n_sigma`
    \* \\\sigma\\ from the the estimated \\\mu\\.  
    **Note:** `mad_crit` and `fold_crit` are ignored.

## See also

[`fit_gauss()`](https://stufield.github.io/helpr/reference/fit_gauss.md)

## Author

Stu Field

## Examples

``` r
withr::with_seed(101, {
  x <- rnorm(26, 15, 2)         # Gaussian
  x <- c(2, 2.5, x, 25, 25.9)   # add 4 outliers (2hi, 2lo)
})
get_outliers(x)                # non-parametric (default)
#> [1] 1 2
get_outliers(x, type = "para") # parametric
#> [1]  1  2 29 30
#> attr(,"mu")
#> [1] 14.66106
#> attr(,"sigma")
#> [1] 2.237713
#> attr(,"crit")
#> [1]  7.947922 21.374201
```
