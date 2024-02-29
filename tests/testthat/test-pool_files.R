test_that("Correct number of output files when no control has been passed", {
  temp_out_dir <- withr::local_tempdir()

  test_list <- list("treatment_file_1" = system.file("extdata",
                                                     "r1_creb_chr22.bam",
                                                     package = "ConsensusPeak"),
                    "treatment_file_2" = system.file("extdata",
                                                     "r2_creb_chr22.bam",
                                                     package = "ConsensusPeak"),
                    "control_file_1" = system.file("extdata",
                                                   "r1_creb_chr22.bam",
                                                   package = "ConsensusPeak"),
                    "control_file_2" = system.file("extdata",
                                                   "r2_creb_chr22.bam",
                                                   package = "ConsensusPeak"))

  result <- pool_files(test_list, out_dir = temp_out_dir)

  merged_treatment_file_path <- file.path(temp_out_dir, "merged_treatment.bam")
  merged_control_file_path <- file.path(temp_out_dir, "merged_control.bam")

  # Check that the merged BAM files have been created at the desired location
  expect_true(file.exists(merged_treatment_file_path))
  expect_true(file.exists(merged_control_file_path))

  # Check that the merged BAM files have non-zero size
  expect_true(file.info(merged_treatment_file_path)$size > 0)
  expect_true(file.info(merged_control_file_path)$size > 0)
})

