#' ACLU Review Template
#'
#' Apply ACLU Analytics team review templates to your github repository
#' to help standardize reviews and ensure quality and accuracy of our work
#'
#' @param type Type of repository. Defaults to "analysis" which is the only fully built out template in base version
#' @param repo Repository. Defaults to "." - base path. We use `repo` instead of `path` here to align with `git2r` standards.
#'
#' @return invisible. Provides cli based messages as completes
#' @export
#'
#' @examples
#' # apply all of the template items
#' use_aclu_review_template()
#'
#' # apply the PR template to the repository
#' use_aclu_pr_template()
#'
#' # apply issue templates to the repository
#' use_aclu_issue_template()
#'
#' # apply labels to the repository
#' use_aclu_label_template()
#'
use_aclu_review_template <- function(type = "analysis", repo = "."){

  use_aclu_pr_template(type = type, repo = repo)
  use_aclu_issue_template(type = type, repo = repo)
  use_aclu_label_template(type = type, repo = repo)

  return(invisible())
}

#' @export
#' @rdname use_aclu_review_template
use_aclu_pr_template <- function(type = "analysis", repo = "."){

  pr_file <- pull_resources(type = type, "pull_request_template.md")
  add_github_folder(repo = repo)
  special_file_copy(path = pr_file,
                new_path = file.path(repo,".github","pull_request_template.md")
                )
  done_line(glue::glue("Pull request template applied to repository"))

  return(invisible())
}

#' @export
#' @rdname use_aclu_review_template
use_aclu_issue_template <- function(type = "analysis", repo = "."){

  resources <- issue_resources(type = type)
  issue_files <- fs::dir_ls(resources, glob = "*.md")
  issue_config <- fs::dir_ls(resources, glob = "*.yml")
  add_github_folder(repo = repo)
  issue_template_path <- file.path(repo,".github","ISSUE_TEMPLATE")
  fs::dir_create(path = issue_template_path)
  purrr::walk(c(issue_files,issue_config), ~ special_file_copy(path = .x, new_path = issue_template_path))
  done_line(glue::glue("Issue templates applied to repository"))

  return(invisible())
}

#' @export
#' @rdname use_aclu_review_template
use_aclu_label_template <- function(type = "analysis", repo = "."){

  type <- match.arg(type)
  conf_file_path <- file.path(label_resources(type = type),"config.yml")
  add_github_folder(repo = repo)
  label_template_path <- file.path(repo,".github","LABEL_TEMPLATE")
  fs::dir_create(path = label_template_path)
  special_file_copy(path = conf_file_path, new_path = label_template_path)
  done_line(glue::glue("Label templates added to .github folder"))
  conf_file <- yaml::read_yaml(file = file.path(label_template_path,"config.yml"))
  labels_df <- convert_labels_template(conf_file)
  apply_issue_labels(labels_df)
  done_line(glue::glue("Label templates in .github folder applied to repository"))

  return(invisible())
}
