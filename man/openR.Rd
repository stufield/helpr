% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/openR.R
\name{openR}
\alias{openR}
\title{Open File Interactively}
\usage{
openR(file)
}
\arguments{
\item{file}{A path to a file.}
}
\value{
The file path, invisibly.
}
\description{
Opens a text file in an \code{RStudio} interactive session. Must be using
\code{RStudio} interactively. Similar to \code{rstudioapi::navigateToFile()} but
without the added \pkg{rstudioapi} dependency.
}
