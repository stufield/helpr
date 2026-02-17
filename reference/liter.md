# List Iteration

`piter()` iterates over an arbitrary number of list elements evaluating
identically indexed components and is an analogue to
[`purrr::pmap()`](https://purrr.tidyverse.org/reference/pmap.html)
without loading the purrr namespace. `liter()` is a thin wrapper around
[`mapply()`](https://rdrr.io/r/base/mapply.html) intended specifically
for *paired* `.x` and `.y` values (similar to
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html)). If
`.y` is missing and `.x` is named, this is equal to
`liter(.x, names(.x), ...)`, which is the behavior of
[`purrr::imap()`](https://purrr.tidyverse.org/reference/imap.html). Both
`piter()` and `liter()` support the formula construction (`~`).

## Usage

``` r
liter(.x, .y = NULL, .f, ...)

piter(.l, .f, ...)
```

## Arguments

- .x, .y:

  Vectors or objects of the same length.

- .f:

  A function to be applied to each element of `x`.

- ...:

  Additional arguments passed to `.f`.

- .l:

  A *named* list of elements, each to iterate over. Must have the same
  length. Also supports a data frame, whose rows will iterate over using
  names as parameters.

## Value

Both functions always return a list, sometimes named if possible by
rules similar to [`sapply()`](https://rdrr.io/r/base/lapply.html).

## Functions

- `piter()`: `piter()` iterates over a *named* list of identical
  lengths.

## Examples

``` r
x <- LETTERS
names(x) <- letters
liter(x, 1:26, paste, sep = "-") |> head()
#> $a
#> [1] "A-1"
#> 
#> $b
#> [1] "B-2"
#> 
#> $c
#> [1] "C-3"
#> 
#> $d
#> [1] "D-4"
#> 
#> $e
#> [1] "E-5"
#> 
#> $f
#> [1] "F-6"
#> 

# .y = NULL; uses names(.x)
liter(x, .f = paste, sep = "-") |> head()
#> $a
#> [1] "A-a"
#> 
#> $b
#> [1] "B-b"
#> 
#> $c
#> [1] "C-c"
#> 
#> $d
#> [1] "D-d"
#> 
#> $e
#> [1] "E-e"
#> 
#> $f
#> [1] "F-f"
#> 

# .y = index 1:3
liter(c("a", "b" , "c"), .f = paste, sep = "=")
#> $a
#> [1] "a=1"
#> 
#> $b
#> [1] "b=2"
#> 
#> $c
#> [1] "c=3"
#> 

# anonymous on-the-fly .f()
v <- rnorm(6)
liter(1:6, v, function(a, b) a + b^2) |> unlist()
#> [1] 1.173273 2.013003 3.004086 4.845172 5.812405 6.636370

# if .y is explicit; formula syntax
# must use `.x` and `.y` in formula
liter(1:6, v, ~ .x + .y^2) |> unlist()
#> [1] 1.173273 2.013003 3.004086 4.845172 5.812405 6.636370

piter(list(a = head(LETTERS), b = head(letters)), function(a, b) paste0(a, b)) |>
  unlist()
#>    A    B    C    D    E    F 
#> "Aa" "Bb" "Cc" "Dd" "Ee" "Ff" 

# supports ~formula syntax
piter(list(a = head(LETTERS), b = head(letters)), ~ paste0(a, b)) |> unlist()
#>    A    B    C    D    E    F 
#> "Aa" "Bb" "Cc" "Dd" "Ee" "Ff" 

# supports data frames
df <- data.frame(a = head(LETTERS), b = rev(tail(letters)))
piter(df, ~ paste0(a, b)) |> unlist()
#>    A    B    C    D    E    F 
#> "Az" "By" "Cx" "Dw" "Ev" "Fu" 
```
