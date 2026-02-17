# Activate and Deactivate Lib Mode

When activated, `lib_mode()` adds a new library location (aka `lib.loc`)
to the top of the library tree. This allows you to run code in an
"sandbox", without interfering with the other packages you have
installed previously. See
[`vignette("lib-mode")`](https://stufield.github.io/helpr/articles/lib-mode.md)
for more details with examples.

## Usage

``` r
lib_mode(path = getOption("helpr_path"))

lib_tree()

is_lib_mode()
```

## Arguments

- path:

  A directory location of an R library.

## Functions

- `lib_tree()`: A thin wrapper around
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html) to quickly and
  easily view the *current* library tree of directories the session
  knows about.

- `is_lib_mode()`: Determines whether a session is *currently* in "lib
  mode".

## See also

[`.libPaths()`](https://rdrr.io/r/base/libPaths.html)

## Examples

``` r
if (FALSE) { # \dontrun{
  dir.create("new-lib")
  lib_mode("new-lib")  # ON; activate
  lib_mode("new-lib")  # OFF; deactivate
  lib_mode("new-lib")  # ON; re-activate
} # }
```
