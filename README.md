NULL [![License: GPL (\>=
3)](https://img.shields.io/badge/license-GPL%20(%3E=%203)-blue.svg)](https://cran.r-project.org/web/licenses/GPL%20(%3E=%203))
[![](https://img.shields.io/badge/devel%20version-0.0.0.9000-black.svg)](https://github.com/Tomrrr1/ConsensusPeak)
[![](https://img.shields.io/github/languages/code-size/Tomrrr1/ConsensusPeak.svg)](https://github.com/Tomrrr1/ConsensusPeak)
[![](https://img.shields.io/github/last-commit/Tomrrr1/ConsensusPeak.svg)](https://github.com/Tomrrr1/ConsensusPeak/commits/master)
<br> [![R build
status](https://github.com/Tomrrr1/ConsensusPeak/workflows/rworkflows/badge.svg)](https://github.com/Tomrrr1/ConsensusPeak/actions)
[![](https://codecov.io/gh/Tomrrr1/ConsensusPeak/branch/master/graph/badge.svg)](https://app.codecov.io/gh/Tomrrr1/ConsensusPeak)
<br>
<a href='https://app.codecov.io/gh/Tomrrr1/ConsensusPeak/tree/master' target='_blank'><img src='https://codecov.io/gh/Tomrrr1/ConsensusPeak/branch/master/graphs/icicle.svg' title='Codecov icicle graph' width='200' height='50' style='vertical-align: top;'></a>  
<h4>  
Authors: <i>Thomas Roberts</i>  
</h4>
2024-02-04

## Introduction

`ConsensusPeak` is an R Package for calling consensus peaks from multiple 
biological replicates. We implement several methods for thresholding, including 
IDR conservative, IDR optimal, MSPC and ChIP-R.

## Installation

```R
if(!require("remotes")) install.packages("remotes")
remotes::install_github("neurogenomics/ConsensusPeak")
```

## Usage

Load example data:

```R
rep_treat_1 <- system.file("extdata",
                           "r1_creb_chr22.bam",
                           package = "ConsensusPeak")
rep_treat_2 <- system.file("extdata",
                           "r2_creb_chr22.bam",
                           package = "ConsensusPeak")
```

Run MACS3 peak calling and IDR thresholding with a single command:

```R
result <- idr_analysis(treat_files = c(rep_treat_1, rep_treat_2),
                       control_files = NULL,
                       type = "conservative",
                       is_paired = FALSE, # Is the data paired-end?
                       idr_stringent = TRUE # Threshold at 0.01 or 0.05
                       out_dir = ".", # Directory to write the output files
                       nomodel = TRUE # MACS3 setting
                       )
```


















   
   
