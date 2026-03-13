# Signal Feedback to the Console UI

Similar to `usethis::ui_*()` function suite but does not require
importing the usethis, crayon, or cli packages. All `signal_*()`
functions can be silenced by setting `options(signal.quiet = TRUE)`.

## Usage

``` r
value(x)

signal_done(...)

signal_todo(...)

signal_oops(...)

signal_info(...)

signal_rule(text = "", line_col = NULL, lty = c("single", "double"))

add_color(x, col)

add_style

# S3 method for class 'helpr_style'
print(x, ...)

# S3 method for class 'helpr_style'
x$y

has_style(x)

rm_style(x)
```

## Arguments

- x:

  Character. A string to report to the UI or to add a style/color.

- ...:

  Elements passed directly to
  [`cat()`](https://rdrr.io/r/base/cat.html).

- text:

  `character(1)`. String added at the left margin of the horizontal
  rule.

- line_col:

  See `col`.

- lty:

  `character(1)`. Line type either "single" or "double" (matched).

- col:

  `character(1)`. Color (or style) for the text (or line). Currently one
  of:

  - `red`

  - `green`

  - `yellow`

  - `blue`

  - `magenta`

  - `cyan`

  - `black`

  - `white`

  - `grey`

  - `bold`

  - `italic`

  - `underline`

  - `inverse`

  - `strikethrough`

- y:

  A coloring function, i.e. an element the `add_style` object, see the
  `col` argument.

## Functions

- `value()`: Signal a value to the UI. Similar to `usethis::ui_value()`.
  Each element of `x` becomes an entry in a comma separated list and a
  `blue` color is added.

- `signal_done()`: Signal a completed task to the UI. Similar to
  `usethis::ui_done()`.

- `signal_todo()`: Signal a to-do task to the UI. Similar to
  `usethis::ui_todo()`.

- `signal_oops()`: Signal oops error to the UI. Similar to
  `usethis::ui_oops()`.

- `signal_info()`: Signal info to the UI. Similar to
  `usethis::ui_info()`.

- `signal_rule()`: Make a rule with left aligned text. Similar to
  [`cli::rule()`](https://cli.r-lib.org/reference/rule.html).

- `add_color()`: Add a color or style to a string. Similar to
  [`crayon::crayon()`](http://r-lib.github.io/crayon/reference/crayon.md).

- `add_style`: An alternative syntax. A list object where each element
  is a color/style function wrapping around `add_color()` and each
  element determines the `col` argument. See examples.

- `print(helpr_style)`: Functions in the `apply_style` object have their
  own class, which allows for the special S3 print method and the
  chaining in the examples below.

- `$`: Easily chain styles with `$` S3 method.

- `has_style()`: Logical testing if string contains ANSI styles/colors.

- `rm_style()`: Remove a color or style from character strings.

## Examples

``` r
n <- 4
cat("You need this many bikes:", value(n + 1))
#> You need this many bikes: 5

# value() collapses lengths by sep = ", "
value(names(mtcars))
#> 'mpg', 'cyl', 'disp', 'hp', 'drat', 'wt', 'qsec', 'vs', 'am', 'gear', 'carb'

# signal_done()
signal_done("Tests have passed!")
#> ✓ Tests have passed!

# easily construct complex messages
signal_done("The 'LETTERS' vector has", value(length(LETTERS)), "elements")
#> ✓ The 'LETTERS' vector has 26 elements

# add a horizontal rule
signal_rule()
#> ───────────────────────────────────────────────────────────────────────

signal_rule("Header", line_col = "green", lty = "double")
#> ══ Header ═════════════════════════════════════════════════════════════

cat(add_color("Hello world!", "blue"))
#> Hello world!

# Combined with signal_*() functions
signal_oops("You shall", add_color("not", "red"), "pass!")
#> ✖ You shall not pass!

# colors and styles available via add_style()
add_style
#> $red
#> megaverse styling function, red: example output.
#> 
#> $green
#> megaverse styling function, green: example output.
#> 
#> $yellow
#> megaverse styling function, yellow: example output.
#> 
#> $blue
#> megaverse styling function, blue: example output.
#> 
#> $magenta
#> megaverse styling function, magenta: example output.
#> 
#> $cyan
#> megaverse styling function, cyan: example output.
#> 
#> $black
#> megaverse styling function, black: example output.
#> 
#> $white
#> megaverse styling function, white: example output.
#> 
#> $grey
#> megaverse styling function, grey: example output.
#> 
#> $bold
#> megaverse styling function, bold: example output.
#> 
#> $italic
#> megaverse styling function, italic: example output.
#> 
#> $underline
#> megaverse styling function, underline: example output.
#> 
#> $inverse
#> megaverse styling function, inverse: example output.
#> 
#> $strikethrough
#> megaverse styling function, strikethrough: example output.
#> 

# These are equivalent
cat(add_style$blue("Hello world!"))
#> Hello world!
cat(add_color("Hello world!", "blue"))
#> Hello world!

# Combine
red <- add_style$red("This is red")
string <- c(red, "and this is not")
cat(string)
#> This is red and this is not

# Combine colors
blue <- add_style$blue("blue")
red  <- add_style$red("red")
string <- add_style$bold(c(blue, red, "nothing"))
cat(string)
#> blue red nothing

# chain styles via `$`
cat(add_style$bold("Success"))
#> Success
cat(add_style$bold$green("Success"))
#> Success
cat(add_style$bold$green$italic("Success"))
#> Success
cat(add_style$bold$green$italic$red("Success"))
#> Success

# potential typos are trapped
if (FALSE) { # \dontrun{
cat(add_style$bold$greeen$italic("Success"))
} # }

# check for ANSI styling
has_style(add_style$green("Hello world!"))
#> [1] TRUE
has_style(add_style$italic("Hello world!"))
#> [1] TRUE

# remove ANSI styling
cat(rm_style(add_style$green("Hello world!")))
#> Hello world!
cat(rm_style(add_style$italic$cyan("Hello world!")))
#> Hello world!
```
