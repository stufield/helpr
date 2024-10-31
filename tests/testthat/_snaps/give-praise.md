# `give_praise()` generates expected output

    Code
      withr::with_seed(1, give_praise())
    Output
      [31mAhhh! You are Gnarly![39m

---

    Code
      withr::with_seed(2, give_praise())
    Output
      [31mMm! You are Smashing![39m

# color is turned off in knitr/rmarkdown

    Code
      withr::with_seed(4, give_praise())
    Output
      Hah! You are Laudable!

---

    Code
      withr::with_seed(8, give_praise())
    Output
      Wowie! You are Legendary!

