test_that("IDR analysis finishes and produces summary report", {
  rep_treat_1 <- testthat::test_path("testdata", "r1_test.bam")
  rep_treat_2 <- testthat::test_path("testdata", "r2_test.bam")

  result <- conservative_idr(
    treat_files = c(rep_treat_1, rep_treat_2),
    out_dir = ".",
    nomodel=TRUE
    )

  expect_true(is.list(result))

})
