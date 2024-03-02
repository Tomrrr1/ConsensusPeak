#' Multiple replicate peak calling with MSPC
#'
#' \code{multiple_replicates_mspc()} runs multiple sample peak calling from the
#' rmspc package. The function handles an arbitrary number of biological
#' replicates.
#'
#' @inheritParams conservative_idr
#' @inheritParams rmspc::mspc
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#'
#' @returns A list containing a summary of the MSPC along with the path to the
#' output files.
#'
#' @examples
#' \dontrun{
#' input1 <- testthat::test_path("testdata", "r1_test_creb.bam")
#' input2 <- testthat::test_path("testdata", "r2_test_creb.bam")
#' input3 <- testthat::test_path("testdata", "r3_test_creb.bam")
#'
#' multiple_replicates_mspc(treat_files = c(input1, input2, input3),
#'                          out_dir = tempdir(),
#'                          subdir_name = "mspc_analysis"
#'                          is_paired = FALSE,
#'                          replicateType = "Biological",
#'                          stringencyThreshold = 1e-8,
#'                          weakThreshold = 1e-4,
#'                          c = 3,
#'                          ...
#'                          )
#'                          }
#'
#' @export
multiple_replicates_mspc <- function(treat_files,
                                     control_files = NULL,
                                     is_paired,
                                     out_dir,
                                     subdir_name = "mspc_analysis",
                                     replicateType,
                                     stringencyThreshold,
                                     weakThreshold,
                                     gamma=stringencyThreshold,
                                     c,
                                     alpha=0.05,
                                     keep=TRUE,
                                     ...) {
  if(check_dotnet_version() == FALSE) {
    stopper()
  }

  final_out_dir <- create_or_use_dir(out_dir, subdir_name)
  peak_list <-
    prepare_and_call(
      treat_files = treat_files,
      control_files = control_files,
      is_paired = is_paired,
      out_dir = final_out_dir,
      ...
    ) # outputs a named list of peak files

  # mspc requires specific formatting of peak files
  peak_file_paths <- process_peak_file(peak_list = peak_list,
                                       out_dir = final_out_dir)

  result_mspc <-
    rmspc::mspc(input = peak_file_paths,
                replicateType = replicateType,
                stringencyThreshold = stringencyThreshold,
                weakThreshold = weakThreshold,
                gamma = gamma,
                c = c,
                alpha = alpha,
                outputPath = file.path(final_out_dir, "mspc_files"),
                keep = keep
                )

  messager("All output files are stored at ", final_out_dir)
  return(
    list(
      "Results" = result_mspc,
      "Output path" = final_out_dir
    )
  )
}
