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
