#' Multiple Sample Peak Calling (MSPC)
#'
#' \code{multiple_replicates_mspc()} is a wrapper of the \link{rmspc}{mspc()}
#' function. MSPC handles an arbitrary number of replicates, but is not
#' recommended for the simple case of n = 2, where we suggest using
#' \code{conservative_idr()} or \code{optimal_idr()}.
#'
#' @inheritParams conservative_idr
#' @inheritParams rmspc::mspc
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' @returns A list containing a summary of the MSPC along with the path to the
#' output files.
multiple_replicates_mspc <- function(treat_files,
                                     control_files = NULL,
                                     is_paired,
                                     out_dir,
                                     subdir_name = "mspc_analysis",
                                     replicateType,
                                     stringencyThreshold,
                                     weakThreshold,
                                     gamma=stringencyThreshold,
                                     c,
                                     alpha=0.05,
                                     keep=TRUE,
                                     ...) {
  if(check_dotnet_version() == FALSE) {
    stopper("Halting multiple replicate analysis")
  }

  final_out_dir <- create_or_use_dir(out_dir, subdir_name)
  peak_list <-
    prepare_and_call(
      treat_files = treat_files,
      control_files = control_files,
      is_paired = is_paired,
      out_dir = final_out_dir,
      ...
    ) # outputs a named list of peak files

  peak_file_paths <- process_peak_file(peak_list,
                                       final_out_dir)

  result_mspc <-
    rmspc::mspc(input = peak_file_paths,
                replicateType = replicateType,
                stringencyThreshold = stringencyThreshold,
                weakThreshold = weakThreshold,
                gamma = gamma,
                c = c,
                alpha = alpha,
                outputPath = file.path(final_out_dir, "mspc_files"),
                keep = keep
                )

  msg <- paste0("All output files are stored at ", final_out_dir)
  return(
    list(
      "Results" = result_mspc,
      "Output path" = msg
    )
  )

}
