use_aclu_pr_template <- function(type = "analysis", repo = "."){

  pr_file <- pull_resources(type = type, "pull_request_template.md")
  add_github_folder(repo = repo)
  fs::file_copy(path = pr_file,
                new_path = file.path(repo,".github","pull_request_template.md")
                )
  done_line(glue::glue("Pull request template applied to repository"))

  return(invisible())
}
