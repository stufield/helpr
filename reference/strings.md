# Working with Strings

Tools for working with character/text strings without importing the
stringr package.

## Usage

``` r
pad(x, width, side = c("right", "left", "both"))

squish(x)

trim(x, side = c("both", "left", "right"), whitespace = "[ \t\r\n]")

capture(text, pattern)
```

## Arguments

- x:

  A character vector.

- width:

  `integer(1)`. The minimum width of padding for each element.

- side:

  `character(1)`. Pad to the left or right.

- whitespace:

  A string specifying a regular expression to match (one character of)
  "white space".

- text:

  A character vector where matches are sought.

- pattern:

  `character(1)`. A string *containing a group capture* regex.

## Functions

- `pad()`: Similar to `stringr::str_pad()` but does uses *only* a blank
  space as the padding character.

- `squish()`: The inverse of `pad()`, removes whitespace on both sides
  *and* replicated internal whitespace. Similar to
  `stringr::str_squish()`.

- `trim()`: A wrapper around
  [`trimws()`](https://rdrr.io/r/base/trimws.html) but with unified
  argument names.

- `capture()`: Uses "group capture" regular expression from the
  `pattern` argument to extract matches from character string(s).
  Analogous to `stringr::str_extract()`.

## base vs stringr

Below is a convenient table of the stringr to base R equivalents:

|                              |                                                                                                                                                           |
|------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| stringr                      | base R                                                                                                                                                    |
| `stringr::str_c()`           | [`paste()`](https://rdrr.io/r/base/paste.html)                                                                                                            |
| `stringr::str_count()`       | [`gregexpr()`](https://rdrr.io/r/base/grep.html) + `attr(x, "match.length")`\]                                                                            |
| `stringr::str_dup()`         | [`strrep()`](https://rdrr.io/r/base/strrep.html)                                                                                                          |
| `stringr::str_detect()`      | [`grepl()`](https://rdrr.io/r/base/grep.html)                                                                                                             |
| `stringr::str_flatten()`     | `paste(..., collapse = "")`                                                                                                                               |
| `stringr::str_glue()`        | [`sprintf()`](https://rdrr.io/r/base/sprintf.html)                                                                                                        |
| `stringr::str_length()`      | [`nchar()`](https://rdrr.io/r/base/nchar.html)                                                                                                            |
| `stringr::str_locate_all()`  | [`regexpr()`](https://rdrr.io/r/base/grep.html)                                                                                                           |
| `stringr::str_match()`       | [`match()`](https://rdrr.io/r/base/match.html)                                                                                                            |
| `stringr::str_order()`       | [`order()`](https://rdrr.io/r/base/order.html)                                                                                                            |
| `stringr::str_remove()`      | `sub(..., replacement = "")`                                                                                                                              |
| `stringr::str_remove_all()`  | `gsub(..., replacement = "")`                                                                                                                             |
| `stringr::str_replace()`     | [`sub()`](https://rdrr.io/r/base/grep.html)                                                                                                               |
| `stringr::str_replace_all()` | [`gsub()`](https://rdrr.io/r/base/grep.html)                                                                                                              |
| `stringr::str_sort()`        | [`sort()`](https://rdrr.io/r/base/sort.html)                                                                                                              |
| `stringr::str_split()`       | [`strsplit()`](https://rdrr.io/r/base/strsplit.html)                                                                                                      |
| `stringr::str_sub()`         | [`substr()`](https://rdrr.io/r/base/substr.html), [`substring()`](https://rdrr.io/r/base/substr.html), [`strtrim()`](https://rdrr.io/r/base/strtrim.html) |
| `stringr::str_subset()`      | `grep(..., value = TRUE)`                                                                                                                                 |
| `stringr::str_to_lower()`    | [`tolower()`](https://rdrr.io/r/base/chartr.html)                                                                                                         |
| `stringr::str_to_upper()`    | [`toupper()`](https://rdrr.io/r/base/chartr.html)                                                                                                         |
| `stringr::str_trim()`        | [`trimws()`](https://rdrr.io/r/base/trimws.html)                                                                                                          |
| `stringr::str_which()`       | [`grep()`](https://rdrr.io/r/base/grep.html)                                                                                                              |
| `stringr::str_wrap()`        | [`strwrap()`](https://rdrr.io/r/base/strwrap.html)                                                                                                        |

And those found only in helpr:

|                          |                                                               |
|--------------------------|---------------------------------------------------------------|
| stringr                  | helpr                                                         |
| `stringr::str_extract()` | `capture()`, `gsub(..., replacement = "\\1")`                 |
| `stringr::str_squish()`  | `squish()`                                                    |
| `stringr::str_pad()`     | `pad()` or [`sprintf()`](https://rdrr.io/r/base/sprintf.html) |
| `stringr::str_trim()`    | `trim()`                                                      |

## See also

[`encodeString()`](https://rdrr.io/r/base/encodeString.html),
[`trimws()`](https://rdrr.io/r/base/trimws.html),
[`regexpr()`](https://rdrr.io/r/base/grep.html),
[`substring()`](https://rdrr.io/r/base/substr.html)

## Examples

``` r
pad("tidyverse", 20)
#> [1] "tidyverse           "
pad("tidyverse", 20, "left")
#> [1] "           tidyverse"
pad("tidyverse", 20, "both")
#> [1] "     tidyverse      "

squish("  abcd   efgh   ")
#> [1] "abcd efgh"
squish("  abcd   efgh   .")
#> [1] "abcd efgh ."

trim("  abcd   efgh   ")
#> [1] "abcd   efgh"
trim("  abcd   efgh   .")
#> [1] "abcd   efgh   ."

# extract the group 'oo'
capture(c("foo", "bar", "boo", "oops"), "(oo)")
#>      1
#> 1   oo
#> 2 <NA>
#> 3   oo
#> 4   oo

# capture multiple groups
capture(c("foo", "bar", "boo", "oops-e-doo"), "(.*)(oo)")
#>          1    2
#> 1        f   oo
#> 2     <NA> <NA>
#> 3        b   oo
#> 4 oops-e-d   oo
```
