# Set Names of an Object

Similar to [`stats::setNames()`](https://rdrr.io/r/stats/setNames.html),
but with more features. You can specify names in the following ways: \*
a character vector (recycled if `length(nms) != length(x)`) \* a
function to be applied to names of `x` \* via `...` if not passing a
function, `c(nms, ...)`

## Usage

``` r
set_Names(x, nms = x, ...)
```

## Arguments

- x:

  An R object to name.

- nms:

  The names to apply to `x`. If empty, names are "self" applied.
  Alternatively a function to be applied to the names.

- ...:

  Arguments passed to `nms` if a function.

## Examples

``` r
set_Names(head(letters), head(LETTERS)) # apply names
#>   A   B   C   D   E   F 
#> "a" "b" "c" "d" "e" "f" 

set_Names(head(letters))                # names self
#>   a   b   c   d   e   f 
#> "a" "b" "c" "d" "e" "f" 

set_Names(head(letters), toupper)       # apply fn
#>   A   B   C   D   E   F 
#> "a" "b" "c" "d" "e" "f" 

set_Names(set_Names(head(letters)), NULL)     # NULL always removes names
#> [1] "a" "b" "c" "d" "e" "f"

set_Names(head(letters), "foo")               # repeat to length
#> foo foo foo foo foo foo 
#> "a" "b" "c" "d" "e" "f" 

set_Names(head(letters), c("foo", "bar"))     # repeat to length
#> foo bar foo bar foo bar 
#> "a" "b" "c" "d" "e" "f" 

set_Names(head(letters), "foo", "bar", "baz") # repeat to length via `...`
#> foo bar baz foo bar baz 
#> "a" "b" "c" "d" "e" "f" 
```
