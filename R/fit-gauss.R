#' Calculate Robust Gaussian Estimates
#'
#' Estimates parameters of the Gaussian distribution
#'   (\eqn{\mu}, \eqn{\sigma}) via non-linear least-squares,
#'   making Gaussian assumptions of the error function, see [pnorm()].
#'   Initial starting values are chosen via robust estimates,
#'   [median()] and [mad()]. If `mad = TRUE`, these starting
#'   values are returned.
#'
#' @param x `numeric(n)`. A vector of numeric values to
#'   fit to Gaussian assumptions.
#' @param mad `logical(1)`. Should [median()] and [mad()]
#'   `* 1.4826` be used as robust (i.e. distribution-free)
#'   estimates of population mean and standard deviation?
#'
#' @return A named vector consisting of non-linear
#'   least-squares estimates of `mu` and `sigma` for `x`.
#' @author Stu Field
#' @seealso [nls()], [pnorm()]
#'
#' @examples
#' x <- rnorm(100, 25, 3)
#' fit_gauss(x)
#' fit_gauss(x, mad = TRUE)
#' @importFrom stats nls pnorm nls.control mad median IQR coef
#' @export
fit_gauss <- function(x, mad = FALSE) {
  x  <- x[!is.na(x)]
  y  <- rank(x, ties.method = "max") / length(x)
  mu <- median(x, na.rm = TRUE)
  # adjust to asymptotic normality
  sigma <- mad(x, center = mu, constant = 1.4826, na.rm = TRUE)

  if ( sigma == 0 ) {
    sigma <- IQR(x, na.rm = TRUE) / 1.349
  }

  pars <- c(mu = mu, sigma = sigma)

  if ( mad ) {
    pars   # return non-parametric (distn-free) estimates
  } else {
    # robust fit
    fit <- nls(
      formula = y ~ pnorm(x, mean = mu, sd = sigma),
      data    = data.frame(x = x, y = y),
      start   = as.list(pars),
      control = nls.control(maxiter = 2000, minFactor = 1 / 1024, warnOnly = TRUE)
    )
    coef(fit)
  }
}
