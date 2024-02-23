#' Generate a featureCounts matrix for a set of peaks
#'
#' \code{feature_counts_matrix()} computes the number of reads from a BAM file
#' that fall within the ranges of a peak within a set.
#'

feature_counts_matrix <- function(peak_file,
                                  treat_files) {
  # Read the peak file and subset desired columns
  peak <-
    utils::read.table(peak_file, header = FALSE)
  peak_df <- peak[, c(4, 1, 2, 3, 6)]

  # Set column names for SAF format
  colnames(peak_df) <- c("GeneID", "Chr", "Start", "End", "Strand")

  # Create a temporary SAF file
  temp_saf_file <- withr::local_tempfile(fileext = ".saf")
  withr::defer(unlink(temp_saf_file)) # delete tempfile when function exits
  write.table(peak_df,
              temp_saf_file,
              quote = FALSE,
              sep = "\t",
              row.names = FALSE,
              col.names = TRUE)

  # Paired-end bam files that were filtered for read 1 will still contain
  # paired-end flags. We can use testPairedEndBam() to set isPairedEnd.
  count_matrix <-
    Rsubread::featureCounts(
      files = treat_files,
      annot.ext = temp_saf_file,
      isPairedEnd = Rsamtools::testPairedEndBam(treat_files[1]))

  # Return the counts
  return(count_matrix)
}
