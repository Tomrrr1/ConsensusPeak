test_that("High-confidence peak file is generated", {
  temp_out_dir <- withr::local_tempdir()

  peak_file_1 <- testthat::test_path("testdata",
                                    "r1_test_creb_peaks.narrowPeak")
  peak_file_2 <- testthat::test_path("testdata",
                                    "r2_test_creb_peaks.narrowPeak")

  result <- calculate_idr(peak_file_1 = peak_file_1,
                          peak_file_2 = peak_file_2,
                          stringent = TRUE,
                          out_dir = temp_out_dir)

  expect_true(file.exists(result[[2]]))

})
