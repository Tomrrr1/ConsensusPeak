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

macs_call_peak <- function(..., name, out_dir = ".") {
  # mustWork=TRUE forces an error if out_dir does not exist
  normalised_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  result <-
    MACSr::callpeak(outdir = normalised_out_dir, name = name, ...)

  # return path to broadPeak or narrowPeak file
  peak_idx <- grep("\\.broadPeak$|\\.narrowPeak$", basename(result$outputs))
  return(result$output[peak_idx])
}
