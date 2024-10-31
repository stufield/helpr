#' @noRd
#' @export
get_model_classes.glm <- function(model, ...) {
  if ( model$family$family != "binomial" ) {
    stop("`glm` models with family ", value(model$family$family),
         " are not supported.", call. = FALSE)
  }
  if ( "classes" %in% names(model) ) {
    model$classes
  } else if ( "model" %in% names(model) ) {
    response <- stats::model.response(stats::model.frame(model))
    # Depending on how the data were originally supplied, `glm` stores the
    # class information in different ways
    if ( is.factor(response) ) {
      levels(response)
    } else if ( is.matrix(response) ) {
      rev(colnames(response))
    } else {
      sort(unique(response))
    }
  } else {
    stop(
      "Unable to determine the classes for this `glm` model.",
      call. = FALSE
    )
  }
}
