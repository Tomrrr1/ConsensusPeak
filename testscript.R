conservative_idr(rep_treat_1 = "tests/testthat/testdata/r1_test_creb.bam",
                 rep_treat_2 = "tests/testthat/testdata/r2_test_creb.bam",
                 out_dir = ".",
                 nomodel = TRUE,
                 shift = -75,
                 extsize = 150,
                 format = "BAM",
                 pvalue = 1e-3,
                 keepduplicates = "all")


macs_call_peak(tfile = "tests/testthat/testdata/r3_test_creb.bam", out_name = "r3_creb",
               out_dir = ".", nomodel=TRUE, shift = -75,
               extsize = 150,
               format = "BAM",
               pvalue = 1e-3,
               keepduplicates = "all")

rmspc::mspc(c(input1, input2, input3), replicateType = "Technical",
            stringencyThreshold = 1e-12, weakThreshold = 1e-10,
            c = 3, alpha = 0.05)

input1 <- testthat::test_path("testdata", "r1_test_creb.bam")
input2 <- testthat::test_path("testdata", "r2_test_creb.bam")
input3 <- testthat::test_path("testdata", "r3_test_creb.bam")

multiple_replicates_mspc(treat_files = c(input1, input2, input3),
                         out_dir = ".",
                         nomodel=TRUE,
                         format = "BAM",
                         rep_type = "Technical",
                         stringency_threshold = 1e-12,
                         weak_threshold = 1e-10,
                         c = 3,
                         alpha = 0.05)



testthat::test_path("testdata", "r3_test_creb.bam")


peakfiles <- list(
  "idr" = normalizePath("./conservative_analysis/IDR_peaks_01.narrowPeak"),
  "mspc" = normalizePath("./session_20240208_143221952/ConsensusPeaks.bed")
)

data(hg38_blacklist)
genome_build_list <- list(peakfiles="hg38",
                          reference="hg38",
                          blacklist=hg38_blacklist)

EpiCompare::EpiCompare(peakfiles = peakfiles,
                       genome_build = genome_build_list,
                       genome_build_output = "hg38",
                       upset_plot = FALSE,
                       stat_plot = TRUE,
                       chromHMM_plot = FALSE,
                       chromHMM_annotation = 'K562',
                       chipseeker_plot = TRUE,
                       enrichment_plot = TRUE,
                       tss_plot = FALSE,
                       precision_recall_plot = FALSE,
                       corr_plot = FALSE,
                       interact = TRUE,
                       output_dir = "./")






