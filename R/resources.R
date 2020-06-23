## Resources
review_resources <- function(type = "analysis", ...) {

  type = match.arg(type)

  system.file("resources", type, ...,
              package = "LibLabReviews"
  )
}

issue_resources <- function(type = "analysis",...){

  type = match.arg(type)

  review_resources(type = type, "ISSUE_TEMPLATE",...)
}

pull_resources <- function(type = "analysis",...){

  type = match.arg(type)

  review_resources(type = type, "PULL_TEMPLATE",...)
}
