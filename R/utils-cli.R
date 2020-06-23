#' Print clean done text during project setup
#'
#' @param ... Any params usable by \code{\link[glue]{glue}}
#' @param .envir Environment
#'
#' @return invisible
#' @export
#'
#' @examples
#' done_line("wooo....bullets")
done_line <- function (..., .envir = parent.frame())
{
  out <- glue::glue(..., .envir = .envir)
  cli::cat_line(checkize(out))
}

#' Print clean warning text during project setup
#'
#' @param ... Any params usable by \code{\link[glue]{glue}}
#' @param .envir Environment
#'
#' @return invisible
#' @export
#'
#' @examples
#' warning_line("wooo....bullets")
warning_line <- function(..., .envir = parent.frame()){
  out <- glue::glue(..., .envir = .envir)
  cli::cat_line(Xize(out))
}

bulletize <- function (line, bullet = "*")
{
  paste0(bullet, " ", line)
}

checkize <- function(line){
  bulletize(line,bullet = crayon::green(clisymbols::symbol$tick))
}

Xize <- function(line){
  bulletize(line,bullet = crayon::red(clisymbols::symbol$cross))
}
