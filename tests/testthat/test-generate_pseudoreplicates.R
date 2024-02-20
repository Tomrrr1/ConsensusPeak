test_that("Pseudoreplicate BAM files are created and they are not identical", {
  # testthat automatically deletes local_tempdir()
  temp_output_dir <- withr::local_tempdir()
  #withr::defer(unlink(temp_output_dir, recursive = TRUE))

  # Use normalized path for the pooled BAM
  pooled_bam <- testthat::test_path("testdata", "merged_treatment.bam")

  # Call the function with the temporary output directory
  result <- generate_pseudoreplicates(
    bam_file = pooled_bam,
    out_dir = temp_output_dir,
    is_paired = TRUE,
    is_control = FALSE
  )

  # Check if the files are created at the desired location
  expect_true(file.exists(result$pseudoreplicate1))
  expect_true(file.exists(result$pseudoreplicate2))

  # Check if the pseudoreplicates are different
  md5_1 <- tools::md5sum(result$pseudoreplicate1)
  md5_2 <- tools::md5sum(result$pseudoreplicate2)
  expect_false(identical(md5_1, md5_2))

})
