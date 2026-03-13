# Special Infix Operators

A series of useful infix operators, aka "grapes", that can be used to
facilitate core functionality, test equality, perform set operations,
etc.

## Usage

``` r
x %||-% y

x %@@% y

x %@@% y <- value

x %==% y

x %!=% y

x %===% y

x %set% y

x %!set% y

x %[[% y
```

## Arguments

- x:

  The left hand side of the infix operator.

- y:

  The right hand side of the infix operator.

- value:

  New value for attribute `y`.

## Functions

- `x %||-% y`: A variant of base R `%||%` which returns the lhs also if
  the *length* of the rhs is zero, as well as if `NULL`.

- `x %@@% y`: A friendly version of `attr(x, y)` to extract `"@ribute"`
  elements. `y` can be unquoted.

- `` `%@@%`(x, y) <- value ``: Assign `"@ributes"` via infix operator. A
  friendly version of `attr(x, y) <- value`. `y` can be unquoted.

- `x %==% y`: A gentler logical test for equality of two objects.
  Attributes are *not* checked. Use `%===%` to check attributes.

- `x %!=% y`: A logical test that two objects are *not* equal.

- `x %===% y`: Also tests attributes of `x` and `y`.

- `x %set% y`: Subset values in `x` by `y`. Alias for `x[x %in% y]`.
  Similar to `intersect(x, y)` except names and class of `x` are
  maintained.

- `x %!set% y`: Subset values in `x` *not* in `y`. Alias for
  `x[!x %in% y]`. Similar to `setdiff(x, y)` except names and class of
  `x` are maintained.

- `x %[[% y`: Extracts the `i^th` element for each of `n` elements of a
  list or data frame, returning either a vector of length `n` or a
  single row data frame with `n` columns. More efficient alias for
  `purrr::map_*(x, y)`.

## See also

[`intersect()`](https://rdrr.io/r/base/sets.html),
[`setdiff()`](https://rdrr.io/r/base/sets.html),
[`all.equal()`](https://rdrr.io/r/base/all.equal.html),
[`isTRUE()`](https://rdrr.io/r/base/Logic.html)

## Examples

``` r
factor(1:3) %@@% levels
#> [1] "1" "2" "3"
factor(1:3, levels = LETTERS[1:3L]) %@@% levels
#> [1] "A" "B" "C"

mtcars %==% mtcars       # equal
#> [1] TRUE
cars2 <- mtcars
cars2 %@@% a <- "foo"  # attr assignment; with unquoted 'a'
mtcars %==% cars2        # attr not checked; TRUE
#> [1] TRUE
mtcars %===% cars2       # attr checked; FALSE
#> [1] FALSE

x <- list(a = "b", c = "d", e = "f")
x %set% c("a", "c", "d")   # 'c' match
#> $c
#> [1] "d"
#> 
x %!set% c("a", "c", "d")  # 'b' match
#> $a
#> [1] "b"
#> 
#> $e
#> [1] "f"
#> 
unlist(x) %!set% c("a", "c", "d")   # 'c' match; vector-vector
#>   a   e 
#> "b" "f" 

# extract elements of a list
x <- list(a = 1:3, b = 4:6, c = 7:9)
x %[[% 2L
#> a b c 
#> 2 5 8 

data.frame(x) %[[% 2L     # data frame -> same as x[2L, ]
#>   a b c
#> 2 2 5 8
```
