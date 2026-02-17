# Calculate Concordance Correlation Coefficient

Calculate the concordance correlation coefficient (CCC) and it's
significance value from two vectors of related data.

## Usage

``` r
calc_ccc(x, y)
```

## Arguments

- x, y:

  `numeric(n)` vectors of the same length.

## Value

A list of the following:

- rho.c::

  The concordance correlation coefficient (CCC).

- ci95::

  The 95 percent confidence intervals of the CCC.

- Z::

  The z-score of the CCC.

- p.value::

  The p-value corresponding to the Z-score.

## References

Lawrence Lin, Biometrics (45): 255-268.

## See also

[`cor()`](https://rdrr.io/r/stats/cor.html),
[`pnorm()`](https://rdrr.io/r/stats/Normal.html)

## Author

Stu Field

## Examples

``` r
calc_ccc(rnorm(100), rnorm(100))
#> $rho_c
#> [1] -0.03993185
#> 
#> $ci95
#>      lower      upper 
#> -0.2331064  0.1562745 
#> 
#> $Z
#> [1] -0.0399531
#> 
#> $p_value
#> [1] 0.9681305
#> 

v <- rnorm(100)
calc_ccc(v, v + 1)
#> $rho_c
#> [1] 0.6843539
#> 
#> $ci95
#>     lower     upper 
#> 0.6190700 0.7402445 
#> 
#> $Z
#> [1] 0.8372579
#> 
#> $p_value
#> [1] 0.4024476
#> 
```
