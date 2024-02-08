create_or_use_dir <- function(out_dir, subdir_name) {
  if (!dir.exists(out_dir)) {
    stop("The specified output directory does not exist: ", out_dir)
  }
  norm_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  final_out_dir <- file.path(norm_out_dir, subdir_name)
  if (!dir.exists(final_out_dir)) {
    dir.create(final_out_dir)
    message("Subdirectory created at: ", final_out_dir)
  } else {
    message("Subdirectory already exists. Overwriting...")
  }

  return(final_out_dir)
}
