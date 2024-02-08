#' Call peaks using MACSr
#'
#' This function is a wrapper of the \link[MACSr]{callpeak()} function from the
#' \code{MACSr} package.
#'
#' @importFrom MACSr callpeak
#'
#' @param ... Arguments to be passed to \link[MACSr]{callpeak()}
#' @param out_dir Path to the output directory where all files will be written
#' @param out_name Prefix for the output file names
#'
#' @seealso \link[MACSr]{callpeak()} which this function wraps
#' @return Full paths to the created \code{narrowPeak} or \link{broadPeak}
#' file
#'
#' @export

macs_call_peak <- function(..., out_name, out_dir = ".") {

  message("\nCalling peaks with MACSr")

  # mustWork=TRUE forces an error if out_dir does not exist
  normalised_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  result <-
    MACSr::callpeak(outdir = normalised_out_dir, name = out_name, ...)

  # Return path to the narrowPeak file
  return(result$outputs[1])

}
