#' Handle and Capture Side Effects
#'
#' Wrappers to capture side effects and silence function output. This can
#' be particularly useful for instances where you know a function may
#' generate a warning/error, but do not want to terminate any higher-level
#' processes. Downstream code can then trap the returned object accordingly
#' because the output is in an expected structure.
#' Similar to [purrr::safely()], [purrr::quietly()], and [purrr::partial()].
#' Note that [be_hard()] is not a simple drop-in replacement, does not
#' support quasi-quotation, but should be a sufficient replacement in most cases.
#'
#' @name handlers
#' @param .f A function to capture and handle in a user controlled manner.
#' @param otherwise The value of `result` in the event of an error.
#' @param ... Named arguments to be hard-coded as key-value pairs.
#' @examples
#' # be safe
#' safelog <- be_safe(log2)
#' safelog("a")
#' safelog("foo" + 10)
#' safelog(32)
#'
#' # be quiet
#' # create a chatty function:
#' f <- function(x) {
#'   message("This is a message.")
#'   message("This is a second message.")
#'   warning("This is a warning!")
#'   warning("This is a second warning!")
#'   cat("Multiplying pi * x^2:\n")
#'   pi * x^2
#' }
#' f2 <- be_quiet(f)
#' f2(5)
#'
#' # be hard-coded
#' q2 <- be_hard(quantile, probs = c(0.025, 0.975), na.rm = TRUE)
#' vec <- rnorm(50)
#' navec <- c(NA_real_, vec)
#'
#' quantile(vec, probs = c(0.025, 0.975))
#' q2(vec)
#'
#' quantile(navec, probs = c(0.025, 0.975), na.rm = TRUE)
#' q2(navec)
NULL


#' @describeIn handlers Roll through [stop()] or [usethis::ui_stop()] messages.
#' @return [be_safe()]: a list containing:
#' * result: if `NULL` there was an error, see `error`.
#' * error: if `NULL` no errors were encountered, see `result`.
#' @export
be_safe <- function(.f, otherwise = NULL) {
  function(...) {
    tryCatch(list(result = .f(...), error = NULL), error = function(e) {
      list(result = otherwise, error = e$message)
    }, interrupt = function(e) {
      stop("Terminated by user", call. = FALSE)
    })
  }
}

#' @describeIn handlers Be quiet! ... always contains a `result`.
#' @return [be_quiet()]: a list containing:
#' * result: the result of the evaluated expression.
#' * output: any output that was captured during evaluation.
#' * warnings: any warnings that were encountered during evaluation.
#' * messages: any messages that were triggered during evaluation.
#' @export
be_quiet <- function(.f) {
  function(...) {
    warnings <- character(0)
    wHandler <- function(w) {
      warnings <<- c(warnings, w$message) # nolint: undesirable_operator_linter.
      invokeRestart("muffleWarning")
    }
    messages <- character(0)
    mHandler <- function(m) {
      messages <<- c(messages, m$message) # nolint: undesirable_operator_linter.
      invokeRestart("muffleMessage")
    }
    temp <- file()
    sink(temp)
    on.exit({
      sink(NULL)
      close(temp)
    })
    result <- withCallingHandlers(.f(...), warning = wHandler, message = mHandler)
    list(
      result   = result,
      output   = paste0(readLines(temp, warn = FALSE), collapse = "\n"),
      warnings = warnings,
      messages = messages
    )
  }
}


#' @describeIn handlers Be hard! ... coded for specified arguments.
#' @return [be_hard()]: a function with new hard-coded arguments.
#' @export
be_hard <- function(.f, ...) {
  stopifnot(is.function(.f))
  args <- list(...)
  new <- function(...) {
    do.call(.f, c(args, `...` = quote(...)))
  }
  structure(new, class = c("hard_coded", "function"), args = args,
            modified_fn = as.name(deparse(substitute(.f))))
}

#' @noRd
#' @export
print.hard_coded <- function(x, ...) {
  fn <- attr(x, "modified_fn")
  cat("Hard-coded function: ", fn, "()\n", sep = "")
  args <- attr(x, "args")
  vals <- vapply(args, paste, collapse = ", ", "")
  print(
    data.frame(arg = names(args), value = vals),
    row.names = FALSE, right = FALSE
  )
  invisible(x)
}
