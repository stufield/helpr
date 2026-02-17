# Handle and Capture Side Effects

Wrappers to capture side effects and silence function output. This can
be particularly useful for instances where you know a function may
generate a warning/error, but do not want to terminate any higher-level
processes. Downstream code can then trap the returned object accordingly
because the output is in an expected structure. Note that `be_hard()` is
not a simple drop-in replacement for
[`purrr::partial()`](https://purrr.tidyverse.org/reference/partial.html)
as it does *not* support quasi-quotation, but should be a sufficient
replacement in most cases.

## Usage

``` r
be_safe(.f, otherwise = NULL)

be_quiet(.f)

be_hard(.f, ...)
```

## Arguments

- .f:

  A function to capture and handle in a user controlled manner.

- otherwise:

  The value of `result` in the event of an error.

- ...:

  Named arguments to be hard-coded as key-value pairs.

## Value

`be_safe()`: a list containing:

- result: if `NULL` there was an error, see `error`.

- error: if `NULL` no errors were encountered, see `result`.

`be_quiet()`: a list containing:

- result: the result of the evaluated expression.

- output: any output that was captured during evaluation.

- warnings: any warnings that were encountered during evaluation.

- messages: any messages that were triggered during evaluation.

`be_hard()`: a function with new hard-coded arguments.

## Functions

- `be_safe()`: Roll through [`stop()`](https://rdrr.io/r/base/stop.html)
  or `usethis::ui_stop()` conditions.

- `be_quiet()`: Be quiet! ... always contains a `result`.

- `be_hard()`: Be hard! ... coded for specified arguments.

## purrr analogues

|              |                                                                          |
|--------------|--------------------------------------------------------------------------|
| helpr        | purrr                                                                    |
| `be_safe()`  | [`purrr::safely()`](https://purrr.tidyverse.org/reference/safely.html)   |
| `be_quiet()` | [`purrr::quietly()`](https://purrr.tidyverse.org/reference/quietly.html) |
| `be_hard()`  | [`purrr::partial()`](https://purrr.tidyverse.org/reference/partial.html) |

## Examples

``` r
# be safe
safelog <- be_safe(log2)
safelog("a")
#> $result
#> NULL
#> 
#> $error
#> [1] "non-numeric argument to mathematical function"
#> 
safelog("foo" + 10)
#> $result
#> NULL
#> 
#> $error
#> [1] "non-numeric argument to binary operator"
#> 
safelog(32)
#> $result
#> [1] 5
#> 
#> $error
#> NULL
#> 

# be quiet
# create a chatty function:
f <- function(x) {
  message("This is a message.")
  message("This is a second message.")
  warning("This is a warning!")
  warning("This is a second warning!")
  cat("Multiplying pi * x^2:\n")
  pi * x^2
}
f2 <- be_quiet(f)
f2(5)
#> $result
#> [1] 78.53982
#> 
#> $output
#> [1] "Multiplying pi * x^2:"
#> 
#> $warnings
#> [1] "This is a warning!"        "This is a second warning!"
#> 
#> $messages
#> [1] "This is a message.\n"        "This is a second message.\n"
#> 

# be hard-coded
vec <- rnorm(50)
navec <- c(NA_real_, vec)
q2 <- be_hard(quantile, probs = c(0.025, 0.975), na.rm = TRUE)

# `be_hard` has a special S3 print method
q2
#> Hard-coded function: quantile()
#>  arg   value       
#>  probs 0.025, 0.975
#>  na.rm TRUE        

quantile(vec, probs = c(0.025, 0.975))
#>      2.5%     97.5% 
#> -1.922519  1.652401 

q2(vec)
#>      2.5%     97.5% 
#> -1.922519  1.652401 

quantile(navec, probs = c(0.025, 0.975), na.rm = TRUE)
#>      2.5%     97.5% 
#> -1.922519  1.652401 

q2(navec)
#>      2.5%     97.5% 
#> -1.922519  1.652401 
```
