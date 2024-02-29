#' Initialise an environment to run the python package ChIP-R.
#'
#' @import basilisk
env_chipr <-
  basilisk::BasiliskEnvironment("env_chipr",
                                pkgname="ConsensusPeak",
                                packages = c("python=3.10"),
                                pip = c("chip-r==1.2.0"))
