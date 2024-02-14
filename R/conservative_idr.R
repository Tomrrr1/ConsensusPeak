#' Conservative IDR analysis
#'
#' \code{conservative_idr()} performs the conservative IDR analysis as defined
#' by ENCODE. The function writes output files to a subdirectory in the
#' specified \code{out_dir}.
#'
#' @param treat_files Character vector containing paths to the treatment BAM
#' files.
#' @param control_files Character vector containing paths to the control BAM
#' files.
#' @param is_paired Logical, specifying whether or not the BAM file is
#' paired-end.
#' @param out_dir Character specifying the name of the output directory in which
#' a subdirectory containing the output files will be created.
#' @param subdir_name Character specifying the name of the subdirectory that the
#' output files will be written to.
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#'
#' @seealso \link[ConsensusPeak]{macs_call_peak()}
#'
#' @returns A list containing a summary of the IDR analysis along with the path
#' to the output files.
#'
#' @export

conservative_idr <- function(treat_files,
                             control_files = NULL,
                             is_paired,
                             out_dir,
                             subdir_name = "conservative_idr_analysis",
                             ...) {
  final_out_dir <- create_or_use_dir(out_dir, subdir_name)
  peak_list <-
    prepare_and_call(
      treat_files = treat_files,
      control_files = control_files,
      is_paired = is_paired,
      out_dir = final_out_dir,
      ...
      )

  result_idr <- calculate_idr(peak_file_1 = peak_list[[1]],
                              peak_file_2 = peak_list[[2]],
                              stringent = TRUE,
                              out_dir = final_out_dir)

  msg <- paste0("All output files are stored at ", final_out_dir)
  return(
    list(
      "Results" = result_idr,
      "Output path" = msg
    )
  )
}








