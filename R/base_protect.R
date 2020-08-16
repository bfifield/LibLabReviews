#' Branch Protection
#'
#' @param branch Branch in your project. Defaults to 'master'
#' @param overwrite Whether to overwrite existing protections if they exist
#' @param required_approving_review_count Number of required approving reviews on a pull request before merging. If <1 or `NA`, no requirement
#' @param required_linear_history Enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch.
#' Default false. For more information see [docs](https://help.github.com/github/administering-a-repository/requiring-a-linear-commit-history)
#' @param allow_force_pushes Permits force pushes to protected branch. Default false. For more information see [docs](https://help.github.com/en/github/administering-a-repository/enabling-force-pushes-to-a-protected-branch)
#' @param allow_deletions Allow deletions of the protected branch. Discouraged usage. Default false. For more information see [docs](https://help.github.com/en/github/administering-a-repository/enabling-force-pushes-to-a-protected-branch)
#' @param enforce_admins Enforce all configured restrictions for adminstrators. Defaults to false.
#' @param return_type In `get_branch_protection`, return either the full list response with 'verbose' or a boolean  with 'exists' if the branch is protected.
#' @param repo_spec Full text "owner/spec" text. Defaults to determining from your git files.
#' @param auth_token Github token. Defaults to detecting from Set.env but can use config.
#' @param host Passed on to gh api. Defaults to NULL
#'
#' @return invisibly returns API object
#' @export
#'
#' @examples
#' # Check first to see if master is protected
#' # Equivalent
#' is_master_protected()
#' get_branch_protection()
#'
#' # Default call - protect master branch requiring 1 reviewer
#' protect_branch()
#' protect_master()
#'
#' # Look at full settings of branch
#' get_branch_protection(return_type = "verbose")
#'
#' # Alternatives settings are included in additional optional features and can change protection settings with overwrite=FALSE
#' protect_branch("master",overwrite = TRUE, required_approving_review_count = 2, enforce_admins = FALSE)
#'
#' # See that branch is protected differently now
#' get_branch_protection(return_type = "verbose")
#'
protect_branch <- function(branch = "master",
                           overwrite = FALSE,
                           required_approving_review_count = 1,
                           required_linear_history = FALSE,
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
                   required_approving_review_count = dplyr::if_else(
                     required_approving_review_count < 1,
                     NA_integer_,
                     as.integer(required_approving_review_count),
                     NA_integer_
                 )
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

#' @rdname protect_branch
#' @export
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

#' @rdname  protect_branch
#' @export
is_master_protected <- function(repo_spec = github_repo_spec(), auth_token = github_token(),
                                host = NULL
){
  get_branch_protection(branch = "master", return_type = "exists",
                        repo_spec = repo_spec,
                        auth_token = auth_token,
                        host = host
                        )
}

#' @rdname protect_branch
#' @export
protect_master <- function(required_approving_review_count = 1,
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
