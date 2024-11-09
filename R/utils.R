
# determine of RStudio is using a dark theme
# RStudio must be available; otherwise FALSE
is_dark_theme <- function() {
  identical(.Platform$GUI, "RStudio") && .rs.readUserState("theme")$isDark
}

add_seq <- function(x) {
  stopifnot(inherits(x, "character"))
  x <- vapply(strsplit(x, "_", fixed = TRUE), `[[`, i = 1L, "")
  paste0("seq.", sub("-", ".", x))
}

is_seq <- function(x) {
  grepl("[0-9]{4,5}[-.][0-9]{1,3}([._][0-9]{1,3})?$", x)
}

get_analytes <- function(x) {
  if ( inherits(x, "data.frame") ) {
    x <- names(x)
  }
  x[is_seq(x)]
}

get_meta <- function(x) {
  if ( inherits(x, "data.frame") ) {
    x <- names(x)
  }
  setdiff(x, get_analytes(x))
}

is_soma_adat <- function(x) {
  inherits(x, "soma_adat")
}
