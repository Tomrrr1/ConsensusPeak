test_that("IDR peak file is created in the desired location", {
  temp_out_dir <- withr::local_tempdir()

  rep_treat_1 <- system.file("extdata",
                             "r1_creb_chr22.bam",
                             package = "ConsensusPeak")
  rep_treat_2 <- system.file("extdata",
                             "r2_creb_chr22.bam",
                             package = "ConsensusPeak")

  result <- conservative_idr(
    treat_files = c(rep_treat_1, rep_treat_2),
    out_dir = temp_out_dir,
    idr_stringent = TRUE,
    is_paired = FALSE,
    keep_original = FALSE,
    nomodel = TRUE
    )

  expect_true(file.exists(result[[2]]))
})

rep_treat_1 <- system.file("extdata",
                           "r1_creb_chr22.bam",
                           package = "ConsensusPeak")
rep_treat_2 <- system.file("extdata",
                           "r2_creb_chr22.bam",
                           package = "ConsensusPeak")

result <- conservative_idr(
  treat_files = c(rep_treat_1, rep_treat_2),
  out_dir = ".",
  idr_stringent = TRUE,
  is_paired = FALSE,
  keep_original = TRUE,
  nomodel = TRUE
)
