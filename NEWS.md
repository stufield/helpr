# helpr 0.0.2 :rocket:

### Fixes
* Fixed clobbering pkg functions with indexing objects
  - doubled up on things like `is_dbl` which is bad form
  - just renamed the indexing vectors not to
    double use the functions with the same name
  - not necessary, R is smart, but was ugly

### Maintenance
* Added a namespace test in 'inst'
  - simple script to ensure that namespaces
    are kept low (or to a minimum)
  - usage: `Rscript --vanilla inst/test-ns.R`

* Improvements to `enrich_test()`
  - general simplifications
  - separate out into S3 methods: `matrix`, `list`, and `data.frame`
  - gets a new print method and new unit tests
  - the alternative param is now simply
    passed direction to `fisher.test()`
    via the new `...` which allows further extensibility
  - simplifies internal logic and params
  - user is asked to consult `fisher.test()`
    for further information

### Added
* New unit testing helpers

* New `jagged_tbl()` function
  - new function from old code base which is useful here
  - adds tibble package so not sure if I
    want to keep the dependency

* New `file_find()` wrapper
  - documented in filesystem docs
  - thin wrapper around `ls_dir()`

* New function `write_latex_tbl()`
  - from old code but good one to have in the back pocket

* New `piter()` function
  - analogue for `purrr::pmap()` allowing
    for extensible list iteration
  - allows for `~formula` syntax
  - also added `~formula` syntax for `liter()` also

### Removed

* Removed `calc_brier()` from package
  - now lives in `libml` package
* Removed `skip_on_jenkins()`

### Documentation 
* cleaned up and improvement
  - minor param changes to `snake_case`,
    so downstream effects are possible

* Fixed broken http-links in p-value FDR
  - multi-line `\url` does not work
    with `pkgdown` parser


# helpr 0.0.1 :tada:

* Initial release! :partying_face:
