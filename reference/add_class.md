# Add a Class to an Object

Utility to *prepend* a new class(es) to existing objects.

## Usage

``` r
add_class(x, class)
```

## Arguments

- x:

  The object to receive new class(es).

- class:

  `character(n)`. The name of additional class(es).

## Value

An object with new classes.

## See also

[`class()`](https://rdrr.io/r/base/class.html),
[`typeof()`](https://rdrr.io/r/base/typeof.html),
[`structure()`](https://rdrr.io/r/base/structure.html)

## Author

Stu Field

## Examples

``` r
class(iris)
#> [1] "data.frame"

add_class(iris, "new") |> class()
#> [1] "new"        "data.frame"

add_class(iris, c("A", "B")) |> class()    # 2 classes
#> [1] "A"          "B"          "data.frame"

add_class(iris, c("A", "data.frame")) |> class()    # no duplicates
#> [1] "A"          "data.frame"

add_class(iris, c("data.frame", "A")) |> class()    # re-orders if exists
#> [1] "data.frame" "A"         
```
