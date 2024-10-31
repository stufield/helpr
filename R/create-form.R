#' Create A Formula
#'
#' A convenient utility to quickly generate formula objects in a
#' standardized format and environment.
#'
#' @param response A quoted string representing the LHS of the
#' formula, i.e. the response variable (`Y`).
#' @param features A vector of quoted strings representing the
#' model features/predictors. Used to generate the right-hand side (RHS)
#' of the formula.
#' @param collapse Character. The separator for features.
#' Either `+` for main effects, `*` for interactions.
#' @param env The environment in which to evaluate the formula.
#' To keep the formula object as light-weight as possible, the default is
#' the current function environment/scope. However, some occasions
#' (e.g. unit testing)  may require the formula's environment to capture
#' certain objects necessary to fit a model (e.g. weights).
#' @return A stats formula. See [formula()].
#' @author Stu Field
#' @seealso [eval()], [environment()]
#' @examples
#' ft <- c("ft_1234.56", "ft_8899.8", "ft_3334.3")
#' f1 <- create_form("class", ft)
#' print(f1, showEnv = FALSE)
#'
#' # environment manipulation
#' # cleanest light-weight formula (default)
#' ls(environment(f1))
#'
#' # capture another environment
#' e     <- new.env()
#' e$new <- LETTERS
#' e$obj <- rnorm(100)
#' f2    <- create_form("class", ft, env = e)
#' ls(environment(f2))
#' @export
create_form <- function(response, features, collapse = c("+", "*"), env = NULL) {
  collapse <- match.arg(collapse)
  if ( is.null(env) ) {
    env <- environment()
  }
  expr <- str2lang(paste(response, "~", paste(features, collapse = collapse)))
  rm(response, features, collapse)   # clean up environment; ensure light-weight
  eval(expr, envir = env)
}
