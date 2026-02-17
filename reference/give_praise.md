# Praise User

Part of collaboration is being friendly to your users. Praise your
colleagues with encouragement when they use your code appropriately and
when it runs error free! This is an dependency-free version of the
praise package the takes no arguments. Output can be suppressed by
setting the `"signal.quiet"` option (see example).

## Usage

``` r
give_praise()
```

## Examples

``` r
# random praise 1
give_praise()
#> Heh! You are Exquisite!

# random praise 2
give_praise()
#> Awww! You are Doozie!

# suppress praise
withr::with_options(list(signal.quiet = TRUE), give_praise())
```
