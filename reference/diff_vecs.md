# Diff Two Vectors

A convenient diff tool to determine how and where two character vectors
differ.

## Usage

``` r
diff_vecs(x, y, verbose = interactive())
```

## Arguments

- x:

  `character(n)`. First vector to compare.

- y:

  `character(n)`. Second vector to compare.

- verbose:

  `logical(1).` Should diff summary be printed directly to the console?
  Is `TRUE` for interactive sessions.

## Value

An invisible list is returned with the set diffs of each vector. The
elements of the list are:

- unique_x::

  Entries unique to `x`.

- unique_y::

  Entries unique to `y`.

- inter::

  The intersect `x` and `y`.

- unique::

  The [`union()`](https://rdrr.io/r/base/sets.html) of `x` and `y`.

## See also

[`setdiff()`](https://rdrr.io/r/base/sets.html),
[`union()`](https://rdrr.io/r/base/sets.html),
[`intersect()`](https://rdrr.io/r/base/sets.html)

## Author

Stu Field

## Examples

``` r
diff_vecs(LETTERS[1:10L], LETTERS[5:15L])

diffs <- diff_vecs(LETTERS[1:10L], LETTERS[5:15L], verbose = FALSE)
diffs
#> $`unique_LETTERS[1:10L]`
#> [1] "A" "B" "C" "D"
#> 
#> $`unique_LETTERS[5:15L]`
#> [1] "K" "L" "M" "N" "O"
#> 
#> $inter
#> [1] "E" "F" "G" "H" "I" "J"
#> 
#> $unique
#>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O"
#> 
```
