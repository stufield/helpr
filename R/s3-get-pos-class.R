
#' @noRd
#' @export
get_pos_class.glm <- function(model, ...) {
  if ( model$family$family == "binomial" ) {
    classes <- get_model_classes(model, ...)
    class   <- select_binary(classes, 2L)
  } else {
    stop(
      "`glm` models with family ",
      value(model$family$family),
      " are not supported",
      call. = FALSE
    )
  }

  if ( class == 0 || tolower(class) %in% c("n", "negative", "neg") ) {
    # Because the documentation for `glm` is
    # difficult to parse/easily skipped
    signal_info(
      "Extracted positive class is `0`, `N`, `neg`, or `negative`;",
      "these are labels commonly used for negative classes.",
      "Check how the response was supplied to `glm()`.",
      "If a factor, the positive class should be the second level.",
      "If a matrix, the positive class size should be in the",
      "first column."
    )
  }
  class
}

#' @noRd
#' @export
get_pos_class.lda <- function(model, ...) {
  select_binary(model$lev, 2L)
}

#' @noRd
#' @export
get_pos_class.libml_nb <- function(model, ...) {
  select_binary(model$levels, 2L)
}

#' @noRd
#' @export
get_pos_class.naiveBayes <- function(model, ...) {
  get_pos_class.libml_nb(model)
}

#' @noRd
#' @export
get_pos_class.kknn <- function(model, ...) {
  select_binary(model$classes, 2L)
}

#' @noRd
#' @export
get_pos_class.svm <- function(model, ...) {
  select_binary(model$levels, 2L)
}

#' @noRd
#' @export
get_pos_class.gbm <- function(model, ...) {
  if ( "class" %in% names(model) ) {
    select_binary(levels(model$class), 2L)
  } else {
    model$classes[length(model$classes)]
  }
}

#' @noRd
#' @export
get_pos_class.randomForest <- function(model, ...) {
  select_binary(model$classes, 2L)
}

#' @noRd
#' @export
get_pos_class.glmnet <- function(model, ...) {
  select_binary(model$classnames, 2L)
}

#' @noRd
#' @export
get_pos_class.train <- function(model, ...) {
  select_binary(model$levels, 1L)
}

#' @noRd
#' @export
get_pos_class.psm <- function(model, ...) "1"

#' @noRd
#' @export
get_pos_class.survreg <- function(model, ...) "1"

#' @noRd
#' @export
get_pos_class.survregnet <- function(model, ...) "1"

#' @noRd
#' @export
get_pos_class.coxnet2 <- function(model, ...) "1"


# error trip if non-binary
# otherwise extract the desired element
select_binary <- function(x, i) {
  if ( length(unique(x)) != 2L ) {
    stop("Non-binary classification model detected: ",
         value(x), call. = FALSE)
  } else {
    x[i]
  }
}
