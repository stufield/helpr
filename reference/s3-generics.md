# Common S3 Generics

These are S3 generic functions that can be used to minimize package
dependencies across multiple packages that have the same method.

## Usage

``` r
fit(object, data, params, ...)

tune(model, ...)

get_pos_class(model, ...)

get_model_classes(model, ...)

get_model_features(model, ...)

get_model_coef(model, ...)

get_model_type(model, ...)

get_model_params(model, ...)

calc_model_metrics(model, data, ...)

cross_validate(model, data, k, ...)

calc_predictions(model, newdata, ...)
```

## Arguments

- data:

  The data on which to assess the model.

- params:

  Model parameters. Optional depending on model type.

- ...:

  Used for extensibility of downstream S3 methods.

- model, object:

  A model object.

- k:

  The number of folds to perform (k-fold cross-validation).

- newdata:

  The test set (`data.frame`) containing (features) corresponding to the
  model parameters. For some models, if `newdata = NULL`, training (or
  out-of-bag) predictions are returned.

## Functions

- `fit()`: A S3 generic to "fit" a model.

- `tune()`: A S3 generic to "tune" a model.

- `get_pos_class()`: For a binary classification model, determine the
  positive class, i.e. the "disease" or "case" class.

- `get_model_classes()`: In a binary classification model, determine the
  classes in the model.

- `get_model_features()`: Returns a character vector of the model
  predictors/covariates contained within a model object. After
  interrogating the model object, this function returns the covariates
  (features) contained in the object, both proteomic or clinical meta
  data.

- `get_model_coef()`: Returns a named numeric vector of the regression
  coefficients of a linear model contained within a model object.

- `get_model_type()`: A S3 generic to determine the model type, e.g.
  classification, regression, or survival.

- `get_model_params()`: A S3 generic to determine the model parameters.

- `calc_model_metrics()`: A S3 generic to calculate performance metrics
  of a model.

- `cross_validate()`: A S3 generic to perform k-fold cross-validation
  for a given model.

- `calc_predictions()`: Calculate predictions of a given model on a test
  set defined by `newdata`. The return object is always a `data.frame`
  class object in 1 of 3 formats, depending on the model type, and
  containing model predictions for `newdata`. The data frame is named
  according to:

  |                    |                                                   |                                                                       |
  |--------------------|---------------------------------------------------|-----------------------------------------------------------------------|
  | **Model Type**     | **Format**                                        | **Example** (n = 1)                                                   |
  | **continuous**     | `pred_<endpoint>`                                 | `data.frame(pred_vo2max = 303.9)`                                     |
  | **classification** | `pred_class`, `prob_<class1>`, `prob_<class2>`    | `data.frame(pred_class = "nash", prob_normal = 0.2, prob_nash = 0.8)` |
  | **survival**       | `pred_status`, `risk_<status1>`, `risk_<status2>` | `data.frame(pred_status = "MI", risk_noMI = 0.2, risk_MI = 0.8)`      |

## Note

`get_model_coef()`: non-linear models will not have a linear predictor,
and thus return `NULL`. See specific S3 method `?get_model_coef.class`
for details.

`calc_predictions()`: not all classification models will have a linear
predictor, any non-GLM model, e.g. random forest or SVM, will not.

## Model Features Classes

|                  |                                           |                                                                        |
|------------------|-------------------------------------------|------------------------------------------------------------------------|
| Class            | Model type                                | See examples                                                           |
| `"glm"`          | Logistic & linear regression              | [`glm()`](https://rdrr.io/r/stats/glm.html)                            |
| `"glmnet"`       | Regularized logistic or linear regression | `glmnet::glmnet()`                                                     |
| `"naiveBayes"`   | Standard naive Bayes                      | `e1071::naiveBayes()`                                                  |
| `"fit_nb"`       | Naive Bayes (robust pars)                 | `fit_nb()`                                                             |
| `"randomForest"` | Random Forests                            | `randomForest::randomForest()`                                         |
| `"lda"`          | Linear Discriminant Analysis              | [`MASS::lda()`](https://rdrr.io/pkg/MASS/man/lda.html)                 |
| `"kknn"`         | k-nearest neighbor                        | `kknn::kknn()`                                                         |
| `"gbm"`          | generalized boosted regression models     | `gbm::gbm()`                                                           |
| `"svm"`          | Support Vector Machines                   | `e1071::svm()`                                                         |
| `"survreg"`      | Survival models                           | [`survival::survreg()`](https://rdrr.io/pkg/survival/man/survreg.html) |
| `"psm"`          | Survival models                           | `rms::psm()`                                                           |
| `"coxnet2"`      | Regularized cox                           | `fitCoxnet()`                                                          |
| `"survregnet"`   | Regularized survival                      | `fitSurvregnet()`                                                      |
| `"train"`        | caret models                              | `caret::train()`                                                       |

## Author

Stu Field
