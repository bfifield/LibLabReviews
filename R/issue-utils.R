
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


