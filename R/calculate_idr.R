#' Perform IDR thresholding
#'
#' `calculate_idr()` performs IDR thresholding on a pair of peak sets.
#' High-confidence peaks that pass the threshold are written to a ".narrowPeak"
#' file in the specified `out_dir`
#'
#' @importFrom idr2d estimate_idr1d
#' @importFrom utils write.table
#' @import GenomicRanges
#' @import IRanges
#' @import ChIPpeakAnno
#' @import rtracklayer
#'
#' @param peak_file_1 Path to the .narrowPeak file of biological replicate 1.
#' @param peak_file_2 Path to the .narrowPeak file of biological replicate 2.
#' @param stringent if `TRUE` threshold at 0.01. If `FALSE`, threshold at 0.05.
#' @param keep_original Should the original peaks from one of the replicates
#' be written to the output file or should the output peaks be the sum of the
#' ranges of the two replicates peaks. The default is `FALSE`.
#' @param out_dir Path to the directory where the high-confidence peaks are
#' written.
#'
#' @returns A summary of the peaks that passed the IDR threshold and the path
#' to the .narrowPeak file containing the peaks that passed this threshold.
#'
#' @export

calculate_idr <- function(peak_file_1,
                          peak_file_2,
                          stringent = TRUE,
                          keep_original = FALSE,
                          out_dir) {
  normalised_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  # Load the replicate peak files
  peak1 <- utils::read.table(peak_file_1, header = FALSE)
  peak2 <- utils::read.table(peak_file_2, header = FALSE)

  # Col 8 of the narrowPeak file contains -log10(p-value)
  peak1_df <- peak1[, c(1, 2, 3, 8)]
  peak2_df <- peak2[, c(1, 2, 3, 8)]

  idr_results <- estimate_idr1d(peak1_df, peak2_df,
                                value_transformation = "identity")

  n_thresholded_peaks <- ifelse(stringent,
                                unlist(summary(idr_results)[6]),
                                unlist(summary(idr_results)[5]))

  if (n_thresholded_peaks == 0) {
    messager("No peaks passed the threshold. No output generated.")
    return(NULL)
  }

  # Extract the top n peaks and write to .narrowPeak
  peak1_ordered <- peak1[order(peak1[, 9], decreasing = TRUE), ]
  top_peaks <- peak1_ordered[1:n_thresholded_peaks, ]

  # Define an output file name and path
  output_file_name <- ifelse(stringent,
                             "IDR_peaks_01.bed",
                             "IDR_peaks_05.bed")
  output_file_path <-
    file.path(normalised_out_dir, output_file_name)

  if(keep_original){ # If we do not want to merge peaks from the replicates.
    # Relevant when we want to preserve peak summits.
    utils::write.table(
      top_peaks,
      file = output_file_path,
      quote = FALSE,
      sep = "\t",
      row.names = FALSE,
      col.names = FALSE
    )
  } else { # Merge the ranges of the significant peaks across the replicates

    # Convert top_peaks and peak2 to GRanges objects
    gr1 <- GenomicRanges::GRanges(
      seqnames = top_peaks[,1],
      ranges = IRanges::IRanges(start = top_peaks[,2], end = top_peaks[,3]))

    gr2 <- GenomicRanges::GRanges(
      seqnames = peak2_df[,1],
      ranges = IRanges::IRanges(start = peak2_df[,2], end = peak2_df[,3]))

    suppressMessages({
    overlaps <-
      ChIPpeakAnno::findOverlapsOfPeaks(gr1, gr2, connectedPeaks = "merge")
    })
    result <- overlaps$peaklist$`gr1///gr2`
    names(result) <- paste0("peak_", seq_along(result))

    rtracklayer::export(result, con = output_file_path, format = "narrowPeak")
  }

  threshold <- if(stringent) 0.01 else 0.05
  messager("Peaks that passed IDR thresholding at", threshold,
           "have been written to", output_file_path)

  return(list(
    "IDR results" = summary(idr_results),
    "File location" = output_file_path
  ))
}
