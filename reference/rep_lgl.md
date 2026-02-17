# All Values Same

Returns a boolean testing if all values of a vector are identical. This
function does NOT compare two independent vectors. Use
`isTRUE(all.equal())` for such comparisons.

## Usage

``` r
rep_lgl(x)
```

## Arguments

- x:

  A vector of values. Can be one of: `numeric`, `character`, `factor`,
  or `logical`. If the vector is type `double` and NA values are
  present, they are first removed.

## Value

`logical(1)`.

## See also

[`rep()`](https://rdrr.io/r/base/rep.html),
[`isTRUE()`](https://rdrr.io/r/base/Logic.html),
[`all.equal()`](https://rdrr.io/r/base/all.equal.html)

## Author

Stu Field

## Examples

``` r
rep_lgl(1:4)
#> [1] FALSE

rep_lgl(rep(5, 10))
#> [1] TRUE

rep_lgl(rep("A", 10))
#> [1] TRUE

rep_lgl(letters)
#> [1] FALSE

rep_lgl(c(TRUE, TRUE, TRUE))
#> [1] TRUE

rep_lgl(c(TRUE, TRUE, FALSE))
#> [1] FALSE
```
