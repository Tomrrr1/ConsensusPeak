#' Call consensus peaks using ChIP-R
#'
#' \code{run_chipr()} is a wrapper for the Python package ChIP-R. ChIP-R
#' assesses the reproducibility of peaks across multiple biological replicates
#' by adapting the rank product statistic. Parameter descriptions and
#' defaults are taken from https://github.com/rhysnewell/ChIP-R.
#'
#' @param peak_files Character vector containing paths to the peak files in
#' either narrowPeak, broadPeak or regionPeak format.
#' @param out_name Prefix for the output file names.
#' @param minentries The minimum number of intersections a given peak must
#' satisfy.
#' @param rankmethod The ranking method used to rank peaks within
#' replicates. Options include "signalvalue", "pvalue" and "qvalue". The
#' default is "pvalue".
#' @param duphandling Method for breaking ties. The options are "average" or
#' "random". The default is "average".
#' @param fragment Logical specifying whether the input peaks should be subject
#' to high levels of fragmentation. The default is FALSE.
#' @param seed Numeric specifying a seed for when duphandling = "random".
#' Value must be between 0 and 1. The default is 0.5.
#' @param alpha Numeric cut-off value for deciding the set of reproducible
#' peaks. The default is 0.05.
#' @param size Numeric specifying the minimum peak size when peaks are
#' reconnected after fragmentation. The minimum peak size is ordinarily
#' determined by the size of surrounding peaks, but in the case that there are
#' none, this value will be used. The default is 20.
#' @returns NULL
#'
#' @keywords internal

run_chipr <- function(peak_files,
                      out_name = "chipr_out",
                      minentries = 2,
                      rankmethod = "pvalue",
                      duphandling = "average",
                      fragment = FALSE,
                      seed = 0.5,
                      alpha = 0.05,
                      size = 20) {

  # Construct the command line argument string for input files and --fragment
  input_arg <- paste("-i",
                     paste(peak_files, collapse = " "),
                     paste0(ifelse(fragment, "--fragment", "")))

  # Construct the complete command line string for chip-r
  cmd <-
    sprintf(
      "chipr %s -o %s -m %d -a %f --rankmethod %s --duphandling %s --seed %f -s %d",
      input_arg,
      out_name,
      minentries,
      alpha,
      rankmethod,
      duphandling,
      seed,
      size
    )

  messager("\nRunning ChIP-R with the command:\n",
           cmd)
  # Start the Basilisk environment
  proc <- basilisk::basiliskStart(env_chipr)
  withr::defer(basilisk::basiliskStop(proc))

  # Execute the command within the Basilisk environment
  basilisk::basiliskRun(proc, function() {
    command <- cmd  # Capture the outer cmd variable
    reticulate::py_run_string(
      sprintf(
        "
import subprocess
process = subprocess.run('%s', shell=True, capture_output=True, text=True)
if process.returncode == 0:
    print('Success:', process.stdout)
else:
    print('Error:', process.stderr)
",
        command
      )
    )
  })

}
