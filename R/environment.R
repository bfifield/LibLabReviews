#' Create Reproducibility Receipt
#'
#' In our pull request template, the end of the template
#' provides a section for a "reproducibility receipt". The code
#' below provides that receipt that can be copy and pasted into all
#' pull requests.
#'
#' @param render Whether to render the github markdown results for preview in the viewer
#'
#' @return Invisible return of content. Content added to clipboard for copy and paste
#' @export
#'
#' @examples
#' reproducibility_receipt()
reproducibility_receipt <- function(render = TRUE){

  res <- list(md_repository(),md_platform_info(),md_pkg_info())
  outfile_md <- tempfile(fileext = ".md")
  outfile_html <- tempfile(fileext = ".html")
  writeLines(as.character(res),outfile_md)
  rmarkdown::render(outfile_md,output_file = outfile_html, clean = FALSE,
                    quiet = TRUE, encoding = "UTF-8")

  if(render == TRUE & rstudioapi::verifyAvailable()){
    rstudioapi::viewer(outfile_html)
  }

  out_lines <- readLines(outfile_md, encoding = "UTF-8")
  clipr::write_clip(out_lines)
  info_line("Reproducibility Receipt Written to Clipboard")

  return(invisible(out_lines))
}

details_wrap <- function(title, ...){

  glue::glue("<details><summary>{title}</summary><div>",
             ...,
             "\n</div></details>")

}

md_pkg_info <- function(){

  pkgs_info <- sessioninfo::package_info()

  res <- pkgs_info %>%
    as.data.frame() %>%
    dplyr::select(`package`,ondiskversion,loadedversion,date,source) %>%
    knitr::kable(format = "markdown",row.names = FALSE,caption = "Package Info") %>%
    as.character() %>%
    paste0(collapse = "\n") %>%
    details_wrap(title = "Packages",.)

  return(res)
}

md_platform_info <- function(){

  plfrm_info <- sessioninfo::platform_info()

  res <- tibble::enframe(plfrm_info) %>%
          tidyr::unnest(value) %>%
          tidyr::pivot_wider() %>%
          knitr::kable(format = "markdown",row.names = FALSE,caption = "Platform Info") %>%
          as.character() %>%
          paste0(collapse = "\n") %>%
          details_wrap(title = "Platform",.)

  return(res)
}

md_repository <- function(){

  repos <- capture.output(print(git2r::repository()))

  res <- repos %>%
    paste0(collapse = "</br>") %>%
    details_wrap(title = "Git",.)

  return(res)
}
