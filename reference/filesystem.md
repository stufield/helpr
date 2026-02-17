# Determine Path to File

Determine the path of a defined file via brute force search of
(optionally) the root directory.

Generalized file system utilities and operations customized for data
structures. It was heavily influenced by the fs package:
<https://github.com/r-lib/fs>.

## Usage

``` r
file_find(pattern, root = Sys.getenv("HOME"))

helpr_path(..., ext = "")

as_helpr_path(x)

is.dir(x)

ls_dir(dir = ".", regexp = NULL, all = FALSE, ...)

info_dir(dir = ".", ...)

file_ext(file)

file_ext(file) <- value

rm_file_ext(file)

set_file_ext(file, ext)

as_helpr_bytes(x)
```

## Arguments

- pattern:

  `character(1)`. The pattern as a regex.

- root:

  The path of the root directory to start the highest level search.

- ...:

  Character vectors to construct paths, `length == 1` values are
  recycled as appropriate too complete pasting. Alternatively, arguments
  passed to [`dir()`](https://rdrr.io/r/base/list.files.html) (for
  `ls_dir()`).

- ext, value:

  An optional extension to append to the generated path.

- regexp:

  A regular expression, e.g. "`[.]csv$`", see the `pattern` argument to
  [`dir()`](https://rdrr.io/r/base/list.files.html). Files are collated
  according to `"C"` locale rules, so that they are ordered consistently
  with [`fs::dir_ls()`](https://fs.r-lib.org/reference/dir_ls.html).

- all:

  If `TRUE` hidden files are also returned.

- file, x, dir:

  A file-system location, directory, or path. Vectorized paths are
  allowed where possible.

## Value

The path(s) containing the regular expression specified in `pattern`.

## Functions

- `helpr_path()`: Construct a path to a file.

- `as_helpr_path()`: Coerce to a `helpr_path` object.

- `is.dir()`: Test if location is a directory.

- `ls_dir()`: List the directory contents.

- `info_dir()`: Lists the directory contents similar to `ls -l`.

- `file_ext()`: Extracts the file extension from a file path.

- `file_ext(file) <- value`: Replaces an existing extension. See
  `set_file_ext()`.

- `rm_file_ext()`: Removes the file extension from a file path.

- `set_file_ext()`: Replaces the existing file extension with `ext`.
  Extensions of `length == 1` are recycled.

- `as_helpr_bytes()`: Coerce to a `helpr_bytes` object.

## Examples

``` r
# wrapper around `ls_dir()`
if (FALSE) { # \dontrun{
  file_find("Makefile", ".")
  file.create("myfile.txt")
  file_find("myfile.txt", "..")
  unlink("myfile.txt", force = TRUE)
} # }
# paths
helpr_path("foo", "bar", "baz")    # no ext
#> foo/bar/baz

helpr_path("foo", "bar", "baz", ext = "zip")  # ext
#> foo/bar/baz.zip

helpr_path("foo", letters[1:3], ext = "txt")  # recycled args
#> foo/a.txt foo/b.txt foo/c.txt 

# directories
ls_dir()
#> add_class.html    calc_ccc.html     calc_qvalue-1.png 
#> calc_qvalue.html  calc_ss.html      convert2df.html   
#> create_form.html  cross_tab.html    dater.html        
#> diff_vecs.html    dots_list2.html   elements.html     
#> enrich_test.html  figures           index.html        

is.dir(ls_dir())
#>    add_class.html     calc_ccc.html calc_qvalue-1.png 
#>             FALSE             FALSE             FALSE 
#>  calc_qvalue.html      calc_ss.html   convert2df.html 
#>             FALSE             FALSE             FALSE 
#>  create_form.html    cross_tab.html        dater.html 
#>             FALSE             FALSE             FALSE 
#>    diff_vecs.html   dots_list2.html     elements.html 
#>             FALSE             FALSE             FALSE 
#>  enrich_test.html           figures        index.html 
#>             FALSE              TRUE             FALSE 

info_dir()
#> # A tibble: 15 × 9
#>    path             type     size permissions modified            user 
#>    <hlpr_pth>       <chr> <hlpr_> <chr>       <dttm>              <chr>
#>  1 add_class.html   file    9.04K rw-r--r--   2026-02-17 23:30:06 runn…
#>  2 calc_ccc.html    file    9.43K rw-r--r--   2026-02-17 23:30:07 runn…
#>  3 calc_qvalue-1.p… file  190.95K rw-r--r--   2026-02-17 23:30:07 runn…
#>  4 calc_qvalue.html file    9.98K rw-r--r--   2026-02-17 23:30:07 runn…
#>  5 calc_ss.html     file    6.03K rw-r--r--   2026-02-17 23:30:07 runn…
#>  6 convert2df.html  file   11.96K rw-r--r--   2026-02-17 23:30:08 runn…
#>  7 create_form.html file    10.6K rw-r--r--   2026-02-17 23:30:08 runn…
#>  8 cross_tab.html   file   13.22K rw-r--r--   2026-02-17 23:30:08 runn…
#>  9 dater.html       file    6.49K rw-r--r--   2026-02-17 23:30:09 runn…
#> 10 diff_vecs.html   file    9.09K rw-r--r--   2026-02-17 23:30:09 runn…
#> 11 dots_list2.html  file   11.95K rw-r--r--   2026-02-17 23:30:09 runn…
#> 12 elements.html    file   17.23K rw-r--r--   2026-02-17 23:30:10 runn…
#> 13 enrich_test.html file   17.48K rw-r--r--   2026-02-17 23:30:10 runn…
#> 14 figures          dire…    224B rwxr-xr-x   2026-02-17 23:30:06 runn…
#> 15 index.html       file   18.25K rw-r--r--   2026-02-17 23:30:06 runn…
#> # ℹ 3 more variables: group <chr>, changed <dttm>, accessed <dttm>

# extensions
file_ext("foo.txt")
#> [1] "txt"

rm_file_ext("foo/bar.txt")
#> [1] "foo/bar"

set_file_ext("foo/bar.csv", "tsv")
#> foo/bar.tsv
set_file_ext(c("foo.txt", NA, "bar.csv"), "R")   # NAs unchanged & 'R' recycled
#> foo.R NA    bar.R 

x <- "foo.txt"
file_ext(x) <- "csv"
x
#> foo.csv
```
