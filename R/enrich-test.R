#' Test for Enrichment
#'
#' Calculated whether `2x2` table is enriched
#'   for a particular group using Hypergeometric Distribution and
#'   the Fisher's Exact test for count data.
#'
#' Can also pass a *named* list containing:
#' \describe{
#'   \item{n11}{The corresponding \verb{[1, 1]} position of the table/matrix.}
#'   \item{n1_}{The sum of the top row of the table.}
#'   \item{n_1}{The sum of the first column of the table.}
#'   \item{n}{The sum of the table.}
#' }
#'
#' @param x A \eqn{2x2} confusion matrix (or contingency table) containing
#'   the binary decisions for each contingency. Can also be a (named) list
#'   containing each of the 4 contingencies. See above.
#' @param alternative `character(1)`. Whether to check
#'   for "two.sided" (both Enrich/Deplete)
#'   or specifically one or the other ("enrich" or "deplete").
#'
#' @return Both the comparison to the Hypergeometric Distribution and
#'   The Fisher Exact Test for Count Data with confidence intervals
#' @note Similar result to Fisher Exact test
#' @author Stu Field
#' @seealso [stats::dhyper()], [stats::fisher.test()]
#'
#' @examples
#' c_mat <- matrix(c(4, 2, 3, 11), ncol = 2)
#' enrich_test(c_mat)
#' en_list <- list(n11 = 4, n1_ = 7, n_1 = 6, n = 20)
#' enrich_test(en_list)
#' @importFrom stats fisher.test dhyper setNames
#' @export
enrich_test <- function(x, alternative = c("two.sided", "enrich", "deplete")) {

  if ( inherits(x, "matrix") ) {
    n11 <- x[1L, 1L]
    n1_ <- sum(x[1L, ])
    n_1 <- sum(x[, 1L])
    n2_ <- sum(x[2L, ])
    n   <- sum(x)
  } else if ( inherits(x, "list") && length(x) == 4L ) {
    # x must be passed as list with names:
    if ( is.null(names(x)) ) {
      stop(
        "List must be a *named* list with: `n11`, `n1_`, `n_1`, `n`.",
        call. = FALSE)
    }

    n11 <- x$n11
    n1_ <- x$n1_
    n_1 <- x$n_1
    n   <- x$n
    n2_ <- n - n1_
    x   <- matrix(c(n11, n_1 - n11, n1_ - n11, n2_ - (n_1 - n11)), ncol = 2L)
  } else {
    stop("Error in `x` argument. Incorrect format.", call. = FALSE)
  }

  prob_vec1 <- stats::dhyper(n11:n_1, n1_, n2_, n_1)
  one_sided <- sum(prob_vec1)                # sum the probabilities from x11 -> x.1
  prob_vec1[1L]        <- prob_vec1[1L] / 2
  one_sided_mid        <- sum(prob_vec1)     # half the first probability and sum
  two_sided_double     <- one_sided * 2      # double the one sided p-value
  two_sided_double_mid <- one_sided_mid * 2  # double the one sided p-value
  # ------------------------------------- #
  prob_vec2 <- stats::dhyper(0:n_1, n1_, n2_, n_1) |> setNames(as.character(0:n_1))
  prob_vec2 <- prob_vec2[which(prob_vec2 <= prob_vec2[as.character(n11)])]
  two_sided_min_lik <- sum(prob_vec2)
  prob_vec2[as.character(n11)] <- prob_vec2[as.character(n11)] / 2
  two_sided_min_lik_mid <- sum(prob_vec2)

  ConfusionTable <- x
  dimnames(ConfusionTable) <- list(c("yes", "no"), c("yes", "no"))
  altern <- match.arg(alternative)
  altern <- switch(altern, enrich = "greater", deplete = "less", "two.sided")
  fisher <- stats::fisher.test(ConfusionTable, alternative = altern)

  hyper <- tibble::tribble(
    ~Test,                 ~"p-value",
    "1 sided",             one_sided,
    "2 sided double",      two_sided_double,
    "1 sided mid",         one_sided_mid,
    "2 sided double mid",  two_sided_double_mid,
    "Fisher's Exact",      two_sided_min_lik,
    "2 sided min lik mid", two_sided_min_lik_mid
  )
  hyper$Preferred <- ifelse(hyper$Test == "2 sided min lik mid",
                            symbl$star, symbl$dot)
  hyper$CI95 <- ifelse(hyper$Test == "Fisher's Exact",
                       sprintf("(%0.3f, %0.3f)",
                               fisher$conf.int[1L], fisher$conf.int[2L]),
                       symbl$dot)

  signal_rule("Counts Table", line_col = "blue")
  print(ConfusionTable)
  cat("\n")
  signal_rule("Tests", line_col = "blue")
  print(hyper)
  signal_rule(lty = "double", line_col = "green")
  invisible(list(results     = hyper,
                 confusion   = ConfusionTable,
                 alternative = altern))
}
