\name{weir3a5.broadcrest}
\alias{weir3a5.broadcrest}
\concept{hydraulics}
\concept{water}
\concept{weir}
\title{ Compute Open-Channel Flow over Broad-Crested Weir by TWRI3A5 }
\description{
Compute open-channel flow (discharge) over a broad-crested weir in strict accordance with Hulsing (1967) [\acronym{TWRI3A5}]. The weir crest of opening (width) \eqn{b} in feet is \eqn{P} feet above the channel bottom and \eqn{L} feet long in the flow direction. A rectangular approach channel is specified by width \eqn{B}, but the area of the channel (and hence rectangular assumption) can be bypassed by function arguments, although \eqn{B} is used in the contraction ratio \eqn{b/B} unless this ratio is superceded. For the \code{weir3a5.broadcrest()} function, the computations are exclusively based on the foot-second unit system and careful adherance by the user is required as not all \dQuote{coefficients} are dimensionless.

The discharge equation for an acceptable tail-water condition \eqn{h_t} for a weir is
\deqn{Q = k_c k_R k_s C b H^{1.5}}{Q = kc kr C b H^1.5}
where \eqn{Q} is discharge in cubic feet per second, \eqn{k_c} is the contraction coefficient that also is a function of the abutment rounding \eqn{r}, \eqn{k_R} is the approach rounding coefficient that is a function of the approach crest rounding \eqn{R}, \eqn{k_s} is the downstream embankment slope coefficient, \eqn{C} is the discharge coefficient, \eqn{b} is the width in feet of the weir crest, and \eqn{H} is total head in feet on the weir, which is computed by
\deqn{H = h + v_o = h + \alpha v^2/2g}{H = h + alpha * v^2/2g}
where \eqn{h} is static head in feet on the weir, \eqn{v_o} is velocity head in feet in the approach section, \eqn{v} is mean velocity in feet per second in the section computed by \eqn{v=Q/A} for cross section area \eqn{A} in square feet, which by default is computed by \eqn{A=(h + P)B}, but can be superceded. The quantity \eqn{g} is the acceleration of gravity and is hardwired to 32.2 feet per square second. The dimensionless quantity \eqn{\alpha} permits accommodation of a velocity head correction that is often attributable to cross section subdivision. The \eqn{\alpha} is outside the scope of this documentation, is almost always \eqn{\alpha=1}, and is made available as an argument for advanced users.

The \code{weir3a5.broadcrest()} function is vectorized meaning that optional vectors of \eqn{h} can be specified along with an optional and equal length vector \eqn{h_t}. The function assumes rectangular approach conditions to compute approach area \eqn{A} if not superceded by the optional \code{A} argument, which also can be a vector.

The \code{weir3a5.broadcrest()} function also permits optional vectors of \eqn{L} and \eqn{b/B} (by the argument \code{contractratio}) so that tuning of the weir-computed discharge to a measured discharge potentially can be made. The crest length \eqn{L} can be used to increase discharge slightly by shortening in say the circumstances of a slightly downward sloping crest. (Such potential \dQuote{crest} sloping is distinct from the downstream embankment slope---do not confuse the two.)  The \eqn{b/B} can be used to decrease discharge by decreasing \eqn{k_R} in say the circumstance of an inlet that is rougher or has asperities that slightly increase the expected contraction. To clarify, the fact that \eqn{L} and \eqn{b/B} can be vectorized as optional arguments shows a mechanism by which tuning of the computational results to measured \eqn{Q} values can occur without replacing the fundamental nomographs and lookup tables of \acronym{TWRI3A5} for \eqn{k_c}, \eqn{k_R}, \eqn{k_s}, and \eqn{C}. In all cases, these coefficients can be superceded by user-specified scalars or vectors in various combinations.
}
\usage{
weir3a5.broadcrest(h, ht=NULL, b=NULL, B=NULL, P=NULL, L=NULL,
                   R=0, r=0, A=NULL, alpha=1,
                   slopeus="vertical", slopeds="vertical",
                   kc=NULL, kr=NULL, ks=NULL, C=NULL,
                   low.head.class=c("paved", "gravel"),
                   contractratio=NULL,
                   extended=TRUE,
                   flowdigits=2, coedigits=3,
                   verbose=FALSE, eps=0.001, maxit=20)
}
\arguments{
  \item{h}{Mandatory scalar or vector of static heads \eqn{h} in feet on the weir;}
  \item{ht}{Optional scalar or vector of tail water heads \eqn{h_t} in feet on the weir;}
  \item{b}{Mandatory width of weir crest \eqn{b} in feet normal to flow;}
  \item{B}{Mandatory width (or top width) of channel \eqn{B} in feet. Technically, it is possible with arguments \code{contractratio} and \code{A} to bypass any computations normally involving \eqn{B};}
  \item{P}{Mandatory Height of weir crest \eqn{P} in feet above channel bed;}
  \item{L}{Optional scalar or vector of lengths \eqn{L} in feet of broad-crested weir in direction of flow;}
  \item{R}{Optional radius of curvature \eqn{R} in feet of vertical upstream face;}
  \item{r}{Optional radius of curvature \eqn{r} in feet on the vertical abutments at inlet of weir crest;}
  \item{A}{Optional scalar or vector of approach cross-section area \eqn{A} in square feet for each \eqn{h} that supersedes the rectangular channel computation \eqn{A=(h+P)B};}
  \item{alpha}{Optional scalar or vector of velocity head correction term \eqn{\alpha} dimensionless. The default is unity (\eqn{\alpha=1}), which is most certainly appropriate for the vast majority of weir computations;}
  \item{slopeus}{String signifying the approach embankment slope in the format \dQuote{\var{hz}:\var{vt}}, thus, slope is defined as the ratio of the horizontal \var{hz} to vertical distance \var{vt}. (This is opposite of the more common convention for the trigometric function \code{tan()}.) The string \dQuote{vertical} must be provided as the value for \code{slopeus} for vertical slopes;}
  \item{slopeds}{String signifying the downstream embankment slope in the format \dQuote{\var{hz}:\var{vt}}, thus, slope is defined as the ratio of the horizontal \var{hz} to vertical distance \var{vt}. (This is opposite of the more common convention for the trigometric function \code{tan()}.) The string \dQuote{vertical} must be provided as the value for \code{slopeds} for vertical slopes;}
  \item{kc}{Contraction coefficient \eqn{k_c}, if provided, supercedes nomograph lookup and interpolation by \eqn{h/P} and \eqn{b/B}. Optionally, this coefficient may be a vector;}
  \item{kr}{Rounding coefficient \eqn{k_R}, if provided, supercedes tabular lookup and interpolation by \eqn{R/h}. Optionally, this coefficient may be a vector;}
  \item{ks}{Downstream embankment slope coefficient \eqn{k_s}, if provided supercedes tabular lookup and interpolation by \eqn{h/L} and downstream slope \code{slopeds}. Optionally, this coefficient may be a vector;}
  \item{C}{Discharge coefficient, if provided, supercedes nomograph lookup and interpolation by \eqn{h/L} and \code{slopeus}. Optionally, this coefficient may be a vector;}
  \item{low.head.class}{For \eqn{h/L < 0.1}, low head on the weir is concluded and alternative \eqn{C} nomograph and interpolation is made based on figure 23 of \acronym{TWRI3A5}. Use of the alternative \eqn{C} requires a \dQuote{paved} and \dQuote{gravel} classification in which total head \eqn{H} is used and not \eqn{h} as in the primary \eqn{C} nomographs. How well the paved classification applies to concrete, wood, and metal broad-crested weirs is not discussed in \acronym{TWRI3A5}. Finally, it is expected that most users can use (should use) the paved classification. More formal procedures for embankment flow are provided in \acronym{TWRI3A5};}
  \item{contractratio}{Optional vector of user specified contraction ratios, if provided, supercedes use of \eqn{b/B}. For example, \code{b.over.B[i] <- contractratio[i]};}
  \item{extended}{A logical that controls the content of the data frame on return;}
  \item{flowdigits}{The number of digits to report on flow and velocity head;}
  \item{coedigits}{The number of digits to report on weir coefficients;}
  \item{verbose}{A logical controlling intermediate messages. This might be reserved for development work and no verbose output in a released version of \pkg{weirs} could occur;}
  \item{eps}{An absolute error of discharge for convergence in cubic feet per second; and}
  \item{maxit}{Maximum number of iterations for the computation of the total head from summation of static and velocity head \eqn{H = h + \alpha v^2/2g} for the final \eqn{Q} in item \code{flow} of the returned data frame.}
}
\value{
  An R \code{data.frame()} is returned and the \code{extended=TRUE} version is described below:
  \item{head}{Echoed \eqn{h} on the input in feet;}
  \item{flow}{Flow \eqn{Q_H} in cubic feet per second based on total head \eqn{H};}
  \item{flowo}{Flow \eqn{Q_h} in cubic feet per second based on static head \eqn{h};}
  \item{error}{Absolute convergence error \eqn{\epsilon} in cubic feet per second ;}
  \item{velhead}{Velocity head \eqn{v_o = v^2/2g = (Q/A)^2/2g} in feet;}
  \item{ht}{Echoed \eqn{h_t} on the input in feet;}
  \item{H}{Total head \eqn{H = h + v_o};}
  \item{L}{Echoed \eqn{L} in feet;}
  \item{b.over.B}{Echoed \eqn{b/B};}
  \item{h.over.L}{Echoed \eqn{h/L};}
  \item{h.over.P}{Echoed \eqn{h/P};}
  \item{C}{Discharge coefficient \eqn{C};}
  \item{kc}{Contraction coefficient \eqn{k_c};}
  \item{kr}{Rounding coefficient \eqn{k_R};}
  \item{ks}{Downstream slope coefficient \eqn{k_s}; and}
  \item{message}{Messages concerning the computation of \eqn{Q} for each value of \eqn{h}.}

The \code{extended=FALSE} version is restricted to the most salient items including \eqn{Q_H}, \eqn{Q_h}, \eqn{v_o}, \eqn{C}, \eqn{k_c}, \eqn{k_R}, and \eqn{k_s}.
}
\note{
The \code{weir3a5.broadcrest()} function will \code{stop()} under conditions of unspecified or implausible \eqn{L}, \eqn{B}, and \eqn{P} as well as incompatibility of \eqn{b} and \eqn{B}, such as \eqn{B<b}. This function will also \code{stop()} if the length of the vector arguments or optional vector arguments do not match the length of \eqn{h}. The only exception is that if \eqn{h_t} is not specified, then internally it is treated a vector of length \eqn{h} having values of zero. There are other conditions that will cause the function to stop and consultation of the \code{if()} statements at the function beginning is recommended.

When the \code{weir3a5.broadcrest()} function encounters non-stopping errors or warnings, it silently continues with error reporting in the \code{message} item in the returned data frame. This behavior is considered a feature and necessary to support the return of the data frame. The message states are: \enumerate{
\item If \eqn{h_t} is too large, then submergence is assumed and \code{NA} is returned for all items. The evaluation of submergence is made if \eqn{h_t/h >= 0.85};

\item If \eqn{h} is zero, then zero is returned for \eqn{Q_H}, \eqn{Q_h}, \eqn{\epsilon}, and \eqn{v_o} and \code{NA} is returned for others;

\item If a given \eqn{h} tests as too high for broad-crested weir flow and hence the weir is functioning as sharp-crested, then \code{NA} is returned for all items; however, for very shallow approach embankment slopes (\eqn{>1}), then critical \eqn{h/L=2.4} is used for all \eqn{h/P}. Weirs with \eqn{h/L < 2.4} are treated as broad-crested;

\item If the contraction ratio \eqn{b/B} is too small (\eqn{b/B < 0.20}), then too much contraction is concluded and \code{NA} is returned for all items;

\item If the upstream embankment slope is too shallow (\eqn{>2}), then \eqn{C} is indeterminant and \code{NA} is returned for all items;

\item If the downstream embankment slope is too shallow (\eqn{>5}, then \eqn{k_s} is indeterminant and only the values for \eqn{C}, \eqn{k_c}, and \eqn{k_R} are returned;

\item If nonconvergence occurs or estimated \eqn{Q} goes to infinity (supercritical approach or choking), then \code{NA} is returned for all \eqn{Q}, \eqn{\epsilon}, and \eqn{v_o}, but the estimated \eqn{C}, \eqn{k_c}, \eqn{k_R}, and \eqn{k_s} are returned.

\item If no problems were detected, then \code{ok} is the message.
}

The influence of abutment rounding by the ratio \eqn{r/b > 0} on \eqn{k_c} is accommodated by prorating between (1) \eqn{k_c} from \eqn{h/P} and \eqn{b/B} or user-specified \eqn{k_c} and (2) unity unless \eqn{r/b > 0.10} for which \eqn{k_c = 1}.

Nomograph and tabular lookup and interpolation is made throughout the computations. The linear interpolating \code{approx()} function is used for all interpolation. Most commonly, a form of bilinear interpolation is made. First, the two bounding curves for a given condition are interpolated in the horizontal direction and then the resulting two values are interpolated in the vertical. The horizontal interpolation by \code{approx()} explicitly uses the \code{rule=2}, which means that extrapolation to the left and right using the respective end point is made. In other words, the nomographs (and tables) are flat lined when extrapolation is needed. In the code, the horizontal interpolations can be identified by \code{rule=2} and the vertical interpolations lack the \code{rule} argument. Finally, the nomographs are in the hashed environment \env{.weir.nomographs}, which sources from the file \file{sysdata.rda} of the package. The file \file{./inst/Nomographs4R/nomographs.R} is used to create the \file{sysdata.rda} file.
}
\references{
Hulsing, Harry, 1967, Measurement of peak discharge at dams by indirect methods: U.S. Geological Survey Techniques of Water-Resources Investigations, Book 3, Chapter A5, 29 p., \url{http://pubs.usgs.gov/twri/twri3-a5/}
}
\author{W.H. Asquith with digitizing of nomograph contributions by W.J. Miller}
\seealso{\code{\link{weir.broadcrest}}}
\examples{

# Simple, scalar inputs and results
weir.broadcrest(0.5, b=8, B=11, P=6, L=3.25);

# Vector of heads
weir.broadcrest(c(0.5,0.4,0.3), b=8, B=11, P=6, L=3.25);

# Vector of heads and "effective weir lengths"
# Nomograph TWRI3A5-fig7 is being tested here.
weir.broadcrest(  c(0.51, 0.53, 0.70),
                L=c(1,    1.1,  1.20), b=6.18, B=7.84, P=1.13);

# User specified contraction--superceds 8/11
# Nomograph TWRI3A5-fig3 is being tested here.
weir.broadcrest(0.5, b=8, B=11, contractratio=9/11, P=6, L=3.25);
weir.broadcrest(0.5, b=8, B=11, P=6, L=3.25); # compare to previous

# Randomly pick contraction ratios to span the nomograph
# Nomograph TWRI3A5-fig3 is being tested here.
n <- 30; bB <- sort(runif(n));
weir.broadcrest(rep(1,n), b=8, B=11, contractratio=bB, P=6, L=3.25);

# Randomly pick lengths and likely kick-off some sharp-crested messages
# Nomograph TWRI3A5-fig6 is being tested here. 
L <- sort(runif(n, min=1, max=30));
weir.broadcrest(rep(10,n), b=8, B=11, P=6, L=L);

# Flow estimate in the non-low.head.classification
# Nomograph TWRI3A5-fig23 is being tested here.
weir.broadcrest(.1, b=6, B=6, P=4, L=1);
# Slighly lower are a realistic step change in h. See how the C
# changes dramatically by  (TWRI3A5-fig23), but at 0.01 feet there
#is some smoothness in the result.
weir.broadcrest(.09, b=6, B=6, P=4, L=1);
# Now try extremely close to 0.10 feet
weir.broadcrest(.0999999, b=6, B=6, P=4, L=1);
# Now try switching from "paved" to "gravel" nomograph (TWRI3A5-fig23)
weir.broadcrest(.09, b=6, B=6, P=4, L=1, low.head.class="gravel");

# Nomograph TWRI3A5-fig7 is being tested here for upstream slope
weir.broadcrest(0.5, slopeus="3:1",     b=8, B=11, P=6, L=3.25);
weir.broadcrest(0.5, slopeus="2:1",     b=8, B=11, P=6, L=3.25);
weir.broadcrest(0.5, slopeus="1.999:1", b=8, B=11, P=6, L=3.25);
weir.broadcrest(0.5, slopeus="0.51:1",  b=8, B=11, P=6, L=3.25);
weir.broadcrest(0.5, slopeus="0.50:1",  b=8, B=11, P=6, L=3.25);
weir.broadcrest(0.5, slopeus="0.49:1",  b=8, B=11, P=6, L=3.25);
try(weir.broadcrest(0.5, slopeus="force-error", b=8, B=11, P=6, L=3.25));

# Nomograph TWRI3A5-p9 (table) is being tested here for
# various downstream slopes
weir.broadcrest(3.5, slopeds="1:1",    b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="2:1",    b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="2.5:1",  b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="3:1",    b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="3.5:1",  b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="4.99:1", b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="5:1",    b=6, B=11, P=6, L=3.25);
weir.broadcrest(3.5, slopeds="5.1:1",  b=6, B=11, P=6, L=3.25);


# Now configure some weirs for which kc, kr, ks, and C are all
# looked up starting with some (R)ounding and then some more
# (r)ounding and note the changes to kr
weir.broadcrest(3.5, slopeds="3.5:1",  R=0, b=6, B=11, P=6, L=3.25);
# change kr by crest rounding
weir.broadcrest(3.5, slopeds="3.5:1",  R=1, b=6, B=11, P=6, L=3.25);
# change kc by abutment rounding
weir.broadcrest(3.5, slopeds="3.5:1",  R=1, r=.5, b=6, B=11, P=6, L=3.25);
# Now force override of all coefficients
weir.broadcrest(3.5, slopeds="3.5:1",  R=1, r=.5, b=6, B=11, P=6, L=3.25,
                kc=0.95, kr=1.01, ks=.94, C=3.1);


# Now vectorize the coefficients
weir.broadcrest(rep(0.5,3), b=8, B=11, P=6, L=3.25, C=c(3, 3.1, 3.2),
    kc=c(0.95, 1, 1.05), kr=c(1, 1.03, 1.08), ks=c(0.99, 0.95, 0.90));


# Now create a rating curve
h <- seq(0.01,2,by=.01);
Q <- weir.broadcrest(h, b=8, B=11, P=6, L=3.25);
plot(Q$flow, Q$head, type="l", col=8, lwd=7,
     xlab="DISCHARGE, IN CUBIC FEET PER SECOND",
     ylab="HEAD ON WEIR, IN FEET");
lines(sort(Q$flow), Q$head, col=2, lty=2, lwd=3);

# Now take the Q, repeat the sort and then recompute the delta
ii <- order(Q$flow);
Q <- Q[ii,]; # sort the entire data frame
Q$delta <- c(NA, diff(Q$flow)); # recompute deltas
# This insures a monotonic increasing relations between h and Q
# even though it might not be as smooth as hand-guided
# interpolation would provide.
}
\keyword{misc}
