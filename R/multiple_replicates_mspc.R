#' Run Multiple Sample Peak Calling (MSPC)
#'
#' \code{multiple_replicates_mspc()} is a wrapper of the \link{rmspc}{mspc()}
#' function. The protocol handles an arbitrary number of replicates, but is not
#' recommended for the simple case of n = 2, where we suggest using
#' \code{conservative_idr()} or \code{optimal_idr()}.
#'
#' @inheritParams conservative_idr
#' @param ... Additional parameters to be passed to \code{macs_call_peak} and
#' \code{mspc()}.
#'
#' @returns A list containing a summary of the MSPC along with the path to the
#' output files.
multiple_replicates_mspc <- function(treat_files,
                                     control_files = NULL,
                                     out_dir,
                                     subdir_name = "mspc_analysis",
                                     rep_type,
                                     stringency_threshold,
                                     weak_threshold,
                                     c,
                                     alpha,
                                     ...) {

  messager(
  "Note that multiple replicate analysis with mspc() requires .NET 6.0 (or
  higher) to be installed on your system. You can check if .NET is installed by
  running the command `dotnet --info` from the terminal. If .NET is not
  installed, or if your version is unsuitable, please follow the installation
  instructions here https://dotnet.microsoft.com/en-us/download/dotnet/6.0."
  )

  final_out_dir <- create_or_use_dir(out_dir, subdir_name)
  peak_list <-
    prepare_and_call(
      treat_files = treat_files,
      control_files = control_files,
      out_dir = final_out_dir,
      ... # params to be passed to MACS3
    )

  peak_files <- unlist(peak_list)
  # Initialise a vector to store output file paths
  peak_file_paths <- c()
  # Write this into function
  for(i in seq_along(peak_files)) {
    peak_file <- peak_files[i]  # Current peak file path
    peak <- utils::read.table(peak_file, header = FALSE)
    peak_df <- peak[, c(1, 2, 3, 4, 8, 6)]

    output_file_name <- paste0("processed_peak_rep_", i, ".bed")
    output_file_path <- file.path(final_out_dir,
                                  output_file_name)

    # Save the processed data frame to the output file
    utils::write.table(
      peak_df,
      file = output_file_path,
      quote = FALSE,
      sep = "\t",
      row.names = FALSE,
      col.names = FALSE
    )

    peak_file_paths[i] <- output_file_path
  }


  result <-
    rmspc::mspc(input = peak_file_paths,
                replicateType = rep_type,
                stringencyThreshold = stringency_threshold,
                weakThreshold = weak_threshold,
                c = c,
                alpha = alpha,
                keep = FALSE)


}
#multiple_replicates_mspc(treat_files = c("tests/testthat/testdata/r1_test.bam",
#                                         "tests/testthat/testdata/r2_test.bam",
#                                         "tests/testthat/testdata/r2_test.bam"),
#                         out_dir = ".",
 #                        nomodel=TRUE
 #                        )





