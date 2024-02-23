test_that("IDR peak file is created in the desired location", {
  rep_treat_1 <- testthat::test_path("testdata", "r1_test_creb.bam")
  rep_treat_2 <- testthat::test_path("testdata", "r2_test_creb.bam")

  result <- optimal_idr(
    treat_files = c(rep_treat_1, rep_treat_2),
    out_dir = withr::local_tempdir(),
    is_paired = FALSE,
    nomodel = TRUE
  )

  expect_true(file.exists(result[[2]]))
})
