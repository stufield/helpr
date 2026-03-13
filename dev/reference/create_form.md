# Create A Formula

A convenient utility to quickly generate formula objects in a
standardized format and environment.

## Usage

``` r
create_form(response, features, collapse = c("+", "*"), env = NULL)
```

## Arguments

- response:

  A quoted string representing the LHS of the formula, i.e. the response
  variable (`Y`).

- features:

  A vector of quoted strings representing the model features/predictors.
  Used to generate the right-hand side (RHS) of the formula.

- collapse:

  `character(1)`. The separator for features. Typically either `+` for
  main effects, `*` for interactions.

- env:

  The environment in which to evaluate the formula. To keep the formula
  object as light-weight as possible, the default is the current
  function environment/scope. However, some occasions (e.g. unit
  testing) may require the formula's environment to capture certain
  objects necessary to fit a model (e.g. weights).

## Value

A stats formula. See
[`formula()`](https://rdrr.io/r/stats/formula.html).

## See also

[`eval()`](https://rdrr.io/r/base/eval.html),
[`environment()`](https://rdrr.io/r/base/environment.html)

## Author

Stu Field

## Examples

``` r
ft <- c("ft_1234.56", "ft_8899.8", "ft_3334.3")
f1 <- create_form("class", ft)
print(f1, showEnv = FALSE)
#> class ~ ft_1234.56 + ft_8899.8 + ft_3334.3

# environment manipulation
# cleanest light-weight formula (default)
ls(environment(f1))
#> [1] "env"  "expr"

# capture another environment
e     <- new.env()
e$new <- LETTERS
e$obj <- rnorm(100)
f2    <- create_form("class", ft, env = e)
ls(environment(f2))
#> [1] "new" "obj"
```
