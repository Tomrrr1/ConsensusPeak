#' Call consensus peaks using IDR
#'
#' \code{analysis_idr()} calls consensus peaks using IDR thresholding. IDR
#' analysis can be used to generate a "conservative" or "optimal" set of peaks.
#'
#' @param treat_files Character vector containing paths to the treatment BAM
#' files.
#' @param control_files Character vector containing paths to the control BAM
#' files.
#' @param type String denoting the analysis type. Either "conservative" or
#' "optimal".
#' @param is_paired Logical, specifying whether or not the BAM file is
#' paired-end.
#' @param out_dir Character specifying the name of the output directory in which
#' a subdirectory containing the output files will be created.
#' @param subdir_name Character specifying the name of the subdirectory that the
#' output files will be written to.
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#'
#' @returns A list containing a summary of the IDR analysis along with the path
#' to the output files. Markdown report?

idr_analysis <- function(treat_files,
                         control_files = NULL,
                         type = "all",
                         is_paired,
                         out_dir,
                         ...){

  if(!type %in% c("conservative", "optimal", "all")){
    stopper("Invalid analysis type. Must be conservative, optimal or all")
  }

  if(type == "conservative"){

    conservative_idr(treat_files = treat_files,
                     control_files = control_files,
                     is_paired = is_paired,
                     out_dir = out_dir,
                     subdir_name = "conservative_idr_analysis",
                     ...)

  } else if(type == "optimal"){

    optimal_idr(treat_files = treat_files,
                control_files = control_files,
                is_paired = is_paired,
                out_dir = out_dir,
                subdir_name = "optimal_idr_analysis",
                ...)

  } else {

    conservative_idr(treat_files = treat_files,
                     control_files = control_files,
                     is_paired = is_paired,
                     out_dir = out_dir,
                     subdir_name = "conservative_idr_analysis",
                     ...)

    optimal_idr(treat_files = treat_files,
                control_files = control_files,
                is_paired = is_paired,
                out_dir = out_dir,
                subdir_name = "optimal_idr_analysis",
                ...)

  }


}


