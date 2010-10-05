\name{weir3a5.sharpcrest}
\alias{weir3a5.sharpcrest}
\concept{hydraulics}
\concept{water}
\concept{weir}
\title{ Compute Open-Channel Flow over Broad-Crested Weir by TWRI3A5 }
\description{
Compute open-channel flow (discharge) over a sharp-crested weir in general accordance with Hulsing (1967) [\acronym{TWRI3A5}]. The weir crest of opening (width) \eqn{b} in feet is \eqn{P} feet above the channel bottom and \eqn{L} feet long in the flow direction. A rectangular approach channel is specified by width \eqn{B}, but the area of the channel (and hence rectangular assumption) can be bypassed by function arguments, although \eqn{B} is used in the contraction ratio \eqn{b/B} unless this ratio is superceded. For the \code{weir3a5.sharpcrest()} function, the computations are exclusively based on the foot-second unit system and careful adherance by the user is required as not all \dQuote{coefficients} are dimensionless.

The discharge equation for an acceptable tail-water condition \eqn{h_t} is
\deqn{Q = k_c k_t C b H^{1.5}}{Q = kc kt C b H^1.5}
where \eqn{Q} is discharge in cubic feet per second, \eqn{k_c} is the contraction coefficient that also is a function of the abutment rounding \eqn{r}, \eqn{k_t} is the submergence adjustment coefficient, \eqn{C} is the discharge coefficient, \eqn{b} is the width in feet of the weir crest, and \eqn{H} is total free-flow head in feet on the weir assuming \eqn{h_t = 0}, which is computed by
\deqn{H = h + v_o = h + \alpha v^2/2g}{H = h + alpha * v^2/2g}
where \eqn{h} is static head in feet on the weir, \eqn{v_o} is velocity head in feet in the approach section, \eqn{v} is mean velocity in feet per second in the section computed by \eqn{v=Q/A} for cross section area \eqn{A} in square feet, which by default is computed by \eqn{A=(h + P)B}, but can be superceded. The quantity \eqn{g} is the acceleration of gravity and is hardwired to 32.2 feet per square second. The dimensionless quantity \eqn{\alpha} permits accommodation of a velocity head correction that is often attributable to cross section subdivision. The \eqn{\alpha} is outside the scope of this documentation, is almost always \eqn{\alpha=1}, and is made available as an argument for advanced users.

The \code{weir3a5.sharpcrest()} function is vectorized meaning that optional vectors of \eqn{h} can be specified along with an optional and equal length vector \eqn{h_t}. The function assumes rectangular approach conditions to compute approach area \eqn{A} if not superceded by the optional \code{A} argument, which also can be a vector.

The \code{weir3a5.sharpcrest()} function also permits optional vectors of \eqn{L} and \eqn{b/B} (by the argument \code{contractratio}) so that tuning of the weir-computed discharge to a measured discharge potentially can be made. The crest length \eqn{L} can be used to increase discharge slightly by shortening in say the circumstances of a slightly downward sloping crest. The \eqn{b/B} can be used to decrease discharge by decreasing \eqn{k_c} in say the circumstance of an inlet that is rougher or has asperities that slightly increase the expected contraction and reduce flow efficiency. To clarify, the fact that \eqn{L} and \eqn{b/B} can be vectorized as optional arguments shows a mechanism by which tuning of the computational results to measured \eqn{Q} values can occur without replacing the fundamental nomographs and lookup tables of \acronym{TWRI3A5} for \eqn{k_c}, \eqn{k_t}, and \eqn{C}. In all cases, these coefficients can be superceded by user-specified scalars or vectors in various combinations.
}
\usage{
weir3a5.sharpcrest(h, ht=NULL, b=NULL, B=NULL, P=NULL, L=NULL,
                   r=0, A=NULL, alpha=1,
                   slopeus="vertical",
                   kc=NULL, kt=NULL, C=NULL,
                   contractratio=NULL,
                   extended=TRUE,
                   header="", resetkts=TRUE,
                   flowdigits=2, coedigits=3,
                   verbose=FALSE, eps=0.001, maxit=20)
}
\arguments{
  \item{h}{Mandatory scalar or vector of static heads \eqn{h} in feet on the weir;}
  \item{ht}{Optional scalar or vector of tail water heads \eqn{h_t} in feet on the weir;}
  \item{b}{Mandatory scalar width of weir crest \eqn{b} in feet normal to flow;}
  \item{B}{Mandatory scalar width (or top width) of approach channel \eqn{B} in feet. Technically, it is possible with arguments \code{contractratio} and \code{A} to bypass any computations normally involving \eqn{B}. This would be the mechanism to bypass the \eqn{B} as a scalar requirement;}
  \item{P}{Mandatory scalar height of weir crest \eqn{P} in feet above channel bed;}
  \item{L}{Optional scalar or vector of lengths \eqn{L} in feet of broad-crested weir in direction of flow;}
  \item{r}{Optional scalar radius of curvature \eqn{r} in feet on the vertical abutments at inlet of weir crest;}
  \item{A}{Optional scalar or vector of approach cross-section area \eqn{A} in square feet for each \eqn{h} that supersedes the rectangular channel computation \eqn{A=(h+P)B};}
  \item{alpha}{Optional scalar or vector of velocity head correction term \eqn{\alpha} dimensionless. The default is unity (\eqn{\alpha=1}), which is most certainly appropriate for the vast majority of weir computations;}
  \item{slopeus}{String signifying the approach embankment slope in the format \dQuote{\var{hz}:\var{vt}}, thus, slope is defined as the ratio of the horizontal \var{hz} to vertical distance \var{vt}. (This is opposite of the more common convention for the trigometric function \code{tan()}.) The string \dQuote{vertical} must be provided as the value for \code{slopeus} for vertical slopes;}
  \item{kc}{Contraction coefficient \eqn{k_c}, if provided, supercedes nomograph lookup and interpolation by \eqn{h/P} and \eqn{b/B}. Optionally, this coefficient may be a vector;}
  \item{kt}{Coefficient for submergence adjustment, if provided, supercedes nomograph lookup and interpolation by \eqn{H/P} and \eqn{h_t/P}. Optionally, this coefficient may be a vector;}
  \item{C}{Discharge coefficient, if provided, supercedes nomograph lookup and interpolation by \eqn{h/L} and \code{slopeus}. Optionally, this coefficient may be a vector;}
  \item{contractratio}{Optional vector of user specified contraction ratios, if provided, supercedes use of \eqn{b/B}. For example, \code{b.over.B[i] <- contractratio[i]};}
  \item{extended}{A logical that controls the contents of the data frame on return;}
  \item{header}{A string (usually) or any other content to add to the \code{attributes()} of the returned data frame under the non-original label name of \code{header};}
  \item{resetkts}{A logical controlling whether interpolated \eqn{k_t > 1} values are reset to \eqn{k_t = 1} and so  diverges slightly from \acronym{TWRI3A5} (fig.4);}
  \item{flowdigits}{The number of digits to report on flow, velocity head, total head, computed \eqn{h_t/H}, and computed \eqn{H/P};}
  \item{coedigits}{The number of digits to report on weir coefficients;}
  \item{verbose}{A logical controlling intermediate messages. This might be reserved for development work and no verbose output in a released version of \pkg{weirs} could occur;}
  \item{eps}{An absolute error of discharge for convergence in cubic feet per second; and}
  \item{maxit}{Maximum number of iterations for the computation of the total head from summation of static and velocity head \eqn{H = h + \alpha v^2/2g} for the final \eqn{Q_H} in item \code{flow} of the returned data frame.}
}
\value{
  An R \code{data.frame()} is returned and the \code{extended=TRUE} version is described below:
  \item{head}{Echoed \eqn{h} on the input in feet;}
  \item{flow}{Flow \eqn{k_t Q_H} in cubic feet per second based on total head \eqn{H};}
  \item{delta}{First order difference of \eqn{k_t Q_H};}
  \item{flowfree}{Flow \eqn{Q_H} in cubic feet per second using free flow conditions, \eqn{h_t = 0};}
  \item{flowo}{Flow \eqn{Q_h} in cubic feet per second using free flow conditions, \eqn{h_t = 0} based on static head \eqn{h};}
  \item{error}{Absolute convergence error \eqn{\epsilon} of \eqn{Q_H} in cubic feet per second ;}
  \item{velhead}{Velocity head \eqn{v_o = v^2/2g = (Q_H/A)^2/2g} in feet;}
  \item{Hfree}{Total head \eqn{H = h + v_o} in feet;}
  \item{ht}{Echoed \eqn{h_t} on the input in feet;}
  \item{L}{Echoed \eqn{L} in feet;}
  \item{b.over.B}{Echoed \eqn{b/B};}
  \item{h.over.L}{Echoed \eqn{h/L};}
  \item{h.over.P}{Echoed \eqn{h/P};}
  \item{ht.over.H}{Computed \eqn{h_t/H};}
  \item{H.over.P}{Computed \eqn{H/P};}
  \item{C}{Discharge coefficient \eqn{C};}
  \item{kc}{Contraction coefficient \eqn{k_c};}
  \item{kt}{Coefficient to adjust for submergence \eqn{k_t}. Note that interpolated values \eqn{k_t > 1} are set to \eqn{k_t = 1}, if \code{resetkts=TRUE}, because \code{weir3a5.sharpcrest()} uses iteration to determine \eqn{H}. This practice diverges slightly from \acronym{TWRI3A5} (fig.4);}
  \item{message}{Messages concerning the computation of \eqn{Q} for each value of \eqn{h}; and}
  \item{source}{\code{weir3a5.sharpcrest}.}

The \code{extended=FALSE} version is restricted to the most salient items including \eqn{k_t Q_H}, \eqn{Q_H}, \eqn{Q_h}, \eqn{v_o}, \eqn{C}, \eqn{k_c}, and \eqn{k_t}.
}
\note{
The \code{weir3a5.sharpcrest()} function will \code{stop()} under conditions of unspecified or implausible \eqn{L}, \eqn{B}, and \eqn{P} as well as incompatibility of \eqn{b} and \eqn{B}, such as \eqn{B<b}. This function will also \code{stop()} if the length of the vector arguments or optional vector arguments do not match the length of \eqn{h}. The only exception is that if \eqn{h_t} is not specified, then internally it is treated a vector of length \eqn{h} having values of zero. There are other conditions that will cause the function to stop and consultation of the \code{if()} statements at the beginning of the function is recommended.

When the \code{weir3a5.sharpcrest()} function encounters non-stopping errors or warnings, it silently continues with error reporting in the \code{message} item in the returned data frame. This behavior is considered a feature and necessary to support the return of the data frame. The message states are: \enumerate{

\item If \eqn{h/P > 5}, then \eqn{C} has much uncertainty and \code{NA} is returned for all items;

\item If \eqn{h} is zero, then zero is returned for all \eqn{Q}, \eqn{\epsilon}, and \eqn{v_o} and \code{NA} is returned for others;

\item If a given \eqn{h} tests as too low for sharp-crested weir flow and hence the weir is functioning as broad-crested, then \code{NA} is returned for all items; however, for very shallow approach embankment slopes (\eqn{>1}), then critical \eqn{h/L=2.4} is used for all \eqn{h/P} and such weirs with \eqn{h/L < 2.4} are treated as broad-crested;

\item If the contraction ratio \eqn{b/B} is too small (\eqn{b/B < 0.20}), then too much contraction is concluded and \code{NA} is returned for all items;

\item If the upstream embankment slope is too shallow (\eqn{> 1}), then \eqn{C} is indeterminant and \code{NA} is returned for all items;

\item If nonconvergence occurs or estimated \eqn{Q_H} goes to infinity (supercritical approach or choking), then \code{NA} is returned for all \eqn{Q}, \eqn{\epsilon}, and \eqn{v_o}, but the estimated \eqn{C}, \eqn{k_c}, and \eqn{k_t} are returned;

\item If \eqn{h_t/H > 0.95} by \eqn{H} from free flow conditions, then too much submergence for \eqn{k_t} computation, and;

\item If no problems were detected, then \code{ok} is the message.
}

The conditions important for \eqn{k_t} computation are:
\enumerate{

\item If \eqn{h_t/H > 0.95} for total \eqn{H} for free-flow (\eqn{h_t=0}) conditions, then too much submergence is concluded and \eqn{k_t} is \code{NA} and hence \code{flow} is \code{NA};

\item If \eqn{h_t = 0}, then \eqn{k_t = 1} and \code{flow} is equal to \code{flowfree};


\item If \eqn{H/P < 0.20}, then \eqn{k_t} can not be computed and is \code{NA} and hence \code{flow} is equal to \code{NA};

\item If \eqn{H/P > 2}, then \eqn{k_t} can not be computed and is \code{NA} and hence \code{flow} is equal to \code{NA};

\item If \eqn{k_t > 1}, then \eqn{k_t = 1} by resetting dependent on the \code{resetkts} logical argument. This practice differs from 
\acronym{TWRI3A5}, but prevents submergence from producing more \eqn{Q} than free-flow conditions. The difference is that this function uses iteration to solve for the total head for the free-flow conditions and not a single computation step as seemingly implied in \acronym{TWRI3A5}.
}


The influence of abutment rounding by the ratio \eqn{r/b > 0} on \eqn{k_c} is accommodated by prorating between (1) \eqn{k_c} from \eqn{h/P} and \eqn{b/B} or user-specified \eqn{k_c} and (2) \eqn{k_c = 1} unless \eqn{r/b > 0.12} for which \eqn{k_c = 1}.

Nomograph lookup and interpolation is made throughout the computations. The linear interpolating \code{approx()} function is used for all interpolation. Most commonly, a form of bilinear interpolation is made. First, the two bounding curves for a given condition are interpolated in the horizontal direction and then the resulting two values are interpolated in the vertical. The horizontal interpolation by \code{approx()} explicitly uses the \code{rule=2}, which means that extrapolation to the left and right using the respective end point is made. In other words, the nomographs (and tables) are flat lined when extrapolation is needed. Within the code, the horizontal interpolations can be identified by \code{rule=2} and the vertical interpolations lack the \code{rule} argument. Finally, the nomographs are in the hashed environment \env{.weir.nomographs}, which sources from the file \file{sysdata.rda} of the package. The file \file{./inst/Nomographs4R/nomographs.R} is used to create the \file{sysdata.rda} file.
}
\references{
Hulsing, Harry, 1967, Measurement of peak discharge at dams by indirect methods: U.S. Geological Survey Techniques of Water-Resources Investigations, Book 3, Chapter A5, 29 p., \url{http://pubs.usgs.gov/twri/twri3-a5/}
}
\author{W. Asquith with digitizing of nomograph contributions by W. Miller}
\seealso{\code{\link{weir.sharpcrest}}}
\examples{

weir3a5.sharpcrest(0.45, L=0.125, P=0.32, b=5.81, B=5.81)


h <- seq(0.15,0.64,by=.01)
Qo <- weir3a5.sharpcrest(h, L=0.125, P=0.32, b=5.81, B=5.81)
print(Qo)

ht <- seq(0.15,0.64,by=.01)/2
weir3a5.sharpcrest(h, ht=ht, L=0.125, P=0.32, b=5.81, B=5.81)

plot(Qo$flow, Qo$head, type="l", log="xy")
Q <- weir3a5.sharpcrest(h, ht=0.21*h, L=0.125, P=0.32, b=5.81, B=5.81)
lines(Q$flow, Q$head, lty=2)
Q <- weir3a5.sharpcrest(h, ht=0.4*h, L=0.125, P=0.32, b=5.81, B=5.81)
lines(Q$flow, Q$head, lty=2)
Q <- weir3a5.sharpcrest(h, ht=0.6*h, L=0.125, P=0.32, b=5.81, B=5.81)
lines(Q$flow, Q$head, lty=2)
Q <- weir3a5.sharpcrest(h, ht=0.8*h, L=0.125, P=0.32, b=5.81, B=5.81)
lines(Q$flow, Q$head, lty=2)


}
\keyword{misc}
