#' Filter BAM file to exclude the second mate in the read pair
#'
#' For Tn5-based methods like CUT&Tag and TIPseq, we recommend filtering
#' paired-end BAM files to exclude the second mate in the read pair.
#' If the BAM file does not have and index please run

filter_bam <- function(bam_file,
                       out_dir) {
  norm_out_dir <- normalizePath(out_dir, mustWork = TRUE)
  bam_file <- normalizePath(bam_file)

  index_destination <-
    file.path(norm_out_dir, paste0("read1_", basename(bam_file), ".bai"))

  if (!file.exists(paste0(bam_file, ".bai"))) {
    bam_index <- indexBam(bam_file, destination = index_destination)
  } else {
    bam_index <- paste0(bam_file, ".bai")
  }

  bam_index <- normalizePath(bam_index)

  # define parameters for filtering first mate reads
  param <- ScanBamParam(what = scanBamWhat(),
                        flag = scanBamFlag(isFirstMateRead = TRUE))

  destination <-
    file.path(norm_out_dir, paste0("read1_", basename(bam_file)))
  filterBam(file = bam_file,
            destination = destination,
            index = bam_index,
            param = param)

  return(destination)
}
