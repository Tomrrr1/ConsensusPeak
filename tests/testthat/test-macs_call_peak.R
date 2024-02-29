test_that("Error if output directory does not exist", {
  peak_file <- system.file("extdata",
                           "r1_creb_chr22.bam",
                           package = "ConsensusPeak")

  expect_error(macs_call_peak(tfile = peak_file,
                              out_name = "r1_test",
                              out_dir = "/this_is_not_a_real_directory"))

})
