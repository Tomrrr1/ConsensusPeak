#' Perform IDR thresholding
#'
#' `calculated_idr()` performs IDR thresholding on a pair of peak sets.
#' High-confidence peaks that pass the threshold are written to a ".narrowPeak"
#' file in the specified `out_dir`
#'
#' @importFrom idr2d estimate_idr1d
#'
#' @param peak_file_1 Path to the .narrowPeak file of biological replicate 1
#' @param peak_file_2 Path to the .narrowPeak file of biological replicate 2
#' @param stringent if `TRUE` threshold at 0.01. If `FALSE`, threshold at 0.05.
#' @param out_dir Path to the directory where the high-confidence peaks are
#' written
#'
#' @returns A summary of the peaks that passed the IDR threshold and the path
#' to the .narrowPeak file containing the peaks that passed this threshold.
#'
#' @export

calculate_idr <- function(peak_file_1,
                          peak_file_2,
                          stringent = TRUE,
                          out_dir
                          ) {
  normalised_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  # Load the replicate peak files
  peak1 <- utils::read.table(peak_file_1, header = FALSE)
  peak2 <- utils::read.table(peak_file_2, header = FALSE)

  peak1_df <- peak1[, c(1, 2, 3, 9)]
  peak2_df <- peak2[, c(1, 2, 3, 9)]

  idr_results <- estimate_idr1d(peak1_df, peak2_df,
                                value_transformation = "identity")

  n_thresholded_peaks <- ifelse(stringent,
                                unlist(summary(idr_results)[6]),
                                unlist(summary(idr_results)[5]))

  if (n_thresholded_peaks == 0) {
    return("No peaks passed the threshold. No output generated.")
  }

  # Extract the top n peaks and write to .narrowPeak
  peak1_ordered <- peak1[order(peak1[, 9], decreasing = TRUE),]
  top_peaks <- peak1_ordered[1:n_thresholded_peaks,]

  output_file_name <- ifelse(stringent,
                             "IDR_peaks_01.narrowPeak",
                             "IDR_peaks_05.narrowPeak")
  output_file_path <-
    file.path(normalised_out_dir, output_file_name)

  utils::write.table(
    top_peaks,
    file = output_file_path,
    quote = FALSE,
    sep = "\t",
    row.names = FALSE,
    col.names = FALSE
  )

  return(list(
    "IDR results" = summary(idr_results),
    "Path to output file" =  output_file_path)
  )
}

