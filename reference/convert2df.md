# Convert R Objects to a Data Frame

Attempt to "smartly" convert an arbitrary object into a `data.frame`
object while keep the dimensions of the same style.

## Usage

``` r
convert2df(x)
```

## Arguments

- x:

  One of the following classes:

  - `list`

  - `table`

  - `matrix`

  - `numeric`

  - `integer`

  - `factor`

  - `character`

## Value

`x`, converted into a `data.frame`.

## See also

[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html)

## Author

Stu Field

## Examples

``` r
# Compare outputs:

# Character
char <- head(letters, 10)
char
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"

as.data.frame(char)
#>    char
#> 1     a
#> 2     b
#> 3     c
#> 4     d
#> 5     e
#> 6     f
#> 7     g
#> 8     h
#> 9     i
#> 10    j
convert2df(char)
#>   v1 v2 v3 v4 v5 v6 v7 v8 v9 v10
#> 1  a  b  c  d  e  f  g  h  i   j

# table
tab <- table(sample(c("A", "B"), 30, replace = TRUE))
tab
#> 
#>  A  B 
#> 15 15 

as.data.frame(tab)
#>   Var1 Freq
#> 1    A   15
#> 2    B   15
convert2df(tab)
#>    A  B
#> 1 15 15

# matrix
mat <- matrix(1:9, ncol = 3L)
mat
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]    2    5    8
#> [3,]    3    6    9

as.data.frame(mat)
#>   V1 V2 V3
#> 1  1  4  7
#> 2  2  5  8
#> 3  3  6  9
convert2df(mat)
#>        
#> 1 1 4 7
#> 2 2 5 8
#> 3 3 6 9
```
