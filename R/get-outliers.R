#' Get Indices of Statistical Outliers
#'
#' Calculates the indices of a vector of values that exceed a specified
#'   statistical outlier criterion. This criterion is defined by differently
#'   depending on the type of outlier detection implemented (see Details).
#'
#' @section outlier detection:
#'   There are 2 possible methods used to define an outlier measurement
#'   and the return value depends on which method is implemented:
#'   \enumerate{
#'     \item The non-parametric case (default): agnostic to the distribution.
#'       Outlier measurements are defined as falling outside `mad.crit * mad`
#'       from the median _and_ a specified number of fold-changes from
#'       the median (i.e. `fold.crit`; e.g. 5x).\cr
#'       **Note:** `n.sigma` is ignored.
#'     \item The parametric case: the mean and standard deviation are
#'       calculated robustly via [fit_gauss()]. Outliers
#'       are defined as measurements falling _outside_ +/- `n.sigma`*\eqn{\sigma}
#'       from the the estimated \eqn{\mu}.\cr
#'       **Note:** `mad.crit` and `fold.crit` are ignored.
#'   }
#'
#' @param x `numeric(n). A vector of values to evaluate.
#' @param n_sigma `numeric(1)`. The the number of standard
#'   deviations from the mean a `n.sigma` threshold for outliers.
#'   Ignored if `type = "nonparametric"`.
#' @param mad_crit The median absolute deviation ("MAD")
#'   criterion to use. Ignored if `type = "parametric"`.
#'   Defaults to `(6 * mad)`.
#' @param fold_crit The fold-change criterion to evaluate.
#'   Ignored if `type = "parametric"`. Defaults to `5x`.
#' @param type `character(1)`. Matched. Either
#'   "parametric" or "nonparametric" to determine
#'   the type of outliers detection implementation.
#'
#' @return If "nonparametric": an integer vector of
#'   indices corresponding to detected outliers.
#'
#'   If "parametric": an integer vector of indices with these additional attributes:
#'     \item{mu}{the robustly fit mean (\eqn{\mu}).}
#'     \item{sigma}{the robustly fit standard deviation (\eqn{\sigma}).}
#'     \item{crit}{the 2 critical values beyond which a value is considered
#'       an outlier.}
#'
#' @author Stu Field
#' @seealso [fit_gauss()]
#'
#' @examples
#' withr::with_seed(101, {
#'   x <- rnorm(26, 15, 2)         # Gaussian
#'   x <- c(2, 2.5, x, 25, 25.9)   # add 4 outliers (2hi, 2lo)
#' })
#' get_outliers(x)                # non-parametric (default)
#' get_outliers(x, type = "para") # parametric
#' @importFrom stats median mad
#' @export
get_outliers <- function(x, n_sigma = 3, mad_crit = 6, fold_crit = 5,
                         type = c("nonparametric", "parametric")) {

  type <- match.arg(type)
  if ( type == "parametric" ) {
    # robust estimate of Gaussian pars
    est <- tryCatch(
      fit_gauss(x),  # if fails trip warning and retry with mad = TRUE
      error = function(e) {
        warning(
          "Robust Gaussian fit failed. Refitting with non-parametric `mad = TRUE`",
          call. = FALSE
        )
        fit_gauss(x, mad = TRUE)
      }
    )
    mu    <- est[["mu"]]
    sigma <- est[["sigma"]]
    crit  <- mu + n_sigma * sigma * c(-1, 1)       # mu +/- sigma
    idx   <- which(x <= crit[1L] | x >= crit[2L])  # index of outlier values
    structure(idx, mu = mu, sigma = sigma, crit = crit) # add pars as attr
  } else {
    med       <- median(x, na.rm = TRUE)
    stat_bool <- abs(x - med) > mad_crit * mad(x, constant = 1)  # stat criterion
    fold_bool <- (x / med > fold_crit) | (med / x > fold_crit)   # FC criterion
    #print(stat_bool); print(fold_bool); print(stat_bool & fold_bool) # nolint
    which(stat_bool & fold_bool)
  }
}
