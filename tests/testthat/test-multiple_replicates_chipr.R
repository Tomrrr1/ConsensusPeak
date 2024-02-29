test_that("ChIP-R analysis writes files to desired output directory", {
  temp_out_dir <- withr::local_tempdir()

  rep_treat_1 <- system.file("extdata",
                             "r1_creb_chr22.bam",
                             package = "ConsensusPeak")
  rep_treat_2 <- system.file("extdata",
                             "r2_creb_chr22.bam",
                             package = "ConsensusPeak")
  rep_treat_3 <- system.file("extdata",
                             "r3_creb_chr22.bam",
                             package = "ConsensusPeak")

  result <- multiple_replicates_chipr(
    treat_files = c(rep_treat_1, rep_treat_2, rep_treat_3),
    control_files = NULL,
    is_paired = FALSE,
    out_dir = temp_out_dir,
    nomodel = TRUE
  )

  # Check if the directory exists and is not empty
  expect_true(dir.exists(result[[2]]) && length(list.files(result[[2]])) > 0)
})




