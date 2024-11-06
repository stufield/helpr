# `colorize_paths()` returns the correct coloring

    Code
      colorize_paths("foo.txt")
    Output
      [1] "foo.txt"

---

    Code
      colorize_paths("foo.R")
    Output
      [1] "\033[32mfoo.R\033[0m"

---

    Code
      colorize_paths("foo.zip")
    Output
      [1] "\033[01;31mfoo.zip\033[0m"

---

    Code
      colorize_paths("foo.Rmd")
    Output
      [1] "\033[32mfoo.Rmd\033[0m"

---

    Code
      colorize_paths("foo.md")
    Output
      [1] "\033[32mfoo.md\033[0m"

---

    Code
      colorize_paths("foo.yml")
    Output
      [1] "\033[32mfoo.yml\033[0m"

---

    Code
      colorize_paths(".foo")
    Output
      [1] "\033[01;35m.foo\033[0m"

---

    Code
      colorize_paths("foo.sh")
    Output
      [1] "\033[01;31mfoo.sh\033[0m"

---

    Code
      colorize_paths("foo.py")
    Output
      [1] "\033[33mfoo.py\033[0m"

---

    Code
      colorize_paths("foo.json")
    Output
      [1] "\033[33mfoo.json\033[0m"

---

    Code
      colorize_paths("foo.jpeg")
    Output
      [1] "\033[01;34mfoo.jpeg\033[0m"

---

    Code
      colorize_paths("foo.png")
    Output
      [1] "\033[01;34mfoo.png\033[0m"

---

    Code
      colorize_paths("foo.adat")
    Output
      [1] "\033[01;31mfoo.adat\033[0m"

---

    Code
      colorize_paths("foo.tar.gz")
    Output
      [1] "\033[01;31mfoo.tar.gz\033[0m"

---

    Code
      colorize_paths("foo")
    Output
      [1] "\033[01;34mfoo\033[0m"

---

    Code
      colorize_paths("bar")
    Output
      [1] "\033[01;36mbar\033[0m"

# `format.helpr_bytes()` formats values > 1024 to group and colors

    Code
      format(as_helpr_bytes(1024))
    Output
      [1] "\033[01;34m1K\033[0m"

---

    Code
      format(as_helpr_bytes(1025))
    Output
      [1] "\033[01;34m1K\033[0m"

---

    Code
      format(as_helpr_bytes(1024 * 1024))
    Output
      [1] "\033[01;31m1M\033[0m"

---

    Code
      format(as_helpr_bytes(2^16))
    Output
      [1] "\033[01;34m64K\033[0m"

---

    Code
      format(as_helpr_bytes(2^24))
    Output
      [1] "\033[01;31m16M\033[0m"

---

    Code
      format(as_helpr_bytes(2^24 + 555555))
    Output
      [1] "\033[01;31m16.5M\033[0m"

---

    Code
      format(as_helpr_bytes(2^32))
    Output
      [1] "\033[01;35m4G\033[0m"

---

    Code
      format(as_helpr_bytes(2^48))
    Output
      [1] "\033[01;32m256T\033[0m"

---

    Code
      format(as_helpr_bytes(2^64))
    Output
      [1] "16E"

# `format.helpr_bytes()` is vectorized and colored

    Code
      format(as_helpr_bytes(x))
    Output
       [1] "   1B"                      "  10B"                     
       [3] " 100B"                      "1000B"                     
       [5] "\033[01;34m   9.77K\033[0m" "\033[01;34m  97.66K\033[0m"
       [7] "\033[01;34m 976.56K\033[0m" "\033[01;31m   9.54M\033[0m"
       [9] "\033[01;31m  95.37M\033[0m" "\033[01;31m 953.67M\033[0m"

# `helpr_bytes()` sum method is dispatched

    Code
      format(sum(as_helpr_bytes(x)))
    Output
      [1] "\033[01;35m1.03G\033[0m"

# `helpr_bytes()` max method is dispatched

    Code
      format(max(as_helpr_bytes(x)))
    Output
      [1] "\033[01;31m954M\033[0m"

# `[.as_helpr_bytes`

    Code
      format(x[5])
    Output
      [1] "\033[01;34m9.77K\033[0m"

---

    Code
      format(x[c(3, 6, 9)])
    Output
      [1] "100B"                     "\033[01;34m 97.7K\033[0m"
      [3] "\033[01;31m 95.4M\033[0m"

