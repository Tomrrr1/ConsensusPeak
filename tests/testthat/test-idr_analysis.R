test_that("Optimal and conservative IDR peak files are generated", {
  temp_out_dir <- withr::local_tempdir()

  input1 <- system.file("extdata",
                             "r1_creb_chr22.bam",
                             package = "ConsensusPeak")
  input2 <- system.file("extdata",
                             "r2_creb_chr22.bam",
                             package = "ConsensusPeak")

  result <- idr_analysis(treat_files = c(input1, input2),
                         control_files = NULL,
                         type = "all",
                         is_paired = FALSE,
                         out_dir = temp_out_dir,
                         nomodel = TRUE
                         )

  expect_true(file.exists(result$conservative[[2]])) # output path is at [[2]]
  expect_true(file.exists(result$optimal[[2]]))
})
