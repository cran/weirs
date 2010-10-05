\name{weirbos.broadcrest}
\alias{weirbos.broadcrest}
\concept{hydraulics}
\concept{water}
\concept{weir}
\title{ Compute Open-Channel Flow over Broad-Crested Weir by Bos (1989) }
\description{
Compute open-channel flow (discharge) over a broad-crested weir in accordance with Bos (1989) [\acronym{BOS}] with extension into the coefficients \eqn{k_c}, \eqn{k_R}, and \eqn{k_s} from Hulsing (1967). The weir crest of opening (width) \eqn{b} in feet is \eqn{P} feet above the channel bottom and \eqn{L} feet long in the flow direction. A rectangular approach channel is specified by width \eqn{B}, but the area of the channel (and hence rectangular assumption) can be bypassed by function arguments, although \eqn{B} is used in the contraction ratio \eqn{b/B} unless this ratio is superceded. For the \code{weirbos.broadcrest()} function, the computations are exclusively based on the foot-second unit system and careful adherance by the user is required.

The discharge equation for an acceptable tail-water condition \eqn{h_t} is
\deqn{Q = k_c k_R k_s C_v C b \frac{2}{3} \sqrt{\frac{2}{3}g} H^{1.5}}{Q = kc*kr*Cv*C*b*(2/3)*(2g/3)^0.5*H^1.5}
where \eqn{Q} is discharge in cubic feet per second, \eqn{k_c} is the contraction coefficient that also is a function of the abutment rounding \eqn{r}, \eqn{k_R} is the approach rounding coefficient that is a function of the approach crest rounding \eqn{R}, \eqn{k_s} is the downstream embankment slope coefficient, \eqn{C_v} is the approach velocity coefficient, \eqn{C} is the discharge coefficient, \eqn{b} is the width in feet of the weir crest, and \eqn{H} is total head in feet on the weir, which is computed by
\deqn{H = h + v_o = h + \alpha v^2/2g}{H = h + alpha * v^2/2g}
where \eqn{h} is static head in feet on the weir, \eqn{v_o} is velocity head in feet in the approach section, \eqn{v} is mean velocity in feet per second in the section computed by \eqn{v=Q/A} for cross section area \eqn{A} in square feet, which by default is computed by \eqn{A=(h + P)B}, but can be superceded. The quantity \eqn{g} is the acceleration of gravity and is hardwired to 32.2 feet per square second. The dimensionless quantity \eqn{\alpha} permits accommodation of a velocity head correction that is often attributable to cross section subdivision. The \eqn{\alpha} is outside the scope of this documentation, is almost always \eqn{\alpha=1}, and is made available as an argument for advanced users.

The discharge equation is solved for two conditions that consider the approach velocity head. First, the equation is solved as shown above for \eqn{H} through iteration and \eqn{C_v=1}. Second, the equation is solved using \eqn{h} and \eqn{C_v}, which is determined by nomograph lookup.

The \code{weirbos.broadcrest()} function is vectorized meaning that optional vectors of \eqn{h} can be specified along with an optional and equal length vector \eqn{h_t}. The function assumes rectangular approach conditions to compute approach area \eqn{A} if not superceded by the optional \code{A} argument, which also can be a vector.

The \code{weirbos.broadcrest()} function also permits optional vectors of \eqn{L} and \eqn{b/B} (by the argument \code{contractratio}) so that tuning of the weir-computed discharge to a measured discharge potentially can be made. The crest length \eqn{L} can be used to increase discharge slightly by shortening in say the circumstances of a slightly downward sloping crest. (Such potential \dQuote{crest} sloping is distinct from the downstream embankment slope---do not confuse the two.)  The \eqn{b/B} can be used to decrease discharge by decreasing \eqn{k_R} in say the circumstance of an inlet that is rougher or has asperities that slightly increase the expected contraction and reduce flow efficiency. To clarify, the fact that \eqn{L} and \eqn{b/B} can be vectorized as optional arguments shows a mechanism by which tuning of the computational results to measured \eqn{Q} values can occur without replacing the fundamental \eqn{C} and \eqn{C_v} nomographs of \acronym{BOS} and nomograph and lookup tables for \eqn{k_c}, \eqn{k_R}, and \eqn{k_s} of \acronym{TWRI3A5} (Hulsing, 1967). In all cases, these coefficients can be superceded by user-specified scalars or vectors in various combinations.
}
\usage{
weirbos.broadcrest(h, ht=NULL, b=NULL, B=NULL, P=NULL, L=NULL,
                   R=0, r=0, A=NULL, alpha=1,
                   slopeus="vertical", slopeds="vertical",
                   kc=NULL, kr=NULL, ks=NULL, C=NULL,
                   contractratio=NULL,
                   hhptest=TRUE, extended=TRUE,
                   header="",
                   flowdigits=2, coedigits=3,
                   verbose=FALSE, eps=0.001, maxit=20)
}
\arguments{
  \item{h}{Mandatory scalar or vector of static heads \eqn{h} in feet on the weir;}
  \item{ht}{Optional scalar or vector of tail water heads \eqn{h_t} in feet on the weir;}
  \item{b}{Mandatory scalar width of weir crest \eqn{b} in feet normal to flow;}
  \item{B}{Mandatory scalar width (or top width) of approach channel \eqn{B} in feet. Technically, it is possible with arguments \code{contractratio} and \code{A} to bypass any computations normally involving \eqn{B}. This would be the mechanism to bypass the \eqn{B} as a scalar restriction;}
  \item{P}{Mandatory scalar height of weir crest \eqn{P} in feet above channel bed;}
  \item{L}{Optional scalar or vector of lengths \eqn{L} in feet of broad-crested weir in direction of flow;}
  \item{R}{Optional scalar radius of curvature \eqn{R} in feet of vertical upstream face;}
  \item{r}{Optional scalar radius of curvature \eqn{r} in feet on the vertical abutments at inlet of weir crest;}
  \item{A}{Optional scalar or vector of approach cross-section area \eqn{A} in square feet for each \eqn{h} that supersedes the rectangular channel computation \eqn{A=(h+P)B};}
  \item{alpha}{Optional scalar or vector of velocity head correction term \eqn{\alpha} dimensionless. The default is unity (\eqn{\alpha=1}), which is most certainly appropriate for the vast majority of weir computations;}
  \item{slopeus}{String signifying the approach embankment slope in the format \dQuote{\var{hz}:\var{vt}}, thus, slope is defined as the ratio of the horizontal \var{hz} to vertical distance \var{vt}. (This is opposite of the more common convention for the trigometric function \code{tan()}.) The string \dQuote{vertical} must be provided as the value for \code{slopeus} for vertical slopes;}
  \item{slopeds}{String signifying the downstream embankment slope in the format \dQuote{\var{hz}:\var{vt}}, thus, slope is defined as the ratio of the horizontal \var{hz} to vertical distance \var{vt}. (This is opposite of the more common convention for the trigometric function \code{tan()}.) The string \dQuote{vertical} must be provided as the value for \code{slopeds} for vertical slopes;}
  \item{kc}{Contraction coefficient \eqn{k_c}, if provided, supercedes nomograph lookup and interpolation by \eqn{h/P} and \eqn{b/B}. Optionally, this coefficient may be a vector;}
  \item{kr}{Rounding coefficient \eqn{k_R}, if provided, supercedes tabular lookup and interpolation by \eqn{R/h}. Optionally, this coefficient may be a vector;}
  \item{ks}{Downstream embankment slope coefficient \eqn{k_s}, if provided supercedes tabular lookup and interpolation by \eqn{h/L} and downstream slope \code{slopeds}. Optionally, this coefficient may be a vector;}
  \item{C}{Discharge coefficient, if provided, supercedes nomograph lookup and interpolation by \eqn{h/L} and \code{slopeus}. Optionally, this coefficient may be a vector;}
  \item{hhptest}{Logical for test of \eqn{h/(h+P) \le 0.35} to follow Bos (1989) to determine \eqn{C}, but the test can be ignored with this logical argument;}
  \item{contractratio}{Optional vector of user specified contraction ratios, if provided, supercedes use of \eqn{b/B}. For example, \code{b.over.B[i] <- contractratio[i]};}
  \item{extended}{A logical that controls the contents of the data frame on return;}
  \item{header}{A string (usually) or any other content to add to the \code{attributes()} of the returned data frame under the non-original label name of \code{header};}
  \item{flowdigits}{The number of digits to report on flow, velocity head, and total head;}
  \item{coedigits}{The number of digits to report on weir coefficients;}
  \item{verbose}{A logical controlling intermediate messages. This might be reserved for development work and no verbose output in a released version of \pkg{weirs} could occur;}
  \item{eps}{An absolute error of discharge for convergence in cubic feet per second; and}
  \item{maxit}{Maximum number of iterations for the computation of the total head from summation of static and velocity head \eqn{H = h + \alpha v^2/2g} for the final \eqn{Q_H} in item \code{flow} of the returned data frame.}
}
\value{
  An R \code{data.frame()} is returned and the \code{extended=TRUE} version is described below:
  \item{head}{Echoed \eqn{h} on the input in feet;}
  \item{flow}{Flow \eqn{Q_H} in cubic feet per second based on total head \eqn{H};}
  \item{delta}{First order difference of \eqn{Q_H};}
  \item{flowo}{Flow \eqn{Q_h} in cubic feet per second based on static head \eqn{h};}
  \item{flowcv}{Flow \eqn{Q_{cv}} in cubic feet per second based on \eqn{C_v \ne 1} nomograph lookup by \eqn{h/L} and static head \eqn{h};}
  \item{error}{Absolute convergence error \eqn{\epsilon} of \eqn{Q_H} in cubic feet per second;}
  \item{velhead}{Velocity head \eqn{v_o = v^2/2g = (Q_H/A)^2/2g} in feet;}
  \item{H}{Total head \eqn{H = h + v_o};}
  \item{ht}{Echoed \eqn{h_t} on the input in feet;}
  \item{L}{Echoed \eqn{L} in feet;}
  \item{b.over.B}{Echoed \eqn{b/B};}
  \item{h.over.L}{Echoed \eqn{h/L};}
  \item{h.over.P}{Echoed \eqn{h/P};}
  \item{C}{Discharge coefficient \eqn{C};}
  \item{Cv}{Approach velocity coefficient;}
  \item{kc}{Contraction coefficient \eqn{k_c};}
  \item{kr}{Rounding coefficient \eqn{k_R};}
  \item{ks}{Downstream slope coefficient \eqn{k_s};}
  \item{message}{Messages concerning the computation of \eqn{Q} for each value of \eqn{h}; and}
  \item{source}{\code{weirbos.broadcrest}.}

The \code{extended=FALSE} version is restricted to the most salient items including \eqn{Q_H}, \eqn{Q_h}, \eqn{Q_{cv}}, \eqn{v_o}, \eqn{C}, \eqn{C_v}, \eqn{k_c}, \eqn{k_R}, and \eqn{k_s}.
}
\note{
The \code{weirbos.broadcrest()} function will \code{stop()} under conditions of unspecified or implausible \eqn{L}, \eqn{B}, and \eqn{P} as well as incompatibility of \eqn{b} and \eqn{B}, such as \eqn{B<b}. This function will also \code{stop()} if the length of the vector arguments or optional vector arguments do not match the length of \eqn{h}. The only exception is that if \eqn{h_t} is not specified, then internally it is treated a vector of length \eqn{h} having values of zero. There are other conditions that will cause the function to stop and consultation of the \code{if()} statements at the beginning of the function is recommended.

When the \code{weirbos.broadcrest()} function encounters non-stopping errors or warnings, it silently continues with error reporting in the \code{message} item in the returned data frame. This behavior is considered a feature and necessary to support the return of the data frame. The message states are: \enumerate{
\item If \eqn{h_t} is too large, then submergence is assumed and \code{NA} is returned for all items. The evaluation of submergence is made if \eqn{h_t/h \ge 0.66};

\item If \eqn{h/(h+P) \le 0.35} then \eqn{C} can be determined and computation progress, otherwise \code{NA} is returned for all items;

\item If \eqn{h} is zero, then zero is returned for \eqn{Q_H}, \eqn{Q_h}, \eqn{Q_{cv}}, \eqn{\epsilon}, and \eqn{v_o} and \code{NA} is returned for others;

\item If a given \eqn{h/L} tests as too high (\eqn{h/L < 1.5}) for broad-crested weir flow and hence the weir is functioning as sharp-crested, then \code{NA} is returned for all items. Weirs with \eqn{h/L < 0.08} are treated as low head, then \code{NA} is returned for all items;

\item If the contraction ratio \eqn{b/B} is too small (\eqn{b/B < 0.20}), then too much contraction is concluded and \code{NA} is returned for all items;

\item If the downstream embankment slope is too shallow (\eqn{>5}, then \eqn{k_s} is indeterminant and only the values for \eqn{C}, \eqn{k_c}, and \eqn{k_R} are returned;

\item If nonconvergence occurs or estimated \eqn{Q} goes to infinity (supercritical approach or choking), then \code{NA} is returned for all \eqn{Q}, \eqn{\epsilon}, and \eqn{v_o}, but the estimated \eqn{C}, \eqn{k_c}, \eqn{k_R}, and \eqn{k_s} are returned, and;

\item If no problems were detected, then \code{ok} is the message.
}

The influence of abutment rounding by the ratio \eqn{r/b > 0} on \eqn{k_c} is accommodated by prorating between (1) \eqn{k_c} from \eqn{h/P} and \eqn{b/B} or user-specified \eqn{k_c} and (2) \eqn{k_c = 1} unless \eqn{r/b > 0.10} for which \eqn{k_c = 1}.

Nomograph and tabular lookup and interpolation is made throughout the computations. The linear interpolating \code{approx()} function is used for all interpolation. Most commonly, a form of bilinear interpolation is made. First, the two bounding curves for a given condition are interpolated in the horizontal direction and then the resulting two values are interpolated in the vertical. The horizontal interpolation by \code{approx()} explicitly uses the \code{rule=2}, which means that extrapolation to the left and right using the respective end point is made. In other words, the nomographs (and tables) are flat lined when extrapolation is needed. Within the code, the horizontal interpolations can be identified by \code{rule=2} and the vertical interpolations lack the \code{rule} argument. Finally, the nomographs are in the hashed environment \env{.weir.nomographs}, which sources from the file \file{sysdata.rda} of the package. The file \file{./inst/Nomographs4R/nomographs.R} is used to create the \file{sysdata.rda} file.
}
\references{
Bos, M.G., 1989, Discharge measurement structures: International Institute for Land Reclamation and Improvement Publication 20, Wageningen, The Netherlands, 401 p. \url{http://content.alterra.wur.nl/Internet/webdocs/ilri-publicaties/publicaties/Pub20/pub20.pdf}

Hulsing, Harry, 1967, Measurement of peak discharge at dams by indirect methods: U.S. Geological Survey Techniques of Water-Resources Investigations, Book 3, Chapter A5, 29 p., \url{http://pubs.usgs.gov/twri/twri3-a5/}
}
\author{W. Asquith with digitizing of nomograph contributions by W. Miller}
\seealso{\code{\link{weir.broadcrest}}}
\examples{

# Simple, scalar inputs and results
weir.broadcrest(type="BOS", 0.5, b=8, B=11, P=6, L=3.25);

# Vector of heads
weir.broadcrest(type="BOS", c(0.5,0.4,0.3), b=8, B=11, P=6, L=3.25);

# Now compare two solutions by weirbos.broadcrest() to weir3a5.broadcrest()
h <- seq(0.01,1.5, by=0.001)
Qtank     <- weir3a5.broadcrest(h, b=7.97, B=10.97, P=1.125, L=3.76, flowdigits=4)
QtankbosA <- weirbos.broadcrest(h, b=7.97, B=10.97, P=1.125, L=3.76, flowdigits=4)
QtankbosB <- weirbos.broadcrest(h, b=7.97, B=10.97, P=1.125, L=3.76,
                                   hhptest=FALSE, flowdigits=4)
plot(Qtank$flow, h, type="l", col=8, lwd=6,
     xlab="FLOW, CFS", ylab="HEAD, FEET")
lines(QtankbosA$flow, h, col=2, lwd=4) # see the trunction in the red line
lines(QtankbosB$flow, h, col=3, lwd=2)

# See examples for weir3a5.broadcrest() for additional examples that
# explore higher complexity of argument settings, which test the
# nomographs for k_c, k_R, and k_s
}
\keyword{misc}
