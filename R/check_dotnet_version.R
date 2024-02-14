check_dotnet_version <- function() {
  tryCatch(
    expr = {
      check <- system("dotnet --info", intern = TRUE)
      version_line <- grep("^\\s*Version:\\s*\\d\\..*$", check, value = TRUE)[1]
      major_version <- gsub("^\\s*Version:\\s*", "", version_line)
      if (as.numeric(gsub("^(\\d+)\\..*$", "\\1", major_version)) != 6) {
        stopper("")
      }
      messager(
        "A suitable version of .NET 6.0 is installed. Proceeding to analysis."
        )
      return(TRUE)
    },
    error = function(e) {
      messager(
        "\n .NET 6.0 CANNOT BE FOUND on your system. Multiple replicate \n",
        "analysis requires .NET 6.0 (or higher) to be installed. Please\n",
        "follow the installation instructions here:\n",
        "\n https://dotnet.microsoft.com/en-us/download/dotnet/6.0 \n"
      )
      return(FALSE)
    }
  )
}

