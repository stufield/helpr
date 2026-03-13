# Open File Interactively

Opens a text file in an `RStudio` interactive session. Must be using
`RStudio` interactively. Similar to `rstudioapi::navigateToFile()` but
without the added rstudioapi dependency.

## Usage

``` r
openR(file)
```

## Arguments

- file:

  A path to a file.

## Value

The file path, invisibly.
