#' Conservative IDR analysis
#'
#' \code{conservative_idr()} performs the conservative IDR analysis as defined
#' by ENCODE. The function writes output files to a subdirectory in the
#' specified \code{out_dir}.
#'
#' @param rep_treat_1 The path to the BAM file for biological replicate 1
#' @param rep_treat_2 The path to the BAM file for biological replicate 2
#' @param out_dir A subdirectory containing the results from the analysis will
#' be created at the specified location.
#' @param paired_end Logical, indicating if the BAM file is paired-end.
#' @param ... Additional parameters to be passed to the macs_call_peak
#' function.
#'
#' @seealso \link[ConsensusPeak]{macs_call_peak()}
#'
#' @return list...
#'
#' @export

# Import the messager and stopper functions from EpiCompare and use in place
# message and stop.

conservative_idr <- function(rep_treat_1,
                             rep_treat_2,
                             rep_ctrl_1 = NULL,
                             rep_ctrl_2 = NULL,
                             out_dir,
                             subdir_name = "conservative_analysis",
                             ...) {
  # Generate the file list
  named_list <-
    ConsensusPeak:::prepare_named_list(rep_treat_1 = rep_treat_1,
                                       rep_treat_2 = rep_treat_2,
                                       rep_ctrl_1 = rep_ctrl_1,
                                       rep_ctrl_2 = rep_ctrl_2)

  # Generate the final output directory
  final_out_dir <- create_or_use_dir(out_dir, subdir_name)

  # Call peak for biological replicate 1.
  # cfile defaults to NULL if it does not exist
  result_rep_1 <-
    ConsensusPeak::macs_call_peak(tfile = named_list[["treatment_file_1"]],
                                  cfile = named_list[["control_file_1"]],
                                  out_dir = final_out_dir,
                                  out_name = "rep1",
                                  ...)

  # Call peak for biological replicate 2
  result_rep_2 <-
    ConsensusPeak::macs_call_peak(tfile = named_list[["treatment_file_2"]],
                                  cfile = named_list[["control_file_2"]],
                                  out_dir = final_out_dir,
                                  out_name = "rep2",
                                  ...)


  result_idr <- ConsensusPeak::calculate_idr(peak_file_1 = result_rep_1,
                                             peak_file_2 = result_rep_2,
                                             stringent = TRUE,
                                             out_dir = final_out_dir)

  return(result_idr)

}
