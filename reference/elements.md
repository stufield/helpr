# Easily Subset Elements of Objects

Alternatives to
[`purrr::keep()`](https://purrr.tidyverse.org/reference/keep.html),
[`purrr::discard()`](https://purrr.tidyverse.org/reference/keep.html),
and
[`purrr::compact()`](https://purrr.tidyverse.org/reference/keep.html),
but without having to load the purrr namespace. The syntax and behavior
is generally the same, with some exceptions (see `Details`). For
example, `compact_it()` is similar to
[`purrr::compact()`](https://purrr.tidyverse.org/reference/keep.html),
however only supports the default behavior where non-empty elements are
retained.

## Usage

``` r
keep_it(x, lgl, ...)

discard_it(x, lgl, ...)

compact_it(x)
```

## Arguments

- x:

  A list, data frame, or vector.

- lgl:

  `logical(n)`. A vector or a function that returns a logical vector
  when applied to the elements of `x`.

- ...:

  Named arguments passed to `lgl` if it is a function.

## Details

These functions are not a simple drop-in replacement, as they do not
support quasi-quotation or formula syntax, but should be a sufficient
replacement in most cases.

## Functions

- `keep_it()`: keeps elements corresponding to `lgl`.

- `discard_it()`: the inverse of `keep_it()`.

- `compact_it()`: subsets elements that have non-zero length.

## purrr analogues

|                |                                                                       |
|----------------|-----------------------------------------------------------------------|
| helpr          | purrr                                                                 |
| `keep_it()`    | [`purrr::keep()`](https://purrr.tidyverse.org/reference/keep.html)    |
| `discard_it()` | [`purrr::discard()`](https://purrr.tidyverse.org/reference/keep.html) |
| `compact_it()` | [`purrr::compact()`](https://purrr.tidyverse.org/reference/keep.html) |

## Examples

``` r
# pass a logical vector
lst <- list(A = 1, B = 2, C = 3)
keep_it(lst, c(TRUE, FALSE, TRUE))
#> $A
#> [1] 1
#> 
#> $C
#> [1] 3
#> 

# logical vector on-the-fly
vec <- unlist(lst)
keep_it(vec, vec != 2)
#> A C 
#> 1 3 

# subset itself
keep_it(c(a = TRUE, b = FALSE, c = TRUE), identity)
#>    a    c 
#> TRUE TRUE 

# pass a simple function
lst <- replicate(10, sample(10, 5), simplify = FALSE)
keep_it(lst, function(x) mean(x) > 6)
#> [[1]]
#> [1]  6 10  8  9  3
#> 

# will work on data frames
df <- data.frame(a = 5, b = 2, c = 10)
keep_it(df, function(x) x >= 5)
#>   a  c
#> 1 5 10

df <- data.frame(a = "A", b = "B", c = 10, d = 20)
keep_it(df, is.numeric)
#>    c  d
#> 1 10 20

# compact_it() selects elements with non-zero length
lst <- list(A = 5, B = character(0), C = 6, D = NULL, E = NA, F = list())
compact_it(lst)
#> $A
#> [1] 5
#> 
#> $C
#> [1] 6
#> 
#> $E
#> [1] NA
#> 
# discard_it() works nicely with `be_safe()`
.f <- be_safe(log10)
res <- .f("5")
discard_it(res, is.null)
#> $error
#> [1] "non-numeric argument to mathematical function"
#> 
```
