# Test for Enrichment

Calculated whether `2x2` table is enriched for a particular group using
Hypergeometric Distribution and the Fisher's Exact test for count data.

## Usage

``` r
enrich_test(x, ...)

# S3 method for class 'list'
enrich_test(x, ...)

# S3 method for class 'data.frame'
enrich_test(x, ...)

# S3 method for class 'matrix'
enrich_test(x, ...)
```

## Arguments

- x:

  A `2x2` confusion matrix (aka contingency table) containing the binary
  decisions for each contingency (or a similarly structured data frame).
  Can also be a (named) list containing each of the 4 contingencies. See
  examples.

- ...:

  Arguments passed to
  [`stats::fisher.test()`](https://rdrr.io/r/stats/fisher.test.html). In
  particular, `alternative` which determines whether to check for both
  enrichment and depletion ("two.sided") or specifically one *or* the
  other: enrichment = "greater"; depletion = "less".

## Value

An "enrichment" class object, a list of the significance tests
calculated from a Hypergeometric Distribution
[`stats::dhyper()`](https://rdrr.io/r/stats/Hypergeometric.html) as well
as those calculated via Fisher's Exact
[`stats::fisher.test()`](https://rdrr.io/r/stats/fisher.test.html) test
for count data testing the H_o that the odds ratio is equal to 1. The
p-values for various flavors of Hypergeometric test are:

- 1-sided:

  add here.

- 2-sided:

  double of `1-sided`.

- 1-sided mid:

  add description

- 2-sided mid:

  double of `1-sided mid`.

- 2-sided min lik:

  this differs previous, but is most similar to Fisher's Exact

- 2-sided min lik mid:

  this is typically preferred

## Details

Can also pass a *named* list containing:

|       |     |                                                         |
|-------|-----|---------------------------------------------------------|
| `n11` | :   | The corresponding `[1,1]` position of the `2x2` matrix. |
| `n1_` | :   | The sum of the top row of the table.                    |
| `n_1` | :   | The sum of the first column of the table.               |
| `n`   | :   | The sum of the table.                                   |

## See also

[`stats::dhyper()`](https://rdrr.io/r/stats/Hypergeometric.html),
[`stats::fisher.test()`](https://rdrr.io/r/stats/fisher.test.html)

## Author

Stu Field

## Examples

``` r
c_mat <- matrix(c(4, 2, 3, 11), ncol = 2L)
enrich_test(c_mat)
#> ══ Enrichment Tests ═══════════════════════════════════════════════════
#> ── Counts Table ───────────────────────────────────────────────────────
#>      v2
#> v1    no yes
#>   no   4   3
#>   yes  2  11
#> 
#> ── Hypergeometric ─────────────────────────────────────────────────────
#> ℹ Test-type            p-value
#> 
#> • 1-sided              0.07765738
#> • 2-sided              0.15531476
#> • 1-sided mid          0.04244066
#> • 2-sided mid          0.08488132
#> • 2-sided min lik      0.12192982
#> • 2-sided min lik mid★ 0.08671311
#> 
#> ── Fisher's Exact ─────────────────────────────────────────────────────
#> ℹ Alternative          two.sided
#> 
#> • Odds Ratio           6.48649744
#> • Odds Ratio p-value   0.12192982
#> • OR CI95              [0.601, 107.532]
#> ═══════════════════════════════════════════════════════════════════════

# or pass a named list
en_list <- list(n11 = 4, n1_ = 7, n_1 = 6, n = 20)
enrich_test(en_list)
#> ══ Enrichment Tests ═══════════════════════════════════════════════════
#> ── Counts Table ───────────────────────────────────────────────────────
#>      v2
#> v1    no yes
#>   no   4   3
#>   yes  2  11
#> 
#> ── Hypergeometric ─────────────────────────────────────────────────────
#> ℹ Test-type            p-value
#> 
#> • 1-sided              0.07765738
#> • 2-sided              0.15531476
#> • 1-sided mid          0.04244066
#> • 2-sided mid          0.08488132
#> • 2-sided min lik      0.12192982
#> • 2-sided min lik mid★ 0.08671311
#> 
#> ── Fisher's Exact ─────────────────────────────────────────────────────
#> ℹ Alternative          two.sided
#> 
#> • Odds Ratio           6.48649744
#> • Odds Ratio p-value   0.12192982
#> • OR CI95              [0.601, 107.532]
#> ═══════════════════════════════════════════════════════════════════════
```
