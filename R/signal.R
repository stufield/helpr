#' Signal Feedback to the Console UI
#'
#' Similar to `usethis::ui_*()` function suite but does not require
#'   importing the \pkg{usethis}, \pkg{crayon}, or \pkg{cli} packages.
#'   All `signal_*()` functions can be silenced by
#'   setting `options(signal.quiet = TRUE)`.
#'
#' @name signal
#'
#' @param x Character. A string to report to the UI or to add a style/color.
#' @param y A coloring function, i.e. an element the `add_style` object,
#'   see the `col` argument.
#' @param col Color (or style) for the text (or line). Currently one of:
#'  * red
#'  * green
#'  * yellow
#'  * blue
#'  * magenta
#'  * cyan
#'  * black
#'  * white
#'  * grey
#'  * bold
#'  * italic
#'  * underline
#'  * inverse
#'  * strikethrough
#'
#' @param ... Elements passed directly to [cat()].
NULL

#' @describeIn signal
#'   Signal a value to the UI. Similar to [usethis::ui_value()].
#'   Each element of `x` becomes an entry in a comma separated list
#'   and a `blue` color is added.
#'
#' @examples
#' n <- 4
#' cat("You need this many bikes:", value(n + 1))
#'
#' # value() collapses lengths by sep = ", "
#' value(names(mtcars))
#'
#' @export
value <- function(x) {
  if ( is.character(x) ) {
    ispath <- is.dir(x) | grepl("/$", x)
    if ( all(ispath) ) {
      x <- paste0(x, "/")
      x <- gsub("//", "/", x)
      x <- encodeString(x)
    } else {
      x <- encodeString(x, quote = "'")
    }
  }
  x <- add_style$blue(x)
  x <- paste0(x, collapse = ", ")
  structure(x, class = c("str_value", "character"))
}

#' @noRd
#' @export
print.str_value <- function(x, ..., sep = "\n") {
  cat(x, ..., sep = sep)
  invisible(x)
}

#' @describeIn signal
#'   Signal a completed task to the UI. Similar to [usethis::ui_done()].
#'
#' @examples
#' # signal_done()
#' signal_done("Tests have passed!")
#'
#' # easily construct complex messages
#' signal_done("The 'LETTERS' vector has", value(length(LETTERS)), "elements")
#'
#' @export
signal_done <- function(...) {
  sym <- add_color(symbl$tick, "green")
  .inform(sym, ...)
}

#' @describeIn signal
#'   Signal a to-do task to the UI. Similar to [usethis::ui_todo()].
#'
#' @export
signal_todo <- function(...) {
  sym <- add_color(symbl$bullet, "red")
  .inform(sym, ...)
}

#' @describeIn signal
#'   Signal oops error to the UI. Similar to [usethis::ui_oops()].
#'
#' @export
signal_oops <- function(...) {
  sym <- add_color(symbl$cross, "red")
  .inform(sym, ...)
}

#' @describeIn signal
#'   Signal info to the UI. Similar to [usethis::ui_info()].
#'
#' @export
signal_info <- function(...) {
  sym <- add_color(symbl$info, "cyan")
  .inform(sym, ...)
}

#' @describeIn signal
#'   Make a rule with left aligned text. Similar to [cli::rule()].
#'
#' @param text `character(1)`. String added at the left margin
#'   of the horizontal rule.
#' @param line_col See `col`.
#' @param lty `character(1)`. Either "single" or "double" line type (matched).
#'
#' @examples
#' # add a horizontal rule
#' signal_rule()
#'
#' signal_rule("Header", line_col = "green", lty = "double")
#'
#' @export
signal_rule <- function(text = "", line_col = NULL,
                        lty = c("single", "double")) {
  if ( is.null(line_col) ) {
    line_col <- ifelse(is_dark_theme(), "none", "black")
  }
  lty   <- match.arg(lty)
  line  <- switch(lty, single = symbl$line, double = symbl$double_line)
  width <- getOption("width") %||% 50L
  nc    <- nchar(text)
  if ( nc == 0L ) {
    rule <- add_color(paste(rep.int(line, width), collapse = ""), line_col)
  } else {
    # if text passed
    indent <- 2L
    left   <- add_color(paste(rep.int(line, indent), collapse = ""), line_col)
    right  <- paste(rep.int(line, max(0, width - nc - 4L)), collapse = "") |>
      add_color(line_col)
    rule   <- paste(left, text, right)
  }
  .inform(rule, class = "condition")  # not a message
  invisible(NULL)
}


#' Slimmed down version of rlang::inform
#' @param ... Arguments pasted together (with a space!) to form a message.
#' @param class The handler class to signal. Defaults to a `message`.
#' @noRd
.inform <- function(..., class = c("message", "condition"),
                    quiet = getOption("signal.quiet", default = FALSE)) {
  if ( !quiet ) {
    msg <- paste(...)
    cnd <- structure(list(message = msg), class = class)
    withRestarts(muffleMessage = function() NULL, {
      signalCondition(cnd)
      c_msg <- paste0(conditionMessage(cnd), "\n")
      cat(c_msg, sep = "", file = stdout())
    })
  }
  invisible(NULL)
}


avail_col_sty <- c("red", "green", "yellow", "blue",
                   "magenta", "cyan", "black", "white",
                   "grey", "bold", "italic", "underline",
                   "inverse", "strikethrough")

#' @describeIn signal
#'   Add a color or style to a string. Similar to [crayon::crayon()].
#'
#' @examples
#' cat(add_color("Hello world!", "blue"))
#'
#' # Combined with signal_*() functions
#' signal_oops("You shall", add_color("not", "red"), "pass!")
#'
#' @export
add_color <- function(x, col) {
  stopifnot(is.character(col))
  open <- switch(col,
                 red     = "\033[31m",
                 green   = "\033[32m",
                 yellow  = "\033[33m",
                 blue    = "\033[34m",
                 magenta = "\033[35m",
                 cyan    = "\033[36m",
                 black   = "\033[30m",
                 white   = "\033[37m",
                 grey    = "\033[90m",
                 bold    = "\033[1m",
                 italic  = "\033[3m",
                 inverse = "\033[7m",
                 none    = "\033[39m",
                 underline = "\033[4m",
                 strikethrough = "\033[9m",
    stop(
      "Problem with `col` argument. Possible values are: ",
      value(avail_col_sty), call. = FALSE
    )
  )
  close <- switch(col,
                  bold      = "\033[22m",
                  italic    = "\033[23m",
                  inverse   = "\033[27m",
                  underline = "\033[24m",
                  strikethrough = "\033[29m",
                  "\033[39m")
  is_testing <- identical(tolower(Sys.getenv("TESTTHAT")), "true")
  if ( is_testing || isTRUE(getOption("knitr.in.progress")) ) {
    x
  } else {
    # this piece ensures not to clobber existing colors/styles
    open %+% gsub(close, open, x, fixed = TRUE) %+% close
  }
}


`%+%` <- function(lhs, rhs) {
  stopifnot(is.character(lhs), is.character(rhs))
  stopifnot(length(lhs) == length(rhs) || length(lhs) == 1L || length(rhs) == 1L)
  if ( length(lhs) == 0L && length(rhs) == 0L ) {
    paste0(lhs, rhs)
  } else if ( length(lhs) == 0L ) {
    lhs
  } else if ( length(rhs) == 0L ) {
    rhs
  } else {
    paste0(lhs, rhs)
  }
}

#' @describeIn signal
#'   An alternative syntax. A list object where each
#'   element is a color/style function wrapping around `add_color()` and
#'   each element determines the `col` argument. See examples.
#'
#' @format NULL
#' @usage add_style
#'
#' @examples
#' # colors and styles available via add_style()
#' add_style
#'
#' # These are equivalent
#' cat(add_style$blue("Hello world!"))
#' cat(add_color("Hello world!", "blue"))
#'
#' # Combine styles
#' red <- add_style$red("This is red")
#' string <- c(red, "and this is not")
#' cat(string)
#'
#' # Combine styles
#' blue <- add_style$blue("blue")
#' red  <- add_style$red("red")
#' string <- add_style$bold(c(blue, red, "nothing"))
#' cat(string)
#'
#' @export
add_style <- lapply(setNames(avail_col_sty, avail_col_sty), function(.x) {
  fun <- add_color
  formals(fun)$col <- .x
  structure(fun, class = "helpr_style", "_style" = .x)
})

#' @describeIn signal
#'   Functions in the `apply_style` object have their
#'   own class, which allows for the special S3 print method and the chaining
#'   in the examples below.
#'
#' @export
print.helpr_style <- function(x, ...) {
  st <- attr(x, "_style")
  cat(
    "megaverse styling function, ",
    st,
    ": ",
    x("example output.\n"),
    sep = ""
  )
  invisible(x)
}

#' @describeIn signal
#'   Easily chain styles with `$` S3 method.
#'
#' @examples
#' # chain styles via `$`
#' cat(add_style$bold("Success"))
#' cat(add_style$bold$green("Success"))
#' cat(add_style$bold$green$italic("Success"))
#' cat(add_style$bold$green$italic$red("Success"))
#'
#' # potential typos are trapped
#' \dontrun{
#' cat(add_style$bold$greeen$italic("Success"))
#' }
#'
#' @export
`$.helpr_style` <- function(x, y) {
  if ( !y %in% avail_col_sty ) {
    stop("Invalid argument in `$`, is ", value(y), " a typo?", call. = FALSE)
  }
  sty <- add_style[[y]]
  fn  <- alist(string = , x(sty(string)))
  structure(as.function(fn), class = "helpr_style")
}

#' @describeIn signal
#'   Logical. Test if string contains ANSI styles/colors.
#'
#' @examples
#' # check for ANSI styling
#' has_style(add_style$green("Hello world!"))
#' has_style(add_style$italic("Hello world!"))
#'
#' @export
has_style <- function(x) {
  grepl(ansi_regex, x, perl = TRUE)
}

#' @describeIn signal
#'   Remove a color or style from character strings.
#'
#' @examples
#' # remove ANSI styling
#' cat(rm_style(add_style$green("Hello world!")))
#' cat(rm_style(add_style$italic$cyan("Hello world!")))
#'
#' @export
rm_style <- function(x) {
  if ( any(has_style(x)) ) {
    gsub(ansi_regex, "", x, perl = TRUE)
  } else {
    x
  }
}

ansi_regex <- "(?:(?:\\x{001b}\\[)|\\x{009b})(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])|\\x{001b}[A-M]"   # nolint: line_length_linter.
