% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logit-expit.R
\name{logit}
\alias{logit}
\alias{expit}
\title{\code{Logit} and \code{Expit} Transformations}
\usage{
logit(x)

expit(x)
}
\arguments{
\item{x}{\code{numeric(n)}.}
}
\value{
A \code{numeric(n)} corresponding to transformed \code{x}.
}
\description{
\code{logit()} computes the binary logit function.
This is a simple wrapper for \code{stats::qlogis()}
with default input arguments.

\code{expit()} computes the logistic function. This is a
simple wrapper for \code{stats::plogis()} with
default input arguments.
}
\examples{
x <- stats::runif(n = 100L)
logit(x)

x <- stats::rnorm(n = 100L)
expit(x)
}
