% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DirectorNetwork_function.R
\name{DirectorNetwork}
\alias{DirectorNetwork}
\title{One-Mode Directors Network}
\usage{
DirectorNetwork(coynoLIST, mkey)
}
\arguments{
\item{coynoLIST}{list of company numbers}

\item{mkey}{Authorisation key}
}
\value{
One-Mode Director Network - igraph object
}
\description{
This function creates an director to director network from a list of company numbers, the one-mode projection of the interlocking directorates network
}
