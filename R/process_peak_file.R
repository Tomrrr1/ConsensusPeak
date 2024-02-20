#' Process peak files before input to MSPC.
#'
#' @keywords internal

process_peak_file <- function(peak_list,
                              out_dir) {
  peak_files <- unlist(peak_list)
  peak_file_paths <- c()

  for (i in seq_along(peak_files)) {
    peak_file <- peak_files[i]
    peak <- utils::read.table(peak_file, header = FALSE)
    peak_df <- peak[, c(1, 2, 3, 4, 8, 6)] # columns required for MSPC

    output_file_path <- file.path(out_dir,
                                  paste0("processed_peak_rep_", i, ".bed"))

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


  return(peak_file_paths)
}
