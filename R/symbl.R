#' A list of UTF-8 or ASCII symbols.
#'
#' Similar to the \pkg{cli} package listing of UTF-8/Unicode symbols
#'   and their ASCII fall-backs depending on the environment they are called
#'   into. Can be controlled by the option `options(cli.unicode = T/F)` if set,
#'   otherwise the [l10n_info()]`$UTF-8` local information is used to detect
#'   UTF-8 support.
#'
#' `show_symbols()` is a convenient print output to list
#'   of various available UTF-8 (or ASCII) symbols to the screen.
#'
#' @name symbl
#'
#' @format A named list, see `names(symbl)`.
#' @usage symbl
#'
#' @export symbl
NULL

#' @rdname symbl
#' @examples
#' # available symbols
#' show_symbols()
#'
#' # ascii versions
#' withr::with_options(list(cli.unicode = FALSE, width = 80L), show_symbols())
#' @export
show_symbols <- function() {
  nms <- format(names(symbl))
  max_sym <- max(vapply(symbl, nchar, 1L))
  sym <- pad(symbl, max_sym + 2, "left")
  sym <- paste0(nms, sym)
  max <- max(nchar(sym, keepNA = FALSE)) + 1
  ncl <- max(1, getOption("width") %/% max)
  while ( length(sym) %% ncl ) sym <- c(sym, "") # add lengths until equal
  sym <- paste0(sym, "  ")
  m   <- matrix(sym, ncol = ncl)
  cat(paste0(apply(m, 1, paste0, collapse = ""), "\n"), sep = "")
}



# A list UTF-8/unicode symbols
symbol_utf8 <- list(
  # borrowed from cli:
  #   https://github.com/r-lib/clisymbols/blob/master/R/symbols.R
  "tick"                 = "\u2713",
  "cross"                = "\u2716",
  "star"                 = "\u2605",
  "square"               = "\u2587",
  "square_small"         = "\u25FB",
  "square_small_filled"  = "\u25FC",
  "circle"               = "\u25EF",
  "circle_filled"        = "\u25C9",
  "circle_dotted"        = "\u25CC",
  "circle_double"        = "\u25CE",
  "circle_circle"        = "\u24DE",
  "circle_cross"         = "\u24E7",
  "circle_pipe"          = "\u24be",
  "bullet"               = "\u2022",
  "dot"                  = "\u2024",
  "line"                 = "\u2500",
  "double_line"          = "\u2550",
  "ellipsis"             = "\u2026",
  "pointer"              = "\u276F",
  "info"                 = "\u2139",
  "warning"              = "\u26A0",
  "menu"                 = "\u2630",
  "smiley"               = "\u263A",
  "heart"                = "\u2665",
  "arrow_up"             = "\u2191",
  "arrow_down"           = "\u2193",
  "arrow_left"           = "\u2190",
  "arrow_right"          = "\u2192",
  "radio_on"             = "\u25C9",
  "radio_off"            = "\u25EF",
  "checkbox_on"          = "\u2612",
  "checkbox_off"         = "\u2610",
  "checkbox_circle_on"   = "\u24E7",
  "checkbox_circle_off"  = "\u24BE",
  "neq"                  = "\u2260",
  "geq"                  = "\u2265",
  "leq"                  = "\u2264",
  "times"                = "\u00d7",
  "pm"                   = "\U00B1",

  "upper_block_1"        = "\u2594",
  "upper_block_4"        = "\u2580",

  "lower_block_1"        = "\u2581",
  "lower_block_2"        = "\u2582",
  "lower_block_3"        = "\u2583",
  "lower_block_4"        = "\u2584",
  "lower_block_5"        = "\u2585",
  "lower_block_6"        = "\u2586",
  "lower_block_7"        = "\u2587",
  "lower_block_8"        = "\u2588",
  "full_block"           = "\u2588",

  "mustache"             = "\u0DF4",   # these 2 have spaces in the symbol
  "fancy_question_mark"  = "\u2753"
)

# ASCII fallbacks of UTF-8 symbols
symbol_ascii <- list(
  # borrowed from cli:
  #   https://github.com/r-lib/clisymbols/blob/master/R/symbols.R
  "tick"                 = "v",
  "cross"                = "x",
  "star"                 = "*",
  "square"               = "[ ]",
  "square_small"         = "[ ]",
  "square_small_filled"  = "[x]",
  "circle"               = "( )",
  "circle_filled"        = "(*)",
  "circle_dotted"        = "( )",
  "circle_double"        = "(o)",
  "circle_circle"        = "(o)",
  "circle_cross"         = "(x)",
  "circle_pipe"          = "(|)",
  "circle_question_mark" = "(?)",
  "bullet"               = "*",
  "dot"                  = ".",
  "line"                 = "-",
  "double_line"          = "=",
  "ellipsis"             = "...",
  "continue"             = "~",
  "pointer"              = ">",
  "info"                 = "i",
  "warning"              = "!",
  "menu"                 = "=",
  "smiley"               = ":)",
  "heart"                = "<3",
  "arrow_up"             = "^",
  "arrow_down"           = "v",
  "arrow_left"           = "<",
  "arrow_right"          = ">",
  "radio_on"             = "(*)",
  "radio_off"            = "( )",
  "checkbox_on"          = "[x]",
  "checkbox_off"         = "[ ]",
  "checkbox_circle_on"   = "(x)",
  "checkbox_circle_off"  = "( )",
  "neq"                  = "!=",
  "geq"                  = ">=",
  "leq"                  = "<=",
  "times"                = "x",
  "pm"                   = "+/-",

  "upper_block_1"        = "^",
  "upper_block_4"        = "^",

  "lower_block_1"        = ".",
  "lower_block_2"        = "_",
  "lower_block_3"        = "_",
  "lower_block_4"        = "=",
  "lower_block_5"        = "=",
  "lower_block_6"        = "*",
  "lower_block_7"        = "#",
  "lower_block_8"        = "#",

  "full_block"           = "#",

  "sup_0"                = "0",
  "sup_1"                = "1",
  "sup_2"                = "2",
  "sup_3"                = "3",
  "sup_4"                = "4",
  "sup_5"                = "5",
  "sup_6"                = "6",
  "sup_7"                = "7",
  "sup_8"                = "8",
  "sup_9"                = "9",

  "sup_minus"            = "-",
  "sup_plus"             = "+",

  "play"                 = ">",
  "stop"                 = "#",
  "record"               = "o",

  "figure_dash"          = "-",
  "en_dash"              = "--",
  "em_dash"              = "---",

  "dquote_left"          = "\"",
  "dquote_right"         = "\"",
  "squote_left"          = "'",
  "squote_right"         = "'",

  "mustache"             = "/\\/",
  "fancy_question_mark"  = "(?)"
)
