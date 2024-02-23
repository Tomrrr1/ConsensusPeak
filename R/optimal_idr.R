#' Optimal IDR analysis
#'
#' \code{optimal_idr()} runs the optimal IDR analysis. This involves pooling of
#' the biological replicate BAM files, shuffling the reads splitting into
#' pseudoreplicates.
#'
#' @inheritParams conservative_idr
#'
#' @returns Summary of the IDR output
#'
#' @export
optimal_idr <- function(treat_files,
                        control_files = NULL,
                        is_paired,
                        out_dir,
                        subdir_name = "optimal_idr_analysis",
                        ...){
  final_out_dir <- create_or_use_dir(out_dir, subdir_name)

  named_list <-
    prepare_named_list(
      treat_files = treat_files,
      control_files = control_files
    )

  # outputs vector
  pooled_files <- pool_files(named_list = named_list,
                             out_dir = final_out_dir)

  # outputs list
  pseudo_treat <-
    generate_pseudoreplicates(pooled_files[1],
                              out_dir = final_out_dir,
                              is_paired = is_paired,
                              is_control = FALSE)

   if (length(pooled_files) == 2) {
    # Generate pseudoreplicates for the control file
    pseudo_ctrl <- generate_pseudoreplicates(pooled_files[2],
                                             out_dir = final_out_dir,
                                             is_paired = is_paired,
                                             is_control = TRUE)
  } else {
    pseudo_ctrl <- NULL
  }

  result_list <- list()
  for(i in seq_len(length(treat_files))){

    result_list[[i]] <-
      macs_call_peak(
        tfile = pseudo_treat[[paste0("pseudoreplicate", i)]],
        cfile = pseudo_ctrl[[paste0("pseudoreplicate", i)]],
        out_dir = final_out_dir,
        format = ifelse(is_paired, "BAMPE", "BAM"),
        name = paste0("rep", i),
        ...)

  }

  result_idr <- calculate_idr(peak_file_1 = result_list[[1]],
                              peak_file_2 = result_list[[2]],
                              stringent = TRUE,
                              out_dir = final_out_dir)

  messager("All output files are stored at ", final_out_dir)
  return(
    list(
      "Results" = result_idr,
      "Output path" = final_out_dir
      )
    )
}
