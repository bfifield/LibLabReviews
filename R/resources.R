#' Review Resources
#'
#' This function series provides easy file access
#' code for resources in the `LibLabReviews` package.
#'
#' @param type the type of resource you are selecting. A limited option set.
#' @param ... Additional arguments passed on to `system.file` function in LibLabReviews
#'
#' @return The correct file path for the associated resource
#' @export
#' @examples
#' #get file path for the generic pull request template
#' pull_resources(type = "analysis", "pull_request_template.md")
review_resources <- function(type = "analysis", ...) {

  type = match.arg(type)

  system.file("resources", type, ...,
              package = "LibLabReviews"
  )
}

#' @export
#' @rdname review_resources
issue_resources <- function(type = "analysis",...){

  type = match.arg(type)

  review_resources(type = type, "ISSUE_TEMPLATE",...)
}

#' @export
#' @rdname review_resources
pull_resources <- function(type = "analysis",...){

  type = match.arg(type)

  review_resources(type = type, "PULL_TEMPLATE",...)
}
