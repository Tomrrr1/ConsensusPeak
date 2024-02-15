#' Call consensus peaks from histone data
#'
#' \code{histone()} accepts multiple biological replicates and calls consensus
#' peaks. Use the findOverlapsOfPeaks() function from the ChIPpeakAnno package
#'

histone <- function(treat_files,
                    control_files = NULL,
                    out_dir,
                    subdir_name = "histone_replicate_analysis",
                    paired_end = FALSE,
                    ...){
  final_out_dir <- create_or_use_dir(out_dir, subdir_name)

  named_list <-
    prepare_named_list(
      treat_files = treat_files,
      control_files = control_files
    )





  result <- ChIPpeakAnno::findOverlapsOfPeaks()

}




# peak1 <-
#   ChIPpeakAnno::toGRanges("./read1_SK061_3-SK062_3-SK067_3_R1_peaks.broadPeak",
#                           format = "broadPeak")
# peak2 <-
#   ChIPpeakAnno::toGRanges("./read1_SK061_3-SK062_3-SK067_3_R2_peaks.broadPeak",
#                           format = "broadPeak")
# peak3 <-
#   ChIPpeakAnno::toGRanges("./read1_SK061_3-SK062_3-SK067_3_R3_peaks.broadPeak",
#                           format = "broadPeak")
#
# results <-
#   ChIPpeakAnno::findOverlapsOfPeaks(peak1, peak2, peak3,
#                                     minoverlap = 0.5,
#                                     connectedPeaks = "merge")
#
# ## add metadata (mean of score) to the overlapping peaks
# results <- ChIPpeakAnno::addMetadata(results, colNames="score", FUN=mean)
# results$peaklist[["peak1///peak2///peak3"]]
#
# ChIPpeakAnno::makeVennDiagram(results)
