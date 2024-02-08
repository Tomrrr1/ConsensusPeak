#' Prepare a Named List of File Paths for Replicates and Controls
#'
#' This function checks the validity of user-specified file paths for replicates
#' and controls and constructs a named list. The function ensures that the file
#' paths are valid and normalises them.
#'
#' @param rep_treat_1 File path to the first treatment replicate.
#' @param rep_treat_2 Optional file path to the second treatment replicate.
#' @param rep_ctrl_1 Optional file path to the first control replicate.
#' @param rep_ctrl_2 Optional file path to the second control replicate.
#' @return A named list of normalised file paths for the provided replicates
#' and controls. The list will contain elements named "treatment_file_1",
#' "treatment_file_2", "control_file_1", and "control_file_2", corresponding
#' to the provided file paths. The list is filtered to exclude any that are
#' NULL.

prepare_named_list <- function(rep_treat_1,
                               rep_treat_2 = NULL,
                               rep_ctrl_1 = NULL,
                               rep_ctrl_2 = NULL) {
  # Combine all file paths into a list
  file_list <- list(
    "treatment_file_1" = rep_treat_1,
    "treatment_file_2" = rep_treat_2,
    "control_file_1" = rep_ctrl_1,
    "control_file_2" = rep_ctrl_2
  )

  # Remove NULL entries in list
  file_list <- Filter(Negate(is.null), file_list)

  # Check validity and normalise each file path
  file_list <- lapply(file_list, function(x) {
    if (!is.character(x) || length(x) != 1) {
      stopper("Each file path must be a single character string.")

    }
    # if dir.exists(x) is true then x is pointing to a file, not a directory.
    if (!file.exists(x) || dir.exists(x)) {
      stopper("File does not exist: ", x)

    }

    normalizePath(x)

  })

  return(file_list)
}
