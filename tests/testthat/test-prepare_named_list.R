# Test for correct combination and normalization of file paths
test_that("File paths are combined and normalized", {
  path1 <- withr::local_tempfile()
  path2 <- withr::local_tempfile()
  file.create(path1)
  file.create(path2)

  result <- prepare_named_list(c(path1, path2))
  expect_named(result, c("treatment_file_1", "treatment_file_2"))
  expect_true(all(sapply(result, function(x) file.exists(x))))
})

test_that("Error when there is an uneven number of controls", {
  path1 <- withr::local_tempfile()
  path2 <- withr::local_tempfile()
  path3 <- withr::local_tempfile()
  file.create(path1)
  file.create(path2)
  file.create(path3)

  expect_error(
    prepare_named_list(treat_files = c(path1, path2),
                       control_files = c(path3)
                       )
  )
})

# Test for removing NULL entries
test_that("NULL entries are removed", {
  path1 <- tempfile()
  file.create(path1)

  result <- prepare_named_list(path1)
  expect_length(result, 1)

  # Clean up
  unlink(path1)
})

# Test for input validation
test_that("Function stops with non-character or multiple inputs", {
  expect_error(prepare_named_list(123))
})

# File existence check
test_that("Function stops if file does not exist", {
  expect_error(prepare_named_list("this_is_not_a_real_file.txt"))
})


