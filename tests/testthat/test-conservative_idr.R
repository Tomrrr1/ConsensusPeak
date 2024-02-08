test_that("IDR analysis finishes and produces summary report", {
  rep_treat_1 <- testthat::test_path("testdata", "r1_test.bam")
  rep_treat_2 <- testthat::test_path("testdata", "r2_test.bam")

  result <- ConsensusPeak::conservative_idr(
    rep_treat_1 = rep_treat_1,
    rep_treat_2 = rep_treat_2,
    out_dir = ".",
    nomodel=TRUE
    )

  expect_true(is.list(result))

})


rep_treat_1 <- testthat::test_path("testdata", "r1_test.bam")
rep_treat_2 <- testthat::test_path("testdata", "r2_test.bam")

result <- ConsensusPeak::conservative_idr(
  rep_treat_1 = rep_treat_1,
  rep_treat_2 = rep_treat_2,
  out_dir = ".",
  nomodel=TRUE
)
is.list(result)

result


