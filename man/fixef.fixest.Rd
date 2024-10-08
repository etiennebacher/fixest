% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{fixef.fixest}
\alias{fixef.fixest}
\title{Extract the Fixed-Effects from a \code{fixest} estimation.}
\usage{
\method{fixef}{fixest}(
  object,
  notes = getFixest_notes(),
  sorted = TRUE,
  nthreads = getFixest_nthreads(),
  fixef.tol = 1e-05,
  fixef.iter = 10000,
  ...
)
}
\arguments{
\item{object}{A \code{fixest} estimation (e.g. obtained using \code{\link{feols}} or \code{\link{feglm}}).}

\item{notes}{Logical. Whether to display a note when the fixed-effects coefficients are
not regular.}

\item{sorted}{Logical, default is \code{TRUE}. Whether to order the fixed-effects by their names.
If \code{FALSE}, then the order used in the demeaning algorithm is used.}

\item{nthreads}{The number of threads. Can be: a) an integer lower than, or equal to,
the maximum number of threads; b) 0: meaning all available threads will be used;
c) a number strictly between 0 and 1 which represents the fraction of all threads to use.
The default is to use 50\% of all threads. You can set permanently the number
of threads used within this package using the function \code{\link{setFixest_nthreads}}.}

\item{fixef.tol}{Precision used to obtain the fixed-effects. Defaults to \code{1e-5}.
It corresponds to the maximum absolute difference allowed between two coefficients
of successive iterations. Argument \code{fixef.tol} cannot be lower
than \code{10000*.Machine$double.eps}. Note that this parameter is dynamically
controlled by the algorithm.}

\item{fixef.iter}{Maximum number of iterations in fixed-effects algorithm
(only in use for 2+ fixed-effects). Default is 10000.}

\item{...}{Not currently used.}
}
\value{
A list containing the vectors of the fixed effects.

If there is more than 1 fixed-effect, then the attribute \dQuote{references} is created.
This is a vector of length the number of fixed-effects, each element contains the number
of coefficients set as references. By construction, the elements of the first
fixed-effect dimension are never set as references. In the presence of regular
fixed-effects, there should be Q-1 references (with Q the number of fixed-effects).
}
\description{
This function retrieves the fixed effects from a \code{fixest} estimation. It is useful only
when there are one or more fixed-effect dimensions.
}
\details{
If the fixed-effect coefficients are not regular, then several reference points need to
be set: this means that the fixed-effects coefficients cannot be directly interpreted.
If this is the case, then a warning is raised.
}
\examples{

data(trade)

# We estimate the effect of distance on trade => we account for 3 fixed-effects
est_pois = femlm(Euros ~ log(dist_km)|Origin+Destination+Product, trade)

# Obtaining the fixed-effects coefficients:
fe_trade = fixef(est_pois)

# The fixed-effects of the first fixed-effect dimension:
head(fe_trade$Origin)

# Summary information:
summary(fe_trade)

# Plotting them:
plot(fe_trade)

}
\seealso{
\code{\link{plot.fixest.fixef}}. See also the main estimation functions \code{\link{femlm}}, \code{\link{feols}}
or \code{\link{feglm}}. Use \code{\link{summary.fixest}} to see the results with the appropriate
standard-errors, \code{\link{fixef.fixest}} to extract the fixed-effect coefficients, and
the function \code{\link{etable}} to visualize the results of multiple estimations.
}
\author{
Laurent Berge
}
