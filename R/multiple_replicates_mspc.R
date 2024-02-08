#' Run Multiple Sample Peak Calling (MSPC)
#'
#' This function is a wrapper of the \link{rmspc}{mspc()} function. The function
#' handles an arbitrary number of replicates. Best suited for n > 2.
#'
#' @param peak_files A vector of peak files to be passed to \code{mspc()}
#' @param ... Additional parameters to be passed to \code{mspc()}
#'
#'
#' This function requires dotnet 6.0.0 or higher as a system dependency
#' Advise the user to open a conda env and install dotnet here.

multiple_replicates_mspc <- function(peak_files,
                                     ...) {

  messager(
  "Note that this function requires dotnet v6.0.0 (or higher) to be installed
  on your system. This program can be installed here
  https://dotnet.microsoft.com/en-us/download/dotnet/6.0. If you are having
  difficulties with installation of dotnet you can try running ConsensusPeak
  through our dedicated Docker container."
  )

  rmspc::mspc(input = peak_files,
              replicateType = "Biological",
              stringencyThreshold = 1e-12,
              weakThreshold = 1e-8,
              c = 2,
              alpha = 0.01)


}




messager("Note that this function requires dotnet 6.0.0 as a system dependency. This program can be installed here https://dotnet.microsoft.com/en-us/download/dotnet/6.0")


