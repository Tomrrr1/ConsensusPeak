#' Call peaks using MACSr
#'
#' Call peaks using MACSr, an R wrapper of the Python package MACS3.
#'
#' @importFrom MACSr callpeak
#'
#' @param out_dir Path to the output directory where all files will be written
#' @param name Prefix for the output file name
#' @inheritDotParams MACSr::callpeak -outdir -name
#'
#' @return Full paths to the created \code{narrowPeak} or \code{broadPeak}
#' file
#'
#' @export

macs_call_peak <- function(..., name, out_dir = ".") {
  # mustWork=TRUE forces an error if out_dir does not exist
  normalised_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  result <-
    MACSr::callpeak(outdir = normalised_out_dir, name = name, ...)

  # return path to broadPeak or narrowPeak file
  peak_idx <- grep("\\.broadPeak$|\\.narrowPeak$", basename(result$outputs))
  return(result$output[peak_idx])
}
