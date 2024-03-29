% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dynamac.R
\name{dynardl.simulation.plot}
\alias{dynardl.simulation.plot}
\title{Create a plot of a simulated response in a \code{\link{dynardl}} model}
\usage{
dynardl.simulation.plot(
  x,
  type = "area",
  response = "levels",
  bw = FALSE,
  last.period = NULL,
  tol = (abs(x$model$ymean) * 0.01),
  start.period = 1,
  abs.errors = "none",
  ylim = NULL,
  ylab = NULL,
  xlab = NULL,
  ...
)
}
\arguments{
\item{x}{a \code{dynardl} model with a simulation to be plotted}

\item{type}{whether the plot should be an area plot (\code{area}) or a spike plot (\code{spike})}

\item{response}{whether the plot of the response should be shown in levels of the dependent variable (\code{levels}), levels from the mean of the dependent variable (\code{levels.from.mean}), period-over-period changes in the dependent variable (\code{diffs}), the absolute value of the (decreasing) change in the dependent variable  in each time period due to the shock (\code{shock.effect.decay}), the sum of the period-over-period changes (\code{cumulative.diffs}), or the absolute value of the cumulative differences (where negative effects are treated as positive) (\code{cumulative.abs.diffs}). The default is \code{levels}}

\item{bw}{should the colors be in black and white (for publication)? The default is \code{FALSE}}

\item{last.period}{when deciding when to stop calculating the absolute value of the shocks to the dependent variable, you can specify a specific period in which to stop calculating absolute cumulative differences. Specify a \code{tol} or a \code{last.period}. If both are specified, \code{last.period} overrides \code{tol}}

\item{tol}{when deciding when to stop calculating the absolute value of the shocks to the dependent variable, you can specify the minimum amount of movement required to qualify as a non-noise change over time periods (for calculating absolute cumulative differences). The default is 0.1 percent of the mean of the dependent variable. Specify a \code{tol} or a \code{last.period}. If both are specified, \code{last.period} overrides \code{tol}}

\item{start.period}{which period of the simulation to begin the plot with. You can view the equilibriating behavior of the dependent variable, or you can skip forward in time (maybe to just before the shock). The default is \code{1} (the first period of the simulation)}

\item{abs.errors}{when calculating confidence for the absolute cumulative effect, should differences accumulate in each time time period (\code{cumulate}, which could be explosive if the error in the model is large), should differences be observed at each time (\code{within.period}, which will have smaller values in equilibrium than when changing), or should only the values be plotted (\code{none}). The default is \code{none}}

\item{ylim}{a user-defined y-limit to be used instead of the default (for instance, for shared axes)}

\item{ylab}{a user-defined y-label to be used instead of the default}

\item{xlab}{a user-defined x-label to be used instead of the default}

\item{...}{other arguments to be passed to the call to plot}
}
\value{
a plot of the simulated dynardl model
}
\description{
Create a plot of a simulated response in a \code{\link{dynardl}} model
}
\details{
When running \code{dynardl}, \code{simulate} must be \code{TRUE} so that there is a simulation to plot. For types \code{cumulative.diffs} and \code{cumulative.abs.diffs}, \code{fullsims} must be \code{TRUE} in the \code{dynardl} simulation
}
\examples{
# Using the ineq data in dynamac
# Shocking Income Top 10
# Not run: simulations are time-intensive to estimate as an example
\dontrun{
set.seed(1)
ardl.model <- dynardl(concern ~ incshare10 + urate, data = ineq, 
       lags = list("concern" = 1, "incshare10" = 1),
       diffs = c("incshare10", "urate"), 
       lagdiffs = list("concern" = 1),
       ec = TRUE, simulate = TRUE, range = 30,
       shockvar = "incshare10", fullsims = TRUE)

# Shows absolute levels
dynardl.simulation.plot(ardl.model)	
# Shows changes from mean level
dynardl.simulation.plot(ardl.model, response = "levels.from.mean")  
# Same plot, but with spikeplot
dynardl.simulation.plot(ardl.model, type = "spike", response = "levels.from.mean")  
# Grayscale plots
dynardl.simulation.plot(ardl.model, bw = TRUE)
}	 
}
\author{
Soren Jordan and Andrew Q. Philips
}
\keyword{utilities}
