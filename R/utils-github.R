github_repo_spec <- usethis:::github_repo_spec
github_token <- usethis::github_token

base_gh <- function(repo_spec = github_repo_spec(),
                    auth_token = github_token(),
                    host = NULL,
                    accept_header = "application/vnd.github.symmetra-preview+json"
){

  #straight from usethis::use_github_labels
  if (missing(repo_spec)) {
    usethis:::check_uses_github()
  }
  usethis:::check_github_token(auth_token)
  gh <- function(endpoint, ...) {
    out <- gh::gh(endpoint, ..., owner = usethis:::spec_owner(repo_spec),
                  repo = usethis:::spec_repo(repo_spec), .token = auth_token,
                  .api_url = host, .send_headers = c(Accept = accept_header))
    if (identical(out[[1]], "")) {
      list()
    }
    else {
      out
    }
  }

  return(gh)
}

get_aclu_repos <- function(org = "aclu-national", type = "private", team_slug = NULL,
                           repo_spec = github_repo_spec(),
                           auth_token = github_token(),
                           host = NULL
){

  gh <- base_gh(repo_spec,auth_token,host)
  gh_cmd <- "/orgs/:org/"
  args <- list(org = org, type = type)
  if(!is.null(team_slug)){
    gh_cmd <- paste0(gh_cmd,"teams/:team_slug/")
    args <- c(args, team_slug = team_slug)
  }
  gh_cmd <- paste0(gh_cmd,"repos")
  args <- c(endpoint = gh_cmd, args)
  repos <- do.call(gh, args = args)

  return(repos)
}

add_github_folder <- function(repo = "."){

  gh_exists <- fs::dir_exists(file.path(repo,".github"))
  if(!gh_exists){
    fs::dir_create(path = file.path(repo,".github"))
    done_line("Added .github folder to directory for templates")
  }

  return(invisible())
}
