# `signal_*()` produces expected messages

    Code
      signal_done("Test done")
    Message
      v Test done
    Code
      signal_todo("Test todo")
    Message
      * Test todo
    Code
      signal_info("Test info")
    Message
      i Test info
    Code
      signal_oops("Test oops")
    Message
      x Test oops
    Code
      signal_rule("Test single rule")
    Output
      -- Test single rule ------------------------------------------------------------
    Code
      signal_rule("Test double rule", lty = "double")
    Output
      == Test double rule ============================================================

# the colors work correctly via `add_color()`

    [1] "\033[31mstring\033[39m"

---

    [1] "\033[31mstring space\033[39m"

# the font styles work correctly via `add_style()`

    Code
      add_style$bold("foo")
    Output
      [1] "\033[1mfoo\033[22m"

---

    Code
      add_style$italic("foo")
    Output
      [1] "\033[3mfoo\033[23m"

---

    Code
      add_style$underline("foo")
    Output
      [1] "\033[4mfoo\033[24m"

---

    Code
      add_style$inverse("foo")
    Output
      [1] "\033[7mfoo\033[27m"

---

    Code
      add_style$strikethrough("foo")
    Output
      [1] "\033[9mfoo\033[29m"

# the colors work correctly via `add_style()`

    Code
      add_style$blue("string")
    Output
      [1] "\033[34mstring\033[39m"

---

    Code
      add_style$blue("string space")
    Output
      [1] "\033[34mstring space\033[39m"

# combining colors works correctly

    Code
      add_style$bold(a)
    Output
      [1] "\033[1m\033[31mred\033[39m\033[22m"

# the colors with `signal_*()` functions works correctly

    Code
      signal_oops("You shall", add_style$red("not"), "pass!")
    Message
      [31mx[39m You shall [31mnot[39m pass!

# style chains properly handled by the `$` dispatch

    Code
      add_style$bold("Success")
    Output
      [1] "\033[1mSuccess\033[22m"

---

    Code
      add_style$bold$green("Success")
    Output
      [1] "\033[1m\033[32mSuccess\033[39m\033[22m"

---

    Code
      add_style$bold$green$italic("Success")
    Output
      [1] "\033[1m\033[32m\033[3mSuccess\033[23m\033[39m\033[22m"

---

    Code
      add_style$bold$green$italic$red("Success")
    Output
      [1] "\033[1m\033[32m\033[3m\033[31mSuccess\033[32m\033[23m\033[39m\033[22m"

