#' Call consensus peaks using IDR
#'
#' \code{idr_analysis()} calls consensus peaks using IDR thresholding. IDR
#' analysis can be used to generate a "conservative" or "optimal" set of peaks.
#'
#' @param treat_files Character vector containing paths to the treatment BAM
#' files.
#' @param control_files Character vector containing paths to the control BAM
#' files. The default is NULL
#' @param type String denoting the analysis type. Either "conservative",
#' "optimal" or "all". The default is "all"
#' @param is_paired Logical, specifying whether or not the BAM files are
#' paired-end. The default is `FALSE`.
#' @param keep_original Should the original peaks from one of the replicates
#' be written to the output file or should the output peaks be the sum of the
#' ranges of the two replicates peaks. The default is `FALSE`.
#' @param idr_stringent Logical, relating to the IDR threshold. If set to `TRUE`
#' then the threshold used by IDR is 0.01. If set to `FALSE` then the threshold
#' is 0.05. The default is `TRUE`.
#' @param out_dir Character specifying the path at which the results directory
#' will be created. By default, the results directories are created in
#' tempdir().
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#'
#' @returns A list containing a summary of the IDR analysis along with the path
#' to the output files.
#' @export
#' @examples
#' \dontrun{
#' input1 <- testthat::test_path("testdata", "r1_test_creb.bam")
#' input2 <- testthat::test_path("testdata", "r2_test_creb.bam")
#'
#' idr_analysis(treat_files = c(input1, input2),
#'             control_files = NULL,
#'             type = "all",
#'             is_paired = FALSE,
#'             out_dir = tempdir()
#'             )
#'             }
idr_analysis <- function(treat_files,
                         control_files = NULL,
                         type = "all",
                         is_paired = FALSE,
                         idr_stringent = TRUE,
                         keep_original = FALSE,
                         out_dir = tempdir(),
                         ...){

  valid_types <- c("conservative", "optimal", "all")
  if(!type %in% valid_types){
    stopper("Invalid analysis type.",
            "Must be one of conservative, optimal or all")
  }

  # Initialise a list to store results
  results <- list()

  if(type == "conservative" || type == "all"){
    messager("Starting conservative IDR analysis.\n")
    results$conservative <-
      conservative_idr(treat_files = treat_files,
                       control_files = control_files,
                       is_paired = is_paired,
                       idr_stringent = idr_stringent,
                       keep_original = keep_original,
                       out_dir = out_dir,
                       subdir_name = "conservative_idr_analysis",
                       ...)
    messager("Finished conservative IDR analysis!\n")
  }

  if(type == "optimal" || type == "all"){
    messager("Starting optimal IDR analysis.\n")
    results$optimal <-
      optimal_idr(treat_files = treat_files,
                  control_files = control_files,
                  is_paired = is_paired,
                  idr_stringent = idr_stringent,
                  keep_original = keep_original,
                  out_dir = out_dir,
                  subdir_name = "optimal_idr_analysis",
                  ...)
    messager("Finished optimal IDR analysis!\n")
  }

  if(type != "all"){
    return(results[[type]])
  }

  # If type = "all" just return the full results list
  return(results)
}
