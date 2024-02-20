
#prepare_named_list(treat_files = c("DESCRIPTION", "NAMESPACE"))
#conservative_idr(rep_treat_1 = "./tests/testthat/testdata/r1_test_creb.bam",
 #                rep_treat_2 = "./tests/testthat/testdata/r2_test_creb.bam",
  #               out_dir = "./",
    #             format = "BAM",
   #              nomodel = TRUE,
     #            shift = -75,
      #           pvalue = 1e-3,
       #          extsize = 150,
        #         keepduplicates = "all")

# optimal_idr(treat_files = c("./tests/testthat/testdata/r1_test_creb.bam",
#                             "./tests/testthat/testdata/r2_test_creb.bam"),
#             out_dir = "./",
#             format = "BAM",
#             nomodel = TRUE,
#             shift = -75,
#             pvalue = 1e-3,
#             extsize = 150,
#             keepduplicates = "all")


# res <- idr_analysis(treat_files = c("./tests/testthat/testdata/r1_test_creb.bam",
#                                     "./tests/testthat/testdata/r2_test_creb.bam"),
#              out_dir = "./",
#              type = "all",
#              is_paired = FALSE,
#              nomodel = FALSE,
#              shift = -75,
#              pvalue = 1e-3,
#              extsize = 150,
#              verbose = 0L,
#              keepduplicates = "all")




