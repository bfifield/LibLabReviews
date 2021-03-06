% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resources.R
\name{review_resources}
\alias{review_resources}
\alias{issue_resources}
\alias{pull_resources}
\alias{label_resources}
\title{Review Resources}
\usage{
review_resources(type = "analysis", ...)

issue_resources(type = "analysis", ...)

pull_resources(type = "analysis", ...)

label_resources(type = "analysis", ...)
}
\arguments{
\item{type}{the type of resource you are selecting. A limited option set.}

\item{...}{Additional arguments passed on to `system.file` function in LibLabReviews}
}
\value{
The correct file path for the associated resource
}
\description{
This function series provides easy file access
code for resources in the `LibLabReviews` package.
}
\examples{
#get file path for the generic pull request template
pull_resources(type = "analysis", "pull_request_template.md")
}
