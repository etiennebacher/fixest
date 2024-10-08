% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimation.R
\name{est_env}
\alias{est_env}
\title{Estimates a \code{fixest} estimation from a \code{fixest} environment}
\usage{
est_env(env, y, X, weights, endo, inst)
}
\arguments{
\item{env}{An environment obtained from a \code{fixest} estimation with \code{only.env = TRUE}. This is
intended for advanced users so there is no error handling: any other kind of input will
fail with a poor error message.}

\item{y}{A vector representing the dependent variable. Should be of the same length
as the number of observations in the initial estimation.}

\item{X}{A matrix representing the independent variables. Should be of the same dimension
as in the initial estimation.}

\item{weights}{A vector of weights (i.e. with only positive values). Should be of
the same length as the number of observations in the initial estimation. If identical
to the scalar 1, this will mean that no weights will be used in the estimation.}

\item{endo}{A matrix representing the endogenous regressors in IV estimations. It should
be of the same dimension as the original endogenous regressors.}

\item{inst}{A matrix representing the instruments in IV estimations. It should be of
the same dimension as the original instruments.}
}
\value{
It returns the results of a \code{fixest} estimation: the one that was summoned when
obtaining the environment.
}
\description{
This is a function advanced users which allows to estimate any \code{fixest} estimation from a
\code{fixest} environment obtained with \code{only.env = TRUE} in a \code{fixest} estimation.
}
\details{
This function has been created for advanced users, mostly to avoid overheads
when making simulations with \code{fixest}.

How can it help you make simulations? First make a core estimation with \code{only.env = TRUE},
and usually with \code{only.coef = TRUE} (to avoid having extra things that take time to compute).
Then loop while modifying the appropriate things directly in the environment. Beware that
if you make a mistake here (typically giving stuff of the wrong length),
then you can make the R session crash because there is no more error-handling!
Finally estimate with \code{est_env(env = core_env)} and store the results.

Instead of \code{est_env}, you could use directly \code{fixest} estimations too, like \code{feols},
since they accept the \code{env} argument. The function \code{est_env} is only here to add a
bit of generality to avoid the trouble to the user to write conditions
(look at the source, it's just a one liner).

Objects of main interest in the environment are:
\describe{
\item{lhs}{The left hand side, or dependent variable.}
\item{linear.mat}{The matrix of the right-hand-side, or explanatory variables.}
\item{iv_lhs}{The matrix of the endogenous variables in IV regressions.}
\item{iv.mat}{The matrix of the instruments in IV regressions.}
\item{weights.value}{The vector of weights.}
}

I strongly discourage changing the dimension of any of these elements, or else crash can occur.
However, you can change their values at will (given the dimension stay the same).
The only exception is the weights, which tolerates changing its dimension: it can
be identical to the scalar \code{1} (meaning no weights), or to something of the length the
number of observations.

I also discourage changing anything in the fixed-effects (even their value)
since this will almost surely lead to a crash.

Note that this function is mostly useful when the overheads/estimation ratio is high.
This means that OLS will benefit the most from this function. For GLM/Max.Lik. estimations,
the ratio is small since the overheads is only a tiny portion of the total estimation time.
Hence this function will be less useful for these models.
}
\examples{

# Let's make a short simulation
# Inspired from Grant McDermott bboot function
# See https://twitter.com/grant_mcdermott/status/1487528757418102787

# Simple function that computes a Bayesian bootstrap
bboot = function(x, n_sim = 100){
  # We bootstrap on the weights
  # Works with fixed-effects/IVs
  #  and with any fixest function that accepts weights

  core_env = update(x, only.coef = TRUE, only.env = TRUE)
  n_obs = x$nobs

  res_all = vector("list", n_sim)
  for(i in 1:n_sim){
    ## begin: NOT RUN
    ## We could directly assign in the environment:
    # assign("weights.value", rexp(n_obs, rate = 1), core_env)
    # res_all[[i]] = est_env(env = core_env)
    ##   end: NOT RUN

    ## Instead we can use the argument weights, which does the same
    res_all[[i]] = est_env(env = core_env, weights = rexp(n_obs, rate = 1))
  }

  do.call(rbind, res_all)
}


est = feols(mpg ~ wt + hp, mtcars)

boot_res = bboot(est)
coef = colMeans(boot_res)
std_err = apply(boot_res, 2, sd)

# Comparing the results with the main estimation
coeftable(est)
cbind(coef, std_err)





}
\author{
Laurent Berge
}
