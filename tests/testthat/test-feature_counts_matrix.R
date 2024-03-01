test_that("Filtered BAM file is created in the desired location", {
  treat_1 <- system.file("extdata",
                         "r1_creb_chr22.bam",
                         package = "ConsensusPeak")
  treat_2 <- system.file("extdata",
                         "r2_creb_chr22.bam",
                         package = "ConsensusPeak")
  peak <- system.file("extdata",
                      "out_peaks.narrowPeak",
                      package = "ConsensusPeak")

  result <- feature_counts_matrix(peak_file = peak,
                                  bam_files = c(treat_1, treat_2)
                                  )

  # Check if the feature counts matrix is created
  expect_true(is.matrix(result$counts))
})
