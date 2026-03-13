# Calculate q-values

Calculates a vector of q-values corresponding to a vector of p-values.

## Usage

``` r
calc_qvalue(
  p,
  lambda = seq(0, 0.95, 0.01),
  lambda_eval = NULL,
  match_storey = FALSE
)

# S3 method for class 'q_value'
plot(x, ..., rng = c(0, 0.25))
```

## Arguments

- p:

  A vector of p-values.

- lambda:

  A sequence of lambdas to evaluate.

- lambda_eval:

  A value of lambda to evaluate at, defaults to the maximum value of the
  `lambda` sequence.

- match_storey:

  `logical(1)`. Should the output match the `qvalue()` function exactly?

- x:

  A `q_value` class object.

- ...:

  Additional arguments passed to the S3 plot generic.

- rng:

  `numeric(2)`. Range of values.

## Value

A list of class `q_value` containing:

- call:

  The original call to `calc_qvalue()`.

- p_value:

  The original vector of p-values.

- m:

  ?

- lambda:

  ?

- lambda_eval:

  ?

- pi_lambda:

  ?

- spline_fit:

  ?

- pi0:

  ?

- q_value:

  A a vector of q-values.

A cool plot.

## References

John Storey. PNAS. 2003.

## See also

[`smooth.spline()`](https://rdrr.io/r/stats/smooth.spline.html)

## Author

Stu Field

## Examples

``` r
x <- withr::with_seed(101, c(seq(0.0001, 0.05, length = 50), runif(950)))
q <- calc_qvalue(x)

# S3 plot method
plot(q)
```
