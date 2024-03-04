#' Conservative IDR analysis
#'
#' \code{conservative_idr()} performs the conservative IDR analysis as defined
#' by ENCODE. The function writes a filtered set of peaks to a desired location.
#'
#' @inheritParams idr_analysis
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#'
#' @returns A list containing a summary of the IDR analysis along with the path
#' to the output files.
#'
#' @keywords internal

conservative_idr <- function(treat_files,
                             control_files = NULL,
                             is_paired,
                             idr_stringent = TRUE,
                             keep_original = FALSE,
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
                              stringent = idr_stringent,
                              keep_original = keep_original,
                              out_dir = final_out_dir)

  messager("All output files are stored at ", final_out_dir)
  return(
    list(
      "Results" = result_idr,
      "Output path" = final_out_dir
    )
  )
}








