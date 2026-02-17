# Library Mode

## Introduction

- Lack of reproducibility is a major obstacle for any large (or small)
  organization, especially those that deliver products that need an
  audit trail. Installing 3rd party packages from external repositories,
  or internal “between-release” development versions of packages,
  without version or commit tagging makes this near to impossible at
  scale.

- Furthermore, installing a specific package version into a top-level
  environment can make that version the default for all other analyses
  performed in that environment.

- [`lib_mode()`](https://stufield.github.io/helpr/reference/lib_mode.md)
  attempts to solve these issues by creating an *specific* library
  location (i.e. `lib.loc`) into a specified directory at the top of the
  R library tree.

- Defaults can be easily set via `getOption("helpr_path")`.

- Versions of packages can be installed to this location in a
  reproducible way (e.g. via the `remotes` package or via
  [`remotes::install_github()`](https://remotes.r-lib.org/reference/install_github.html)
  or
  [`remotes::install_version()`](https://remotes.r-lib.org/reference/install_version.html)),
  which can be scripted and reproduced accurately by subsequent
  analysts.

- The examples below show:

  - how to use
    [`lib_mode()`](https://stufield.github.io/helpr/reference/lib_mode.md)
  - how to toggle back-and-forth between modes
  - how to install to the default library mode location

------------------------------------------------------------------------

### Useful Functions

- [`lib_mode()`](https://stufield.github.io/helpr/reference/lib_mode.md)
- [`lib_tree()`](https://stufield.github.io/helpr/reference/lib_mode.md)
- [`is_lib_mode()`](https://stufield.github.io/helpr/reference/lib_mode.md)

------------------------------------------------------------------------

### Usage

#### Toggle `lib_mode()` ON/OFF

Library Mode usage requires a path specification of the desired library
location via its `path =` argument. This can be *anywhere* on the file
system that the user has privileges.

``` r
mylib <- "~/tmp-lib"
dir.create(mylib)     # must create a valid directory

lib_tree()
#> [1] "/Users/runner/work/_temp/Library"                                         
#> [2] "/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/site-library"
#> [3] "/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library"

lib_mode(mylib)  # activate; creates lib.loc location
#> ✓ Analysis mode: ON
#> ✓ Using: /Users/runner/tmp-lib/

lib_tree()
#> [1] "/Users/runner/tmp-lib"                                                    
#> [2] "/Users/runner/work/_temp/Library"                                         
#> [3] "/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/site-library"
#> [4] "/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library"

lib_mode(mylib)  # deactivate
#> ✓ Analysis mode: OFF

lib_tree()
#> [1] "/Users/runner/work/_temp/Library"                                         
#> [2] "/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/site-library"
#> [3] "/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library"
```

#### Install 3rd party packages in `lib_mode()`

For reproducibility, it is critical to install to a `path` using a
specific package version, this can be accomplished via
[`remotes::install_version()`](https://remotes.r-lib.org/reference/install_version.html)
if installing a third-party package:

``` r
packageVersion("spelling")
#> [1] '2.3.2'

lib_mode(mylib)
#> ✓ Analysis mode: ON
#> ✓ Using: /Users/runner/tmp-lib/

# install old `here` and `spelling` versions
# by default installs to .libPaths()[1L]
install_version("here", version = "0.1", dependencies = FALSE,
                upgrade = FALSE, quiet = TRUE)
install_version("spelling", version = "1.1", dependencies = FALSE,
                upgrade = FALSE, quiet = TRUE)

packageVersion("spelling")
#> [1] '1.1'

lib_mode(mylib)
#> ✓ Analysis mode: OFF
```

#### Re-activating `lib_mode()`

The next time you activate “lib mode”, you will be notified that you are
using a set of installed libraries (`here` and `spelling`):

``` r
lib_mode(mylib)
#> ✓ Analysis mode: ON
#> ✓ Using: /Users/runner/tmp-lib/
#> • here     '0.1'
#> • spelling '1.1'
```

------------------------------------------------------------------------

### Using `getOption("helpr_path")`

Another option to use
[`lib_mode()`](https://stufield.github.io/helpr/reference/lib_mode.md)
without arguments is to set the `helpr_path` option via
`options(helpr_path = "path/to/lib")`. This can be set early in a script
or in a setup chunk of an `Rmarkdown`. It is discouraged to set this
option in an `.Rprofile` because it would not be portable across users
and/or machines.

``` r
# uses the 'helpr_path' option set
options(helpr_path = mylib)
lib_mode()
#> ✓ Analysis mode: ON
#> ✓ Using: /Users/runner/tmp-lib/
#> • here     '0.1'
#> • spelling '1.1'
```
