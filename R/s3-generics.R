#' Common S3 Generics
#'
#' These are S3 generic functions that can be used to minimize package
#' dependencies across multiple packages that have the same method.
#'
#' @name s3-generics
#' @param model,object A model object.
#' @param data The data on which to assess the model.
#' @param k The number of folds to perform (k-fold cross-validation).
#' @param params Model parameters. Optional depending on model type.
#' @param ... Used for extensibility of downstream S3 methods.
#' @author Stu Field
NULL



#' @describeIn s3-generics
#'   A S3 generic to "fit" a model.
#' @export
fit <- function(object, data, params, ...) UseMethod("fit")

#' @noRd
#' @export
fit.default <- function(object, data, params, ...) {
  s3_default_stop(object)
}

#' @describeIn s3-generics
#'   A S3 generic to "tune" a model.
#' @export
tune <- function(model, ...) UseMethod("tune")

#' @noRd
#' @export
tune.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   For a binary classification model, determine the
#'   positive class, i.e. the "disease" or "case" class.
#' @export
get_pos_class <- function(model, ...) UseMethod("get_pos_class")

#' @noRd
#' @export
get_pos_class.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   In a binary classification model, determine the classes in the model.
#' @export
get_model_classes <- function(model, ...) UseMethod("get_model_classes")

#' @noRd
#' @export
get_model_classes.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   Returns a character vector of the model predictors/covariates
#'   contained within a model object.
#'   After interrogating the model object, this function returns
#'   the covariates (features) contained in the object, both proteomic
#'   or clinical meta data. Currently available for:
#'
#'   | Class          | Model type                    | See examples           |
#'   | -------------: | ----------------------------- | ---------------------- |
#'   | `"glm"`        | Logistic & linear regression  | [glm()] |
#'   | `"glmnet"`     | Regularized logistic or linear regression | [glmnet::glmnet()] |
#'   | `"naiveBayes"` | Standard naive Bayes          | `e1071::naiveBayes()` |
#'   | `"fit_nb"`     | Naive Bayes (robust pars)     | `fit_nb()` |
#'   | `"randomForest"` | Random Forests              | [randomForest::randomForest()] |
#'   | `"lda"`        | Linear Discriminant Analysis  | [MASS::lda()] |
#'   | `"kknn"`       | k-nearest neighbor            | [kknn::kknn()] |
#'   | `"gbm"`        | generalized boosted regression models | [gbm::gbm()] |
#'   | `"svm"`        | Support Vector Machines       | [e1071::svm()] |
#'   | `"survreg"`    | Survival models               | [survival::survreg()] |
#'   | `"psm"`        | Survival models               | `rms::psm()` |
#'   | `"coxnet2"`    | Regularized cox               | `fitCoxnet()` |
#'   | `"survregnet"` | Regularized survival          | `fitSurvregnet()` |
#'   | `"train"`      | \pkg{caret} models            | [caret::train()] |
#' @export
get_model_features <- function(model, ...) UseMethod("get_model_features")

#' @noRd
#' @export
get_model_features.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   Returns a named numeric vector of the regression coefficients of a linear
#'   model contained within a model object.
#' @note [get_model_coef()]: non-linear models will not have a linear predictor,
#'   and thus return `NULL`.
#'   See specific S3 method `?get_model_coef.class` for details.
#' @export
get_model_coef <- function(model, ...) UseMethod("get_model_coef")

#' @noRd
#' @export
get_model_coef.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   A S3 generic to determine the model type, e.g. classification,
#'   regression, or survival.
#' @export
get_model_type <- function(model, ...) UseMethod("get_model_type")

#' @noRd
#' @export
get_model_type.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   A S3 generic to determine the model parameters.
#' @export
get_model_params <- function(model, ...) UseMethod("get_model_params")

#' @noRd
#' @export
get_model_params.default <- function(model, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   A S3 generic to calculate performance metrics of a model.
#' @export
calc_model_metrics <- function(model, data, ...) UseMethod("calc_model_metrics")

#' @noRd
#' @export
calc_model_metrics.default <- function(model, data, ...) {
  s3_default_stop(model)
}

#' @describeIn s3-generics
#'   A S3 generic to perform k-fold cross-validation for a given model.
#' @export
cross_validate <- function(model, data, k, ...) UseMethod("cross_validate")

#' @noRd
#' @export
cross_validate.default <- function(model, data, k, ...) {
  s3_default_stop(model)
}


#' Calculate Predictions
#'
#' @describeIn s3-generics
#'   Calculate predictions of a given model on a test set defined by `newdata`.
#'   The return object is always a `data.frame` class object in 1 of 3 formats,
#'   depending on the model type, and containing model predictions for `newdata`.
#'   The data frame is named according to:
#' \tabular{lll}{
#'   __Model Type__     \tab __Format__ \tab __Example__ (n = 1) \cr
#'   **continuous**     \tab `pred_<endpoint>` \tab
#'     `data.frame(pred_vo2max = 303.9)` \cr
#'   **classification** \tab `pred_class`,
#'                           `prob_<class1>`,
#'                           `prob_<class2>` \tab
#'     `data.frame(pred_class = "nash", prob_normal = 0.2, prob_nash = 0.8)` \cr
#'   **survival**       \tab `pred_status`,
#'                           `risk_<status1>`,
#'                           `risk_<status2>` \tab
#'     `data.frame(pred_status = "MI", risk_noMI = 0.2, risk_MI = 0.8)` \cr
#' }
#'
#' @param newdata The test set (`data.frame`) containing protein
#'   (features) corresponding to the model parameters.
#'   For some models, if `newdata = NULL`, training (or out-of-bag)
#'   predictions are returned.
#' @note [calc_predictions()]: not all classification models will have
#'   a linear predictor, any non-GLM model, e.g. random forest or SVM, will not.
#' @export
calc_predictions <- function(model, newdata, ...) {
  UseMethod("calc_predictions")
}

#' @noRd
#' @export
calc_predictions.default <- function(model, newdata, ...) {
  s3_default_stop(model)
}


# helper stop() for default generics above
s3_default_stop <- function(.x) {
  cls   <- class(.x)
  s3gen <- deparse(sys.calls()[[sys.nframe() - 1L]])
  s3gen <- sub("\\..*", "", s3gen)
  stop(
    "Could not find a `", s3gen, "()` S3 method for this model type: ",
    value(cls), call. = FALSE
  )
}
