\name{weir.broadcrest}
\alias{weir.broadcrest}
\concept{hydraulics}
\concept{water}
\concept{weir}
\title{ Compute Open-Channel Flow over Broad-Crested Weir }
\description{
Parent function for broad-crested weir functions of the \pkg{weirs} package. This simply named function is set to dispatch to subordinate functions according to the general computational procedures for broad-crested weir flow. The supported procedural types are:
\enumerate{
\item \acronym{TWRI3A5}, which represents the implementation of \code{\link{weir3a5.broadcrest}} in the procedures of Hulsing, Harry, 1967, Measurement of peak discharge at dams by indirect methods: U.S. Geological Survey Techniques of Water-Resources Investigations, Book 3, Chapter A5, 29 p., \url{http://pubs.usgs.gov/twri/twri3-a5/}

\item \code{NA} is the empty set and will error out.
}
}
\usage{
weir.broadcrest(..., type=c("TWRI3A5", NA))
}
\arguments{
  \item{...}{Arguments for subordinate broad-crested weir functions; and}
  \item{type}{Identify the broad-crested weir function to dispatch too.}
}
\value{
  An R \code{data.frame()} is returned.
}
\author{W.H. Asquith}
\seealso{\code{\link{weir3a5.broadcrest}}}
\keyword{misc}
