github_repo_spec <- usethis:::github_repo_spec
github_token <- usethis::github_token

new_issue_label <- function(label,
                            icon = NULL,
                            description = NULL,
                            colour = NULL,
                            examples = NULL
){

  if(!is.null(icon)){
    icon <- get_emoji_github(icon)
  } else {
    icon <- NA_character_
  }

  if(is.null(description))
    description <- NA_character_
  if(is.null(colour))
    colour <- NA_character_
  if(is.null(examples))
    examples <- NA_character_
  if(length(examples) > 1)
    examples <- glue::glue_collapse(examples, sep = "; ")

  res <- data.frame(label = label,
             icon = icon,
             description = description,
             colour = colour,
             examples = examples,
             stringsAsFactors = FALSE
             )

  return(res)
}

base_gh <- function(repo_spec = github_repo_spec(),
                    auth_token = github_token(),
                    host = NULL
){

  #straight from usethis::use_github_labels
  if (missing(repo_spec)) {
    usethis:::check_uses_github()
  }
  usethis:::check_github_token(auth_token)
  gh <- function(endpoint, ...) {
    out <- gh::gh(endpoint, ..., owner = usethis:::spec_owner(repo_spec),
                  repo = usethis:::spec_repo(repo_spec), .token = auth_token,
                  .api_url = host, .send_headers = c(Accept = "application/vnd.github.symmetra-preview+json"))
    if (identical(out[[1]], "")) {
      list()
    }
    else {
      out
    }
  }

  return(gh)
}

delete_issue_labels <- function(labels,
                               repo_spec = github_repo_spec(),
                               auth_token = github_token(),
                               host = NULL){

  gh <- base_gh(repo_spec,auth_token,host)
  purrr::walk(labels,
              .f = ~gh("DELETE /repos/:owner/:repo/labels/:name",
                        name = .x))
}

get_labelled_issues <- function(label,
                                repo_spec = github_repo_spec(),
                                auth_token = github_token(),
                                host = NULL){

  gh <- base_gh(repo_spec,auth_token,host)
  issues <- gh("GET /repos/:owner/:repo/issues",
               labels = label)

  return(issues)
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
