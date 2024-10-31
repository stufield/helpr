# `write_text()` writes correct text out to file

    Code
      write_text(path = "content.txt", lines = content)
    Message
      v Writing 'content.txt'

# `write_text()` creates file when it isn't already present

    Code
      write_text(path = "out.txt", lines = content)
    Message
      v Writing 'out.txt'

# `write_text()` does not overwrite when 'overwrite' != TRUE

    Code
      write_text(path = "out.txt", lines = content, overwrite = FALSE)
    Message
      x 'out.txt' already exists. Leaving as is.

# `write_text()` overwrites pre-existing files when asked to

    Code
      write_text(path = "out.txt", lines = to_overwrite, overwrite = TRUE)
    Message
      v Writing 'out.txt'

