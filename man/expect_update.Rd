% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expect.R
\name{expect_update}
\alias{expect_update}
\title{\code{testthat} expectation for a Shiny update}
\usage{
expect_update(app, output, ..., timeout = 3000, iotype = c("auto", "input",
  "output"))
}
\arguments{
\item{app}{A \code{\link{shinyapp}} object.}

\item{output}{Character vector, the name(s) of the output widgets
that are required to update for the test to succeed.}

\item{...}{Named arguments specifying updates for Shiny input
widgets.}

\item{timeout}{Timeout for the update to happen, in milliseconds.}

\item{iotype}{Type of the widget(s) to change. These are normally
input widgets.}
}
\description{
\code{testthat} expectation for a Shiny update
}
\examples{
\dontrun{
## https://github.com/rstudio/shiny-examples/tree/master/050-kmeans-example
app <- shinyapp$new("050-kmeans-example")
expect_update(app, xcol = "Sepal.Width", output = "plot1")
expect_update(app, ycol = "Petal.Width", output = "plot1")
expect_update(app, clusters = 4, output = "plot1")
}
}

