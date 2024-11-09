#' Working with Strings
#'
#' Tools for working with character/text strings without
#'   importing the \pkg{stringr} package.
#'
#' Below is a convenient table of the \pkg{stringr} to base \pkg{R} equivalents:
#' \tabular{ll}{
#'   \pkg{stringr}                \tab base \pkg{R} \cr
#'   [stringr::str_c()]           \tab [paste()] \cr
#'   [stringr::str_count()]       \tab [gregexpr()] + `attr(x, "match.length")`] \cr
#'   [stringr::str_dup()]         \tab [strrep()] \cr
#'   [stringr::str_detect()]      \tab [grepl()] \cr
#'   [stringr::str_flatten()]     \tab `paste(..., collapse = "")` \cr
#'   [stringr::str_glue()]        \tab [sprintf()] \cr
#'   [stringr::str_length()]      \tab [nchar()] \cr
#'   [stringr::str_locate_all()]  \tab [regexpr()] \cr
#'   [stringr::str_match()]       \tab [match()] \cr
#'   [stringr::str_order()]       \tab [order()] \cr
#'   [stringr::str_remove()]      \tab `sub(..., replacement = "")` \cr
#'   [stringr::str_remove_all()]  \tab `gsub(..., replacement = "")` \cr
#'   [stringr::str_replace()]     \tab [sub()] \cr
#'   [stringr::str_replace_all()] \tab [gsub()] \cr
#'   [stringr::str_sort()]        \tab [sort()] \cr
#'   [stringr::str_split()]       \tab [strsplit()] \cr
#'   [stringr::str_sub()]         \tab [substr()], [substring()], [strtrim()] \cr
#'   [stringr::str_subset()]      \tab `grep(..., value = TRUE)` \cr
#'   [stringr::str_to_lower()]    \tab [tolower()] \cr
#'   [stringr::str_to_upper()]    \tab [toupper()] \cr
#'   [stringr::str_trim()]        \tab [trimws()] \cr
#'   [stringr::str_which()]       \tab [grep()] \cr
#'   [stringr::str_wrap()]        \tab [strwrap()]
#' }
#' And those found only in \pkg{helpr}:
#' \tabular{ll}{
#'   \pkg{stringr}            \tab \pkg{helpr} \cr
#'   [stringr::str_extract()] \tab [capture()], `gsub(..., replacement = "\\1")` \cr
#'   [stringr::str_squish()]  \tab [squish()] \cr
#'   [stringr::str_pad()]     \tab [pad()] or [sprintf()] \cr
#'   [stringr::str_trim()]    \tab [trim()]
#' }
#'
#' @name strings
#'
#' @param x A character vector.
#' @param width `integer(1)`. The minimum width of padding for each element.
#' @param side `character(1)`. Pad to the left or right.
#' @param text A character vector where matches are sought.
#' @param pattern `character(1)`. A string *containing a group capture* regex.
#' @seealso [encodeString()], [trimws()], [regexpr()], [substring()]
NULL


#' @describeIn strings Similar to `stringr::str_pad()` but does
#'   uses *only* a blank space as the padding character.
#'
#' @examples
#' pad("tidyverse", 20)
#' pad("tidyverse", 20, "left")
#' pad("tidyverse", 20, "both")
#'
#' @export
pad <- function(x, width, side = c("right", "left", "both")) {
  side <- match.arg(side)
  just <- switch(side, right = "left", left = "right", both = "centre")
  encodeString(x, width = width, justify = just)
}

#' @describeIn strings The inverse of [pad()], removes whitespace on both
#'   sides *and* replicated internal whitespace.
#'   Similar to `stringr::str_squish()`.
#'
#' @examples
#' squish("  abcd   efgh   ")
#' squish("  abcd   efgh   .")
#'
#' @export
squish <- function(x) {
  # zap leading/trailing whitespace & extra internal whitespace
  gsub("[[:space:]]+", " ", trim(x))
}

#' @describeIn strings
#'   A wrapper around [trimws()] but with unified
#'   argument names.
#'
#' @param whitespace A string specifying a regular expression to
#'   match (one character of) "white space".
#'
#' @examples
#' trim("  abcd   efgh   ")
#' trim("  abcd   efgh   .")
#'
#' @export
trim <- function(x, side = c("both", "left", "right"), whitespace = "[ \t\r\n]") {
  side <- match.arg(side)
  trimws(x, side, whitespace)
}

#' Capture Regular Expression from String
#'
#' @describeIn strings
#'   Uses "group capture" regular expression from the `pattern` argument to
#'   extract matches from character string(s).
#'   Analogous to [stringr::str_extract()].
#'
#' @examples
#' # extract the group 'oo'
#' capture(c("foo", "bar", "boo", "oops"), "(oo)")
#'
#' # capture multiple groups
#' capture(c("foo", "bar", "boo", "oops-e-doo"), "(.*)(oo)")
#' @export
capture <- function(text, pattern) {
  stopifnot(is.character(text))
  regex <- regexpr(pattern, text, perl = TRUE)
  if ( !"capture.start" %in% names(attributes(regex)) ) {
    stop("Bad pattern argument! Must contain a group capture regex.",
         call. = FALSE)
  }
  start <- attr(regex, "capture.start")
  len <- attr(regex, "capture.length") - 1L
  strings <- substring(text, start, start + len) # nolint: undesirable_linter.
  ret <- data.frame(matrix(strings, ncol = ncol(start)), stringsAsFactors = FALSE)
  nms <- attr(regex, "capture.names")
  names(ret) <- ifelse(nms == "", seq_along(nms), nms)
  ret[is.na(regex) | regex == -1, ] <- NA_character_
  ret
}
