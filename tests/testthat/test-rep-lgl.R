test_that("rep_lgl() correctly identifies identical values for all classes", {
  # Testing the documented examples
  expect_false(rep_lgl(1:4))
  expect_true(rep_lgl(rep(5, 10)))
  expect_true(rep_lgl(rep("A", 10)))
  expect_false(rep_lgl(letters))
  expect_true(rep_lgl(c(TRUE, TRUE, TRUE)))
  expect_false(rep_lgl(c(TRUE, TRUE, FALSE)))

  # Testing additional data classes
  fac <- factor(c(rep("A", 10), rep("B", 5), rep("C", 30)))
  expect_false(rep_lgl(fac))
  expect_true(rep_lgl(factor(rep("A", 20))))

  expect_equal(rep_lgl(c(TRUE, TRUE)), rep_lgl(c(1, 1)))
  expect_equal(rep_lgl(c(FALSE, FALSE)), rep_lgl(c(0, 0)))
  expect_equal(rep_lgl(c(FALSE, TRUE)), rep_lgl(c(0, 1)))
  expect_equal(rep_lgl(c(TRUE, FALSE)), rep_lgl(c(1, 0)))
  expect_false(rep_lgl(c(NA, NA, "A", "A"))) # Will distinguish characters & NA values
  expect_true(rep_lgl(c(NA, NA, 1.9, 1.9))) # Does not distinguish for doubles
})
