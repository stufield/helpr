# Logical Testing

These functional checks return boolean `TRUE/FALSE` depending on the
result of their test.

## Usage

``` r
is_int_vec(x)

is_logspace(x)

is_monotonic(x)

has_length(x)

len_one(x)

is_chr(x)

is_dbl(x)

is_lgl(x)

is_int(x)
```

## Arguments

- x:

  A vector, data frame or `tibble` to be tested.

## Value

Logical/boolean

## Functions

- `is_int_vec()`: A general test of whether a numeric vector object
  contains only integer values. This is a fix for the generally
  undesired behavior of
  [`is.integer()`](https://rdrr.io/r/base/integer.html) which doesn't
  actually test for integer numbers (see its ?help).

- `is_logspace()`: Checks if an object containing numeric data is
  already in log space. This check assumes proteomic measurements and
  that the vector median, or the entire data matrix, will be greater
  than 15 if in linear space and less than 10 if log10-transformed.

- `is_monotonic()`: A general test of whether the numeric vector `x` is
  monotonically *increasing* or *decreasing* in value.

- `has_length()`: check that `length > 0`.

- `len_one()`: check that length = 1.

- `is_chr()`: check for scalar + character type.

- `is_dbl()`: check for scalar + double type.

- `is_lgl()`: check for scalar + logical type.

- `is_int()`: check for scalar + integer type.

## See also

[`floor()`](https://rdrr.io/r/base/Round.html),
[`is.integer()`](https://rdrr.io/r/base/integer.html),
[`all()`](https://rdrr.io/r/base/all.html),
[`is.numeric()`](https://rdrr.io/r/base/numeric.html)

[`diff()`](https://rdrr.io/r/base/diff.html),
[`all()`](https://rdrr.io/r/base/all.html)

## Author

Stu Field

## Examples

``` r
is_int_vec(10)         # does not return TRUE
#> [1] TRUE
is_int_vec(10L)        # does not return TRUE
#> [1] TRUE
is_int_vec(10)
#> [1] TRUE
is_int_vec(1:10)
#> [1] TRUE
is_int_vec(c(3.2, 1:10))
#> [1] FALSE
is_int_vec(rnorm(10))
#> [1] FALSE

# log-space
x <- rnorm(30, mean = 1000)
is_logspace(x)
#> [1] FALSE
is_logspace(log(x))
#> [1] TRUE

df <- data.frame(a = 1:5, ft_1234 = round(rnorm(5, mean = 5000, sd = 100), 1))
is_logspace(df)
#> [1] FALSE
df <- data.frame(a = 1:5, ft_3456 = round(rnorm(5, mean = 3, sd = 1), 1))
is_logspace(df)
#> [1] TRUE

# monotonic
is_monotonic(1:10)      # TRUE
#> [1] TRUE
is_monotonic(10:1)      # TRUE
#> [1] TRUE
is_monotonic(rnorm(10)) # FALSE
#> [1] FALSE
is_monotonic(seq(10, -10, by = -1)) # TRUE
#> [1] TRUE
```
