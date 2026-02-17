# Dynamic List Param Collection Rename Elements of a List

Helper to collect the `...` params internally passed that support
non-standard evaluation and splicing. See
[`rlang::dots_list()`](https://rlang.r-lib.org/reference/list2.html) and
[`rlang::list2()`](https://rlang.r-lib.org/reference/list2.html). In
general this is a stripped down version to avoid the `rlang` import
keeping the package footprint minimal.

## Usage

``` r
dots_list2(...)
```

## Arguments

- ...:

  Arguments to collect in a list. These arguments are dynamic

## Value

A named list corresponding to the expressions passed to the `...`
inputs.

## Examples

``` r
foo <- function(...) {
  print(dots_list2(...))
  invisible()
}
foo(a = 2, b = 4)
#> $a
#> [1] 2
#> 
#> $b
#> [1] 4
#> 

foo(a = 2, b = 4, fun = function(x) mean(x))
#> $a
#> [1] 2
#> 
#> $b
#> [1] 4
#> 
#> $fun
#> function (x) 
#> mean(x)
#> <environment: 0x12f18b348>
#> 

foo(data.frame(a = 1, b = 2), data.frame(a = 8, b = 4))
#> [[1]]
#>   a b
#> 1 1 2
#> 
#> [[2]]
#>   a b
#> 1 8 4
#> 

# supports !!! splicing
args <- list(a = 2, b = 4, fun = function(x) mean(x))
foo(!!!args)
#> $a
#> [1] 2
#> 
#> $b
#> [1] 4
#> 
#> $fun
#> function (x) 
#> mean(x)
#> <environment: 0x12f18b348>
#> 
```
