test_that("Error if output directory does not exist", {
  peak_file <- testthat::test_path("testdata",
                                   "r1_test.bam")

  expect_error(macs_call_peak(tfile = peak_file,
                              out_name = "r1_test",
                              out_dir = "/this_is_not_a_real_directory"))

})
