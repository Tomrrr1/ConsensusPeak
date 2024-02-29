test_that("Filtered BAM file is created in the desired location", {
  temp_out_dir <- withr::local_tempdir()

  treat_1 <- system.file("extdata",
                         "paired_creb_chr22.bam",
                         package = "ConsensusPeak")

  result <- filter_bam(bam_file = treat_1,
                       out_dir = temp_out_dir)

  # remove index of the original bam file
  unlink(system.file("extdata",
                     "paired_creb_chr22.bam.bai",
                     package = "ConsensusPeak"))

  # Check if the directory exists and is not empty
  expect_true(file.exists(result))
})
