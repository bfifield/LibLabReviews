get_branch_protection <- function(branch = "master",
                                  return_type = c("exists","verbose"),
                                  repo_spec = github_repo_spec(),
                                  auth_token = github_token(),
                                  host = NULL
){

  return_type <- match.arg(return_type)
  gh <- base_gh(repo_spec,auth_token,host)
  safe_gh <- purrr::safely(gh)
  safe_res <- safe_gh("GET /repos/:owner/:repo/branches/:branch/protection",
                      owner = usethis:::spec_owner(repo_spec), repo = usethis:::spec_repo(repo_spec), branch = branch
  )

  if(!is.null(safe_res$error)){
    # Error
    if(safe_res$error$content$message == "Branch not protected"){
      if(return_type == "exists"){
        res <- FALSE
      } else {
        res <- safe_res$error
      }
    } else {
      stop(safe_res$error)
    }
  } else {
    if(return_type == "exists"){
      res <- TRUE
    } else {
      res <- safe_res$result
    }
  }

  return(res)
}

is_master_protected <- function(repo_spec = github_repo_spec(), auth_token = github_token(),
                                host = NULL
){
  get_branch_protection(branch = "master", return_type = "exists",
                        repo_spec = repo_spec,
                        auth_token = auth_token,
                        host = host
                        )
}

protect_branch <- function(branch = "master",
                                  overwrite = FALSE,
                                  required_approving_review_count = 1,
                                  required_linear_history = TRUE,
                                  allow_force_pushes = FALSE,
                                  allow_deletions = FALSE,
                                  enforce_admins = TRUE,
                                  repo_spec = github_repo_spec(),
                                  auth_token = github_token(),
                                  host = NULL
){

  gh <- base_gh(repo_spec,auth_token,host, accept_header = "application/vnd.github.luke-cage-preview+json")
  safe_gh <- purrr::safely(gh)
  owner = usethis:::spec_owner(repo_spec)
  repo = usethis:::spec_repo(repo_spec)

  #check if branch already has protection settings
  branch_status <- get_branch_protection(branch = branch,
                                             return_type = "exists",
                                             repo_spec = repo_spec, auth_token = auth_token, host = host
  )
  if(branch_status == TRUE){
    if(overwrite == TRUE){
      info_line(glue::glue("{branch} already has protection settings. Overwriting existing settings."))
    } else {
      stop(glue::glue("{branch} already has protection settings. To replace these change add `overwrite = TRUE`."))
    }
  }

  put_text <- glue::glue("PUT /repos/{owner}/{repo}/branches/{branch}/protection")
  res <- safe_gh(put_text,
               required_status_checks = NA,
               enforce_admins = enforce_admins,
               required_pull_request_reviews = list(
                 dismissal_restrictions = list(
                  users = list(),
                  teams = list()
                 ),
                 dismiss_stale_reviews = TRUE,
                 require_code_owner_reviews = FALSE,
                 required_approving_review_count = required_approving_review_count
                ),
               restrictions = NA,
               required_linear_history = required_linear_history,
               allow_force_pushes = allow_force_pushes,
               allow_deletions = allow_deletions
          )

  if(!is.null(res$error))
    stop(res$error)

  return(invisible(res$result))
}

protect_master_branch <- function(required_approving_review_count = 1,
                                  overwrite = TRUE,
                                  required_linear_history = TRUE,
                                  allow_force_pushes = FALSE,
                                  allow_deletions = FALSE,
                                  enforce_admins = TRUE,
                                  repo_spec = github_repo_spec(),
                                  auth_token = github_token(),
                                  host = NULL){

  protect_branch(
    branch = "master",
    overwrite = overwrite,
    required_approving_review_count = 1,
    required_linear_history = TRUE,
    allow_force_pushes = FALSE,
    allow_deletions = FALSE,
    enforce_admins = TRUE,
    repo_spec = github_repo_spec(),
    auth_token = github_token(),
    host = NULL
  )

}
