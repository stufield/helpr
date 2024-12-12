#' Test for Enrichment
#'
#' Calculated whether `2x2` table is enriched for a particular
#'   group using Hypergeometric Distribution and
#'   the Fisher's Exact test for count data.
#'
#' Can also pass a *named* list containing:
#' \tabular{rcl}{
#'   `n11` \tab : \tab The corresponding \verb{[1,1]} position of the `2x2` matrix.\cr
#'   `n1_` \tab : \tab The sum of the top row of the table.\cr
#'   `n_1` \tab : \tab The sum of the first column of the table.\cr
#'   `n`   \tab : \tab The sum of the table.\cr
#' }
#'
#' @param x A `2x2` confusion matrix (aka contingency table) containing
#'   the binary decisions for each contingency (or a similarly structured
#'   data frame). Can also be a (named) list containing each of the
#'   4 contingencies. See examples.
#' @param ... Arguments passed to [stats::fisher.test()]. In particular,
#'   `alternative` which determines whether to check for both
#'   enrichment and depletion ("two.sided") or specifically one
#'   *or* the other: enrichment = "greater"; depletion = "less".
#'
#' @return An "enrichment" class object, a list of the significance
#'   tests calculated from a Hypergeometric Distribution
#'   [stats::dhyper()] as well as those calculated via Fisher's Exact
#'   [stats::fisher.test()] test for count data
#'   testing the H_o that the odds ratio is equal to 1.
#'   The p-values for various flavors of Hypergeometric test are:
#'   \item{1-sided}{add here.}
#'   \item{2-sided}{double of `1-sided`.}
#'   \item{1-sided mid}{add description}
#'   \item{2-sided mid}{double of `1-sided mid`.}
#'   \item{2-sided min lik}{this differs previous, but is most
#'                          similar to Fisher's Exact}
#'   \item{2-sided min lik mid}{this is typically preferred}
#'
#' @author Stu Field
#' @seealso [stats::dhyper()], [stats::fisher.test()]
#'
#' @examples
#' c_mat <- matrix(c(4, 2, 3, 11), ncol = 2L)
#' enrich_test(c_mat)
#'
#' # or pass a named list
#' en_list <- list(n11 = 4, n1_ = 7, n_1 = 6, n = 20)
#' enrich_test(en_list)
#' @export
enrich_test <- function(x, ...) {
  UseMethod("enrich_test")
}

#' @noRd
#' @export
enrich_test.default <- function(x, ...) {
  stop("Unable to dispatch S3 method for class: ", value(class(x)),
       call. = FALSE)
}

#' @rdname enrich_test
#' @export
enrich_test.list <- function(x, ...) {

  stopifnot("`x` must be a list of length 4." = length(x) == 4L)

  if ( is.null(names(x)) ) {
    stop(
      "List must be *named* with: ", value(c("n11", "n1_", "n_1", "n")),
      call. = FALSE)
  }

  n11 <- x$n11
  n1_ <- x$n1_
  n_1 <- x$n_1
  n   <- x$n
  n2_ <- n - n1_
  m <- matrix(c(n11, n_1 - n11, n1_ - n11, n2_ - (n_1 - n11)), ncol = 2L)
  enrich_test(m, ...)
}

#' @rdname enrich_test
#' @export
enrich_test.data.frame <- function(x, ...) {
  enrich_test(as.matrix(x), ...)
}

#' @rdname enrich_test
#' @importFrom stats fisher.test dhyper setNames
#' @export
enrich_test.matrix <- function(x, ...) {

  stopifnot("`x` must be a 2x2 matrix." = identical(dim(x), c(2L, 2L)))

  n11 <- x[1L, 1L]
  n1_ <- sum(x[1L, ])
  n_1 <- sum(x[, 1L])
  n2_ <- sum(x[2L, ])
  n   <- sum(x)   # nolint: oject_usage_linter

  prob_vec1 <- stats::dhyper(n11:n_1, n1_, n2_, n_1)
  one_sided <- sum(prob_vec1) # sum probabilities from x11 -> x.1 (col1)
  # half the p[1] & sum
  one_sided_mid <- sum(prob_vec1[-1L]) + (prob_vec1[1L] / 2)
  two_sided     <- one_sided * 2     # double the one sided p-value
  two_sided_mid <- one_sided_mid * 2 # double the one sided p-value

  # -------------
  # calc likelihoods
  prob_vec2 <- stats::dhyper(0:n_1, n1_, n2_, n_1) |>
    setNames(as.character(0:n_1))
  p_n11 <- prob_vec2[as.character(n11)]
  prob_vec2 <- prob_vec2[prob_vec2 <= p_n11]
  two_sided_min_lik <- sum(prob_vec2)   # this is Fisher's
  # half the p[n11] & sum
  idx <- which(names(prob_vec2) == as.character(n11))
  two_sided_min_lik_mid <- sum(prob_vec2[-idx]) + (prob_vec2[[idx]] / 2)

  fisher <- stats::fisher.test(x, ...)

  hyper <- tibble::enframe(
    c("1-sided"            = one_sided,
      "2-sided"            = two_sided,
      "1-sided mid"        = one_sided_mid,
      "2-sided mid"        = two_sided_mid,
      "2-sided min lik"    = two_sided_min_lik,     # similar to Fisher's
      "2-sided min lik mid" = two_sided_min_lik_mid
    ),
    name  = "test",
    value = "p-value"
  )

  dimnames(x) <- list(v1 = c("no", "yes"), v2 = c("no", "yes"))

  list(confusion   = x,
       result      = hyper,
       fisher_test = fisher) |>
    add_class("enrichment")
}

#' @noRd
#' @export
print.enrichment <- function(x, ...) {
  signal_rule("Enrichment Tests", lty = "double", line_col = "green")
  signal_rule("Counts Table", line_col = "blue")
  preferred <- "2-sided min lik mid"
  idx <- which(x$result$test == preferred)
  x$result$test[idx] <- paste0(preferred, symbl$star)
  pad20 <- be_hard(pad, width = 20L)
  print(x$confusion)
  cat("\n")
  signal_rule("Hypergeometric", line_col = "blue")
  signal_info(pad20("Test-type"), "p-value")
  cat("\n")
  apply(x$result, 1, function(.x) {
    signal_todo(pad20(.x[["test"]]), .x[["p-value"]])
  })
  cat("\n")
  signal_rule("Fisher's Exact", line_col = "blue")
  signal_info(pad20("Alternative"), x$fisher_test$alternative)
  cat("\n")
  signal_todo(pad20("Odds Ratio"), round(x$fisher_test$estimate, 8L))
  signal_todo(pad20("Odds Ratio p-value"), round(x$fisher_test$p.value, 8L))
  CI95 <- sprintf("[%0.3f, %0.3f]",
                  x$fisher_test$conf.int[1L],
                  x$fisher_test$conf.int[2L])
  signal_todo(pad20("OR CI95"), CI95)
  signal_rule(lty = "double", line_col = "green")
  invisible(x)
}
