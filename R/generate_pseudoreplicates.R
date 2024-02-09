#' Generate pseudoreplicate BAM files
#'
#' @import Rsamtools
#'
#' @param pooled_bam The path to the pooled BAM file.
#' @param output_dir The directory to save the output BAM files.
#' @param paired_end Logical, indicating if the BAM file is paired-end.
#' @param is_control Logical, indicating if the BAM file is a control.
#' @return A list containing paths to the pseudoreplicate BAM files.
generate_pseudoreplicates <- function(pooled_bam,
                                      out_dir,
                                      paired_end = TRUE,
                                      is_control = FALSE) {
  out_dir <- normalizePath(out_dir)
  temp_sam_path <- withr::local_tempfile(fileext = ".sam")
  withr::defer(unlink(temp_sam_path))

  Rsamtools::asSam(
    pooled_bam,
    destination = sub("\\.sam$",
                      "",
                      temp_sam_path),
    overwrite = TRUE
  )

  # Read and shuffle the SAM file
  original_sam <- readLines(temp_sam_path)
  header <- original_sam[grepl("^@", original_sam)]
  reads <- original_sam[!grepl("^@", original_sam)]
  shuf_reads <- sample(reads, replace = FALSE)

  if (paired_end) {
    # Create temp paths for shuffled and sorted BAM files
    temp_shuffled_sam <- withr::local_tempfile(fileext = ".sam")
    temp_shuffled_bam <- withr::local_tempfile(fileext = ".bam")
    sorted_shuffled_bam <- withr::local_tempfile(fileext = ".bam")

    withr::defer(unlink(c(
      temp_shuffled_sam,
      temp_shuffled_bam,
      sorted_shuffled_bam
    )))

    # Write shuffled reads to a temporary SAM file
    writeLines(c(header, shuf_reads), temp_shuffled_sam)

    # Convert shuffled SAM to BAM for sorting
    Rsamtools::asBam(
      temp_shuffled_sam,
      destination = sub("\\.bam$",
                        "",
                        temp_shuffled_bam),
      overwrite = TRUE,
      indexDestination = FALSE
    )

    # Sort the shuffled BAM file
    Rsamtools::sortBam(
      temp_shuffled_bam,
      destination = sub("\\.bam$",
                        "",
                        sorted_shuffled_bam),
      byQname = TRUE,
      indexDestination = FALSE
    )

    # Convert sorted BAM back to SAM
    Rsamtools::asSam(
      sorted_shuffled_bam,
      destination = sub("\\.sam$",
                        "",
                        temp_shuffled_sam),
      overwrite = TRUE,
      indexDestination = FALSE
    )

    # Read and split the sorted SAM file
    sorted_sam <- readLines(temp_shuffled_sam)
    shuf_reads <- sorted_sam[!grepl("^@", sorted_sam)]

  }

  # Find the midpoint at which to split the merged file
  mid_point <- length(shuf_reads) %/% 2

  file_base <-
    if (is_control) {
      "pseudoreplicate_ctrl"
    } else{
      "pseudoreplicate"
    }

  final_bam1 <- file.path(out_dir, paste0(file_base, "_1.bam"))
  final_bam2 <- file.path(out_dir, paste0(file_base, "_2.bam"))

  writeLines(c(header,
               shuf_reads[1:mid_point]),
             temp_sam_path)

  Rsamtools::asBam(
    temp_sam_path,
    destination = sub("\\.bam$",
                      "",
                      final_bam1),
    overwrite = TRUE
  )

  writeLines(c(header,
               shuf_reads[(mid_point + 1):length(shuf_reads)]),
             temp_sam_path)

  Rsamtools::asBam(
    temp_sam_path,
    destination = sub("\\.bam$",
                      "",
                      final_bam2),
    overwrite = TRUE
  )

  # Return file paths of the new BAM files
  return(list(pseudoreplicate1 = final_bam1, pseudoreplicate2 = final_bam2))

}
