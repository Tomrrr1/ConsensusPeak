#' Filter BAM file to exclude the second mate in the read pair
#'
#' For Tn5-based methods like CUT&Tag and TIPseq, we recommend filtering
#' paired-end BAM files to exclude the second mate in the read pair.

filter_bam <- function(bam_file) {
  if (!file.exists(paste0(bam_file, ".bai"))) {
    bam_index <- indexBam(bam_file)
  } else {
    bam_index <- paste0(bam_file, ".bai")
  }

  bam_file <- normalizePath(bam_file)
  bam_index <- normalizePath(bam_index)

  # define parameters for filtering first mate reads
  param <- ScanBamParam(what = scanBamWhat(),
                        flag = scanBamFlag(isFirstMateRead = TRUE))

  # set up the destination file path and filter
  destination <- paste0("read1_", basename(bam_file))

  filterBam(file = bam_file,
            destination = destination,
            index = bam_index,
            param = param)

  return(destination)
}
