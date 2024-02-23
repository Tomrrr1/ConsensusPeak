#' Call consensus peaks based on overlap across replicates
#'
#' \code{overlap analysis()} calls consensus peaks by taking overlapping peak
#' calls across replicates. The sensitivity can be altered by varying the
#' \code{minoverlap} parameter.
#'
#' @inheritParams idr_analysis
#' @inheritParams ChIPpeakAnno::findOverlapsOfPeaks
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#' @returns A list containing the path to the output consensus peak file and a
#' Venn diagram illustrating overlap across replicates.
#'
#' @examples
#' \dontrun{
#' input1 <- testthat::test_path("testdata", "r1_test_creb.bam")
#' input2 <- testthat::test_path("testdata", "r2_test_creb.bam")
#' input3 <- testthat::test_path("testdata", "r3_test_creb.bam")
#'
#' results <- overlap_analysis(
#'   treat_files = c(input1, input2, input3),
#'   control_files = NULL,
#'   is_paired = FALSE,
#'   maxgap = 0L,
#'   minoverlap = 0.5,
#'   connectedPeaks = "merge",
#'   out_dir = tempdir(),
#'   subdir_name = "overlap_analysis"
#'   nomodel = TRUE,
#'   qvalue = 0.01
#'   )
#'   }
#'
#' @export
overlap_analysis <- function(treat_files,
                             control_files = NULL,
                             is_paired,
                             maxgap = 0L,
                             minoverlap = 0.5,
                             connectedPeaks = "merge",
                             out_dir,
                             subdir_name = "overlap_analysis",
                             ...){
  final_out_dir <- create_or_use_dir(out_dir, subdir_name)
  peak_list <-
    prepare_and_call(
      treat_files = treat_files,
      control_files = control_files,
      is_paired = is_paired,
      out_dir = final_out_dir,
      ...
    ) # Outputs a named list of peak files

  # Initialise a list to store granges objects
  granges_list <- list()
  suffix <- sub(".*\\.", "", basename(peak_list[[1]]))
  for(i in seq_len(length(peak_list))){
    granges_list[[i]] <-
      ChIPpeakAnno::toGRanges(
        peak_list[[i]],
        format = suffix # "narrowPeak" or "broadPeak"
      )
    # Add names to each element
    names(granges_list)[i] <- paste0("peak", i)
  }

  result <- ChIPpeakAnno::findOverlapsOfPeaks(granges_list,
                                              minoverlap = minoverlap,
                                              connectedPeaks = "merge")

  result <- ChIPpeakAnno::addMetadata(result, colNames="score", FUN=mean)

  # Make Venn diagram and write to a file
  plot_file_path <- file.path(final_out_dir, "venn_diagram.pdf")
  tmp <- withr::tempfile()
  withr::defer(unlink(tmp))
  sink(tmp) # divert output of makeVennDiagram() to tempfile
  pdf(plot_file_path)
  ChIPpeakAnno::makeVennDiagram(result)
  dev.off()
  sink(0)

  # Write the consensus peaks to a file
  out_file <- file.path(final_out_dir, paste0("consensus_peaks.", suffix))

  # Subset the consensus peaks that are found in ALL replicates. This entry
  # will have the longest name
  result <- result$peaklist[[which.max(nchar(names(result$peaklist)))]]
  rtracklayer::export(result, con = out_file, format = suffix)

  return(list("Output file path" = out_file))
}
