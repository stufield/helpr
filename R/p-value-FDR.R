#' Calculate Benjamini-Hochberg FDR Corrected Values
#'
#' Calculation and diagnostic plots to explain how B-H FDR
#'   procedure works via Benjamini-Hochberg "step-up"
#'   correction. FDR corrected p-values are calculated
#'   from scratch and reported with other elements/steps
#'   of the procedure.
#'
#' @param p A numeric vector of p-values.
#' @param alpha `numeric(1)`. Significance level in \verb{[0, 1]}.
#'
#' @return A `fdr` object. A `tibble` for the step-up procedure.
#'   The `tibble` contains:
#'   \item{p.value}{A sorted vector of the original p-values.}
#'   \item{penalty (`k/m`)}{The threshold value, corresponding to `k / m` (slope).}
#'   \item{threshold}{The threshold value, corresponding to `alpha * k / m`.}
#'   \item{p_hat}{Term in the minimum function corresponding to `p * m / k`.}
#'   \item{fdr}{The FDR-adjusted p-values.}
#'   \item{idx}{The indices of the original p-values.}
#'   \item{fdr_p}{The FDR-adjusted p-values ordered by `idx`.}
#'   \item{alpha}{The chosen significance threshold.}
#'
#' @note You are basically solving for the slope (`k/m`)
#'   that makes the p-value (`alpha`) significant.
#'
#' @author Stu Field
#' @seealso [p.adjust()], [cummin()]
#'
#' @references
#' Benjamini, Y., and Hochberg, Y. (1995). Controlling the false
#'   discovery rate: a practical and powerful approach to multiple
#'   testing. *Journal of the Royal Statistical Society Series B*
#'   **57**, 289-300.
#'
#' \url{
#' http://www.unc.edu/courses/2007spring/biol/145/001/docs/lectures/Nov12.html
#' }
#'
#' \url{
#' http://en.wikipedia.org/wiki/False_discovery_rate#Benjamini.E2.80.93Hochberg_procedure
#' }
#'
#' @examples
#' p1  <- c(0.01, 0.013, 0.014, 0.19, 0.35, 0.5, 0.63, 0.67, 0.75, 0.81)
#' new <- p_value_FDR(p1)
#' new
#'
#' old <- p.adjust(p1, method = "fdr")
#' all.equal(new$fdr_p, old)
#'
#' plot(new)
#'
#' p2 <- withr::with_seed(1001, runif(10, 0.0005, 0.3))
#' p_value_FDR(p2)
#'
#' p3 <- withr::with_seed(669, c(runif(10), rep(0.5, 10)))
#' p_value_FDR(p3)
#'
#' p4 <- withr::with_seed(101, c(runif(200), runif(25, 0.01, 0.1)))
#' p_value_FDR(p4)
#' @importFrom graphics abline grid legend
#' @importFrom grDevices rainbow
#' @export
p_value_FDR <- function(p, alpha = 0.05) {

  if ( !is_dbl(alpha) ) {
    stop("The `alpha =` argument must be a scalar value in [0, 1].",
         call. = FALSE)
  }
  orig_idx <- order(p)
  m      <- length(p)
  p_sort <- sort(p)                    # sorted p-values
  k_m    <- seq(m) / m                 # calc k/m; the penalty
  thresh <- k_m * alpha                # slope x alpha level
  p_hat  <- pmin(1L, p_sort * k_m^-1)  # calc adjusted p-values; max = 1.0
  # reverse order |> calc cumulative min from hi -> lo |> undo reverse
  fdr    <- rev(p_hat) |> cummin() |> rev()

  tibble::tibble(
    p_value         = p_sort,
    `penalty (k/m)` = k_m,
    threshold       = thresh,
    p_hat           = p_hat,
    fdr             = fdr,
    idx             = orig_idx,
    fdr_p           = fdr[orig_idx], # orig order
    alpha = ifelse(rev(cummax(rev(p_sort <= thresh))), "sig.", "null")
  ) |> add_class("fdr") |> structure(alpha = alpha)
}


#' @rdname p_value_FDR
#'
#' @param x A `fdr` object.
#' @param ... Unused. For compliance with the [plot()] generic default params.
#'
#' @export
plot.fdr <- function(x, ...) {
  withr::local_par(list(mgp = c(1.5, 0.5, 0), mar = c(3, 3, 3, 1) + 0.1))
  k_m <- x[["penalty (k/m)"]]
  plot(k_m, x$p_value, ylim = 0:1, xlim = 0:1,
       main = "P-values by Significance Index",
       ylab = "Sorted p-values", xlab = "Index (k/m)")
  grid(col = "gray70")
  abline(0, 1, col = 1, lwd = 1.5, lty = 2)
  m <- nrow(x)
  slopes <- unique(x$fdr) |> sort()
  cols   <- length(slopes) |> rainbow()
  lapply(seq_along(slopes), function(.x) {
    abline(0, slopes[.x], col = cols[.x])
  })
  abline(h = attr(x, "alpha") / m, col = 4, lty = 2)  # add Bonferroni
  legend(
    "topleft",
    legend = c("Bonferroni", sprintf("FDR %0.2f%%", slopes * 100)),
    col = c(4, cols),
    cex = 0.8,
    lty = c(2, rep_len(1, length(slopes))),
    bg = NA, ncol = 2
  )
  invisible()
}
