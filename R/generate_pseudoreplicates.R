#' Generate pseudoreplicate BAM files
#'
#' @import GenomicAlignments
#' @import Rsamtools
#' @import rtracklayer
#'
#' @param bam_file The path to the BAM file.
#' @param is_paired Logical, indicating if the BAM file is paired-end.
#' @param is_control Logical, indicating if the BAM file is a control.
#' @param out_dir The directory to save the output BAM files.
#' @returns A list containing paths to the pseudoreplicate BAM files.
#'
#' @examples
#' \dontrun{
#' pooled_bam <- testthat::test_path("testdata", "merged_treatment.bam")
#' generate_pseudoreplicates(bam_file = pooled_bam,
#'                           is_paired = FALSE,
#'                           is_control = FALSE,
#'                           out_dir = tempdir())
#'                           }
#' @export
generate_pseudoreplicates <- function(bam_file,
                                      is_paired = FALSE,
                                      is_control = FALSE,
                                      out_dir) {
  bam_file <- normalizePath(bam_file)
  out_dir <- normalizePath(out_dir)

  if(is_paired){
    gal <- GenomicAlignments::readGAlignmentPairs(
      bam_file,
      param = Rsamtools::ScanBamParam(
        what = c(
          "qname",
          "flag",
          "rname",
          "strand",
          "pos",
          "qwidth",
          "mapq",
          "cigar",
          "mrnm",
          "mpos",
          "isize",
          "seq",
          "qual",
          "groupid",
          "mate_status"
          )
        ))
  } else {
    gal <- GenomicAlignments::readGAlignments(
      bam_file,
      param = Rsamtools::ScanBamParam(
        what = c(
          "qname",
          "flag",
          "rname",
          "strand",
          "pos",
          "qwidth",
          "mapq",
          "cigar",
          "mrnm",
          "mpos",
          "isize",
          "seq",
          "qual",
          "groupid",
          "mate_status"
          )
        ))
  }

  indices <-
    sample(seq_along(gal), length(gal) / 2, replace = FALSE)
  first_half <- gal[indices]
  second_half <- gal[-indices]

  # Add read names to the names field of the gal object.
  if(is_paired){
    names(first_half) <- first_half@first@elementMetadata$qname
    names(second_half) <- second_half@first@elementMetadata$qname
  } else {
    names(first_half) <- first_half@elementMetadata@listData$qname
    names(second_half) <- second_half@elementMetadata@listData$qname
  }

  file_base <-
    if (is_control) {
      "pseudoreplicate_ctrl"
    } else{
      "pseudoreplicate"
    }

  final_bam1 <- file.path(out_dir, paste0(file_base, "_1.bam"))
  final_bam2 <- file.path(out_dir, paste0(file_base, "_2.bam"))

  return(
    list(pseudoreplicate1 =
           rtracklayer::export(first_half, con = final_bam1, format = "BAM"),
         pseudoreplicate2 =
           rtracklayer::export(second_half, con = final_bam2, format = "BAM")
    )
  )

}
