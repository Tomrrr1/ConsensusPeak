#' Pool Biological Replicates into a Single BAM File
#'
#' This function pools biological replicates into a single BAM file. It is
#' designed to work with the output from the `prepare_named_list` function,
#' which provides a named list of BAM file paths. If control files are provided,
#' they are also merged into a separate control BAM file.
#'
#' @param named_list A named list containing paths to BAM files.
#' This list is outputted from the `prepare_named_list` function.
#'
#' The list includes:
#' - "treatment_file_1" Path to the first treatment replicate.
#' - "treatment_file_2" Path to the second treatment replicate.
#' - "control_file_1" Optional. Path to the first control replicate.
#' - "control_file_2" Optional. Path to the second control replicate.
#'
#' @param out_dir The directory where the merged BAM files will be saved.
#' @return Vector containing file paths to the output BAM files
#'
#' @keywords internal

pool_files <- function(named_list, # formatted by prepare_named_list
                       out_dir) {
  rep1 <- named_list[["treatment_file_1"]]
  rep2 <- named_list[["treatment_file_2"]]

  out_dir <- normalizePath(out_dir)

  treat <- Rsamtools::mergeBam(
    files = c(rep1, rep2),
    destination = file.path(out_dir, "merged_treatment.bam"),
    overwrite = TRUE
  )

  result <- c(normalizePath(treat))

  if (length(named_list) == 4) {
    ctrl1 <- named_list[["control_file_1"]]
    ctrl2 <- named_list[["control_file_2"]]

    ctrl <- Rsamtools::mergeBam(
      files = c(ctrl1, ctrl2),
      destination = file.path(out_dir, "merged_control.bam"),
      overwrite = TRUE
    )

    result <- c(normalizePath(treat), normalizePath(ctrl))

  }

  return(result)
}




