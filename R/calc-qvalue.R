#' Calculate q-values
#'
#' Calculates a vector of q-values corresponding
#'   to a vector of p-values.
#'
#' @param p A vector of p-values.
#' @param lambda A sequence of lambdas to evaluate.
#' @param lambda_eval A value of lambda to evaluate at,
#'   defaults to the maximum value of the `lambda` sequence.
#' @param match_storey `logical(1)`. Should the output match
#'   the `qvalue()` function exactly?
#'
#' @return A list of class `q_value` containing:
#'   \item{call}{The original call to `calc_qvalue()`.}
#'   \item{p_value}{The original vector of p-values.}
#'   \item{m}{?}
#'   \item{lambda}{?}
#'   \item{lambda_eval}{?}
#'   \item{pi_lambda}{?}
#'   \item{spline_fit}{?}
#'   \item{pi0}{?}
#'   \item{q_value}{A a vector of q-values.}
#'
#' @author Stu Field
#' @seealso [smooth.spline()]
#'
#' @references John Storey. PNAS. 2003.
#'
#' @examples
#' x <- withr::with_seed(101, c(seq(0.0001, 0.05, length = 50), runif(950)))
#' q <- calc_qvalue(x)
#'
#' @importFrom stats smooth.spline predict
#' @export
calc_qvalue <- function(p, lambda = seq(0, 0.95, 0.01),
                        lambda_eval = NULL, match_storey = FALSE) {

  if ( match_storey ) {
    lambda <- seq(0, 0.9, 0.05)
  }

  ret         <- list()               # set up empty return list
  ret$call    <- match.call()         # just to return the args from the orig call
  m           <- length(p)            # number of tests
  ret$p_value <- p
  ret$m       <- m
  lambda      <- lambda[lambda != 1]  # rm lambda=1 to not divide by 0 below
  ret$lambda  <- lambda

  if ( is.null(lambda_eval) ) {
    ret$lambda_eval <- max(lambda)
  } else {
    ret$lambda_eval <- lambda_eval
  }

  p2        <- p
  names(p2) <- seq_len(m) # name entries by original order for ordering later
  p2        <- sort(p2)

  if ( length(lambda) > 1L ) {
    ret$pi_lambda  <- vapply(lambda, function(.x) sum(p2 > .x) / (m * (1 - .x)), 0.1)
    ret$spline_fit <- smooth.spline(lambda, ret$pi_lambda, df = 3)
    # pi0 = prop true null hypotheses
    ret$pi0 <- predict(ret$spline_fit, ret$lambda_eval)$y   # eval at f.hat(lambda.eval)
  } else if ( length(lambda) == 1L && lambda >= 0 && lambda < 1 ) {
    # if lambda = scalar
    ret$pi0 <- sum(p2 > lambda) / (m * (1 - lambda))
  } else {
    stop(
      paste0("Invalid choice of `lambda = ", value(lambda),
      "`. Can be a vector [0,1) or a scalar [0,1)"), call. = FALSE
    )
  }

  # threshold pi0
  ret$pi0 <- min(ret$pi0, 1)
  q       <- setNames(numeric(m), names(p2))
  q[m]    <- ret$pi0 * p2[m]

  for ( i in seq(m - 1, 1) ) {
    q[i] <- min((ret$pi0 * m * p2[i]) / i, q[i + 1])
  }

  q <- q[order(as.numeric(names(q)))]   # return to original p-value order
  ret$q_value <- unname(q)              # remove ordering names from vector
  structure(ret, class = c("q_value", "list")) # set class for plotting method
}


#' Plot q_value Object
#'
#' @rdname calc_qvalue
#'
#' @param x A `q_value` class object.
#' @param rng `numeric(2)`. Range of values.
#' @param ... Additional arguments passed to the S3 plot generic.
#'
#' @return A cool plot.
#' @author Stu Field
#'
#' @examples
#' # S3 plot method
#' plot(q)
#' @importFrom stats smooth.spline quantile
#' @importFrom graphics par abline grid hist lines plot text
#' @export
plot.q_value <- function(x, ..., rng = c(0, 0.25)) {
  withr::local_par(list(mfrow = c(1, 5),
                        mgp   = c(2, 0.75, 0),
                        mar   = c(3, 4, 3, 1)))
  p   <- x$p_value
  ord <- order(p)

  if ( !"spline_fit" %in% names(x) ) {
    # if lambda = scalar
    lambda_vec  <- seq(0, 0.99, 0.01)
    pi_lambda   <- vapply(lambda_vec, function(i) sum(p > i) / (x$m * (1 - i)), 0.1)
    fit         <- stats::smooth.spline(lambda_vec, pi_lambda, df = 3)
    lambda_eval <- x$lambda
  } else {
    fit <- x$spline_fit
    pi_lambda   <- x$pi_lambda
    lambda_vec  <- x$lambda
    lambda_eval <- x$lambda_eval
  }

  # plot 1
  par_usr <- par("usr")   # nolint: undesirable_linter.
  hist(p, prob = TRUE, col = 8, main = "Density Histogram of p-values",
       xlab = "p-values", breaks = 20)
  abline(h = x$pi0, col = 2, lty = 2)
  t_lambda <- bquote(~lambda == .(round(x$lambda_eval, 2L)))
  t_pi  <- bquote(~hat(pi)[0] == .(round(x$pi0, 3L)))
  txt_x <- 0.2 * par_usr[2L]
  txt_y <- c(0.9, 0.85) * par_usr[4L]
  text(txt_x, txt_y[1L], labels = t_lambda, pos = 4, cex = 1.2)
  text(txt_x, txt_y[2L], labels = t_pi, pos = 4, cex = 1.2)

  # plot 2
  plot(lambda_vec, pi_lambda, main = t_pi,
       xlab = bquote(~lambda),
       ylab = bquote(~hat(pi)[0] ~ (lambda)),
       cex.main = 2, cex.lab = 1.5, pch = 19)
  lines(fit, col = 1, lwd = 3)
  lines(fit, col = 4, lwd = 1.5)
  lines(c(par_usr[1L], lambda_eval), rep(x$pi0, 2), col = 2, lty = 2)
  lines(rep(lambda_eval, 2), c(par_usr[3L], x$pi0), col = 3, lty = 2)

  # plot 3
  plot(p[ord], x$q_value[ord], type = "l", lwd = 3, ylab = "q-value",
       main = "q-value Trajectory", xlab = "p-value", ylim = c(0, 1), xlim = c(0, 1))
  grid(col = "gray80")
  lines(p[ord], x$q_value[ord], type = "l", lwd = 1.5, col = 4)
  abline(0, 1, col = 2, lty = 2, lwd = 1.5)

  q2 <- x$q_value[ord]

  if ( min(q2) > rng[2L] ) {
    rng <- c(min(q2), stats::quantile(q2, 0.1))
  }

  q_cutoff     <- q2[ q2 >= rng[1L] & q2 <= rng[2L] ]
  sig_feats    <- (1 + sum(q2 < rng[1L])):sum(q2 <= rng[2L])
  expected_fdr <- q_cutoff * sig_feats
  lims         <- c(min(c(sig_feats, expected_fdr)),
                    max(c(sig_feats, expected_fdr)))

  # plot 4
  plot(q_cutoff, sig_feats, type = "l", lwd = 3,
       xlab = "q-value cutoff", ylab = "Number of Significant Tests")
  grid(col = "gray80")
  lines(q_cutoff, sig_feats, type = "l", col = 4, lwd = 1.5)

  # plot 5
  plot(sig_feats, expected_fdr, type = "l", lwd = 3, xlim = lims, ylim = lims,
       ylab = "Expected False Positives", xlab = "Number of Significant Tests")
  grid(col = "gray80")
  lines(sig_feats, expected_fdr, type = "l", col = 4, lwd = 1.5)
  abline(0, 1, col = 2, lty = 2, lwd = 1.5)
}
