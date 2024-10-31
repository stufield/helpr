#' 1 Step of E-M
#'
#' A single step of the EM algorithm.
#'
#' @param y value
#' @param mu1 value
#' @param mu2 value
#' @param sd1 value
#' @param sd2 value
#' @param pi.hat value
#' @importFrom stats dnorm
#' @noRd
em_1_step <- function(y, mu1, mu2, sd1, sd2, pi.hat) {
  # responsibilities of dist-2
  gamma      <- pi.hat * dnorm(y, mu2, sd2) / ((1 - pi.hat) * dnorm(y, mu1, sd1) +
    pi.hat * dnorm(y, mu2, sd2))
  new_mu1    <- sum((1 - gamma) * y) / sum(1 - gamma)
  new_mu2    <- sum(gamma * y) / sum(gamma)
  new_var1   <- sum((1 - gamma) * (y - mu1)^2) / sum(1 - gamma) # this is variance
  new_var2   <- sum(gamma * (y - mu2)^2) / sum(gamma)   # this is variance
  new_pi_hat <- mean(gamma)
  LL         <- log((1 - new_pi_hat) * dnorm(y, new_mu1, sqrt(new_var1)) +
                    new_pi_hat * (dnorm(y, new_mu2, sqrt(new_var2))) )
  list(mu     = c(new_mu1, new_mu2),
       sigma  = sqrt(c(new_var1, new_var2)),
       pi_hat = new_pi_hat,
       loglik = sum(LL),
       responsibilities_2 = gamma
  )
}

#' Choose Initial Conditions
#'
#' @param y value.
#' @param k value.
#' @importFrom stats rexp rnorm runif sd
#' @noRd
choose_init <- function(y, k = 2) {
  bins   <- split(y, sample(1:k, length(y), replace = TRUE))
  emp_mu <- vapply(bins, mean, numeric(1))
  emp_sd <- vapply(bins, sd, numeric(1))
  if ( any(emp_sd == 0) ) {
    emp_sd[which(emp_sd == 0)] <- runif(sum(emp_sd == 0), 0, sd(y))
  }
  sigma_k <- 1 / rexp(k, rate = emp_sd)
  mu_k    <- rnorm(k, mean = emp_mu, sd = sigma_k)
  list(start.mu = mu_k, start.sd = sigma_k, start.pi = runif(1))
}

#' 2-distribution (k2) Gaussian Mixture Model
#'
#' Estimates the parameters of a 2 distribution mixture model
#' via expectation maximization.
#'
#' @param data Numeric vector.
#' @param pars Initial values for `start.mu`, `start.sd`, and `start.pi`.
#' @param max.iter Max number of iterations to perform.
#' @param max.restarts Max number of restarts ro perform.
#' @param eps The machine precision for determining when to stop the algorithm.
#' @return A `mix_k2` class object.
#' @author Stu Field
#' @references Tibshirani and Hastie
#' @examples
#' # Generate 2 gaussian distributions
#' x <- withr::with_seed(101,
#'   c(rnorm(100, mean = 10, sd = 1), rnorm(100, mean = 2, sd = 2)))
#' mix_theta <- normal_k2_mixture(x)
#' mix_theta
#'
#' @export
normal_k2_mixture <- function(data, pars = list(start.mu = NULL,
                                                start.sd = NULL,
                                                start.pi = NULL),
                              max.iter = 1000,
                              max.restarts = 25,
                              eps = 1e-08) {

  good_names <- c("start.mu", "start.sd", "start.pi")

  if ( any(!names(pars) %in% good_names) ) {
    signal_oops("Pars arg is:", value(names(pars)))
    signal_info("Should be:", value(good_names))
    stop("Check spelling of list names for `pars =` argument.", call. = FALSE)
  }

  nulls <- vapply(pars, is.null, NA)

  if ( any(nulls) ) {
    null_nms <- names(nulls)                 # which are NULL
    def_pars <- choose_init(y = data, k = 2) # get start pars
    pars[null_nms] <- def_pars[null_nms]     # replace NULLs with starts
  }

  mu_par     <- pars$start.mu
  sigma_par  <- pars$start.sd
  pi_par     <- pars$start.pi
  iter       <- numeric(1)
  loglik     <- numeric(1)
  loglik_vec <- numeric(0)
  restarts   <- numeric(1)
  dll        <- 1 + eps

  while ( dll > eps ) {
    iter <- iter + 1
    tmp  <- em_1_step(y   = data,
                      mu1 = mu_par[1L],
                      mu2 = mu_par[2L],
                      sd1 = sigma_par[1L],
                      sd2 = sigma_par[2L],
                      pi.hat = pi_par)
    mu_par    <- tmp$mu
    sigma_par <- tmp$sigma
    pi_par    <- tmp$pi_hat
    dll       <- abs(loglik - tmp$loglik)
    loglik    <- tmp$loglik
    loglik_vec[iter] <- loglik
    if ( iter >= max.iter || min(sigma_par) < 1e-06 ) {
      signal_oops(
        "No convergence ... OR ... One of the variances is going to zero."
      )
      signal_info("Restarting with new initial conditions.")
      new_pars  <- choose_init(y = data, k = 2)
      mu_par    <- new_pars$start.mu
      sigma_par <- new_pars$start.sd
      pi_par    <- new_pars$start.pi
      restarts  <- restarts + 1
      if ( restarts > max.restarts ) {
        stop(
          "Too many restarts. Possible extreme outliers in distribution.",
          call. = FALSE
        )
      }
      iter   <- 0
      loglik <- 0
      loglik_vec <- numeric(0)
      dll    <- 1 + eps
    }
  }

  signal_done("Iteration ...", iter)
  structure(
    list(y      = data,
         mu     = mu_par,
         sigma  = sigma_par,
         pi_hat = pi_par,
         lambda = c(1 - pi_par, pi_par),
         loglik = loglik,
         loglik_vec = loglik_vec,
         niter      = iter,
         restarts   = restarts,
         posterior  = tmp$responsibilities_2,
         fn         = "normal_k2_mixture"),
    class = c("mix_k2", "list")
  )
}

#' Print Method
#'
#' S3 print method for `"mix_k2"` objects.
#'
#' @param x A `mix_k2` object generated from [normal_k2_mixture()].
#' @noRd
#' @export
print.mix_k2 <- function(x, ...) {
  writeLines(
    signal_rule(paste("Mix Type:", x$fn), line_col = "blue", lty = "double")
  )
  key <- c("n", "iter", "mu", "sigma", "pi_hat",
           "lambda", "final loglik") |> pad(15)
  value <- list(n = length(x$y), iter = x$niter, muvec = x$mu,
                sigmavec = x$sigma, pi = x$pi_hat, lambda = x$lambda,
                loglik = x$loglik)
  value <- lapply(value, function(.x) {
    .x <- round(.x, digits = 3L)
    if ( length(.x) > 1L ) {
      .x <- paste0("[", paste0(.x, collapse = ", "), "]")
    }
    add_style$blue(.x)
  })
  liter(key, value, function(.x, .y) {
    writeLines(paste(add_style$red(symbl$bullet), .x, .y))
  })
  writeLines(signal_rule(line_col = "green", lty = "double"))
  invisible(x)
}

#' Plot Method
#'
#' S3 plot method for `"mix_k2"` objects.
#'
#' @rdname normal_k2_mixture
#' @param x A `mix_k2` object generated from `normal_k2_mixture`.
#' @param type Character. Matched string one of: "density", "likelihood" or
#'   "posterior".
#' @param title Character. Title for the plot.
#' @param ... Additional parameters for extensibility.
#' @author Stu Field
#' @references See Tibshirani and Hastie ("bible"); pg. 273.
#' @examples
#' plot(mix_theta)
#' plot(mix_theta, "like")
#' plot(mix_theta, "post")
#' @importFrom graphics plot par lines hist axis box
#' @importFrom stats density
#' @export
plot.mix_k2 <- function(x, type = c("density", "likelihood", "posterior"),
                        title = NULL, ...) {
  type <- match.arg(type)
  k    <- length(x$mu)
  withr::local_par(list(mgp = c(2.00, 0.75, 0.00), mar = c(3L, 4L, 3L, 1L)))

  if ( type == "density" ) {
    if ( is.null(title) ) {
      title <- "Density Histogram"
    }
    sort_y <- sort(x$y)
    col_vec <- c("darkred", "navy")
    plot_df <- lapply(1:k, function(.i) {
      dnorm(sort_y, mean = x$mu[.i], sd = x$sigma[.i]) * x$lambda[.i]
    })
    max <- max(unlist(plot_df))
    hist(sort_y, prob = TRUE, main = title,
         xlab = sprintf("Data (n = %i)", length(x$y)), ylab = "Prob",
         col = "gray80", ylim = c(0, max), ...)
    box()
    lines(density(sort_y), lty = 2, lwd = 1, col = 1)
    for ( i in 1:k ) {
      lines(sort_y, plot_df[[i]], col = col_vec[i], lwd = 2)
    }
    abline(v = equal_likelihood_pt(x), lty = 2, col = "green")
  } else if ( type == "likelihood" ) {
    plot(x$loglik_vec, main = "Log-likelihood Trajectory", type = "b",
         ylab = "Log-Likelihood", xlab = "Iteration", lty = 2,
         col = "navy", pch = 21, bg = "darkred", lwd = 1.5, cex = 1.2)
    grid(col = "gray75")
  } else if ( type == "posterior" ) {
    max <- max(1, hist(x$y, plot = FALSE)$density)
    hist(x$y, prob = TRUE, main = "Posterior Responsibilities", xlab = "Data",
         breaks = 20, col = "gray80", ylim = c(0, max), ...)
    lines(density(x$y), lty = 2, col = 1, lwd = 1.5)
    lines(sort(x$y), x$posterior[order(x$y)], type = "b", lty = 2,
          col = "navy", pch = 21, bg = "darkred", lwd = 1.5, cex = 1.2)
    axis(1, at = x$y, labels = NA, col.ticks = 3, lwd.ticks = 2, tcl = 0.5)
  }
}

#' Calculate Equal Probability
#'
#' Calculate the point of equal likelihood between *2* distributions.
#'
#' @param x A `mix_k2` class object.
#' @return A scalar.
#' @examples
#' equal_likelihood_pt(mix_theta)
#' @noRd
equal_likelihood_pt <- function(x) {
  stopifnot(inherits(x, "mix_k2"))
  a <- (1 / (2 * x$sigma[1L]^2)) - (1 / (2 * x$sigma[2L]^2))
  b <- (x$mu[2L] / x$sigma[2L]^2) - (x$mu[1L] / x$sigma[1L]^2)
  cc <- (x$mu[1L]^2 / (2 * x$sigma[1]^2)) - (x$mu[2L]^2 / (2 * x$sigma[2L]^2)) -
    (log(x$sigma[2L] / x$sigma[1L] * x$lambda[1L] / x$lambda[2L]))
  lik <- numeric(2)
  lik[1L] <- (-b + sqrt(b^2 - 4 * a * cc)) / (2 * a)
  lik[2L] <- (-b - sqrt(b^2 - 4 * a * cc)) / (2 * a)
  lik[which(lik > min(x$mu) & lik < max(x$mu))]
}
