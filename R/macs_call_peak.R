#' Call peaks using MACSr
#'
#' This function is a wrapper of the MACSr::callpeak() function, which is itself
#' a wrapper of the Python package MACS3.
#'
#' @importFrom MACSr callpeak
#'
#' @param ... Arguments to be passed to MACSr::callpeak()
#' @param out_dir Path to the output directory where all files will be written
#' @param out_name Prefix for the output file names
#'
#' @seealso [MACSr::callpeak()] which this function wraps
#' @return NULL
#'
#' @export

macs_call_peak <- function(..., out_name, out_dir = ".") {

  message("\nCalling peaks with MACSr")

  # mustWork=TRUE forces an error if out_dir does not exist
  normalised_out_dir <- normalizePath(out_dir, mustWork = TRUE)

  MACSr::callpeak(outdir = normalised_out_dir, name = out_name, ...)

}
