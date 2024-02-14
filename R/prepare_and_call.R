#' Prepare files for peak calling and call peaks
#'
#' \code{prepare_and_call} prepares the BAM files into a list and then passes
#' this list to the macs_call_peak() function. The output is a list comprising
#' file paths to the resulting peak files.
#'
#' @inheritParams conservative_idr
#'
#' @keywords internal

prepare_and_call <- function(treat_files,
                             control_files = NULL,
                             is_paired,
                             out_dir,
                             ...){
  named_list <-
    prepare_named_list(
      treat_files = treat_files,
      control_files = control_files
    )

  messager("All files have been checked. Starting peak calling with MACS3.")
  result_list <- list()
  for(i in seq_len(length(treat_files))){

    result_list[[i]] <-
      macs_call_peak(
        tfile = named_list[[paste0("treatment_file_", i)]],
        cfile = named_list[[paste0("control_file_", i)]],
        out_dir = out_dir,
        format = ifelse(is_paired, "BAMPE", "BAM"),
        name = paste0("rep", i),
        ...)

  }

  return(result_list)
}
