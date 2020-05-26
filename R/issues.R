
aclu_label_colors <- function(.x = get_aclu_labels()){

  aclu_labels_list <- .x
  aclu_labels_coloured <- filter(aclu_labels_list, !is.na(colour))
  aclu_labels_remaining <- filter(aclu_labels_list,is.na(colour))
  if(nrow(aclu_labels_remaining) > 0){
    min_color <- unname(LibLabTemplates::aclu_colors("red"))
    med_color <- unname(LibLabTemplates::aclu_colors("blue"))
    max_color <- unname(LibLabTemplates::aclu_colors("green"))
    x <- seq(0, 1, length.out = nrow(aclu_labels_remaining))
    cols <- scales::gradient_n_pal(c(min_color,med_color,max_color))(x)
    aclu_labels_remaining$colour <- cols
  }
  res <- bind_rows(aclu_labels_coloured,aclu_labels_remaining)

  return(res)
}

get_aclu_labels <- function(){

  #todo - avoid lengthy github re-reads
  labels_list <- bind_rows(
    new_issue_label("Data Accuracy",
                    icon = "microscope",
                    description = "Errors in raw or interim data which need to be checked",
                    examples = "Number of rows in a joined table looks like a fan out issue"
                    ),
    new_issue_label("Correctness of Approach",
                    icon = "crystal_ball",
                    description = "Issues in the approach or methods selected that may be a problem for the analysis",
                    examples = "The analyst used a linear regression on a binary outcome variable"
                    ),
    new_issue_label("Results Accuracy",
                    icon = "telescope",
                    description = "Problems or unexpected outcomes in the results from analyses",
                    examples = "Predictions in the out-of-sample period are greater than 10X all prior data for subgroup A"
    ),
    new_issue_label("Results Completeness",
                    icon = "gem",
                    description = "Expected outputs or figures are not produced that will be needed",
                    examples = "No histograms provided in exploratory analysis, notably no visuals of missingness to help us understand whether this is an issue."
    ),
    new_issue_label("Reproducibility",
                    icon = "ledger",
                    description = "The reviewer is struggling to reproduce core parts of the analysis",
                    examples = "When knitting an rmarkdown, it produces an error on my computer"
    ),
    new_issue_label("Coding Practices",
                    icon = "art",
                    description = "Coding practices or following of good standards that can be fixed",
                    examples = "A long script is built in which the same pieces are used repeatedly. Turn these into functions to prevent errors"
    ),
    new_issue_label("Readability",
                    icon = "book",
                    description = "Lack of commenting or struggling to understand code-as-written",
                    examples = "I don't understand what you're trying to do with lines 200 - 250. What does this mean?"
    ),
    new_issue_label("Performance",
                    icon = "hourglass",
                    description = "Improving how long something takes to run or general optimizations",
                    examples = "If you switch from running this in a loop to using vectorized code, it will make the function run faster."
    ),
    new_issue_label("Documentation",
                    icon = "pencil",
                    description = "Ensuring that code, especially completed projects, are well documented",
                    examples = "The README for the project is outdated. Can you update to explain the decisions we made and why?"
    ),
    new_issue_label("Enhancement Opportunities",
                    icon = "school_satchel",
                    description = "Opportunites or suggestions to improve the way someone accomplished something.",
                    examples = "If you used the leaflet library, you may be able to make your map interactive and easier to share instead of static."
    ),
    new_issue_label("Alternatives to Consider",
                    icon = "bulb",
                    description = "Ideas for a different approach or new analyses.",
                    examples = "Using tSNE and other dimensionality reduction techniques first may improve the clusters you've created, or at least help with visualizing them and how close/separated they are."
    )
  )

  return(labels_list)
}

delete_aclu_issue_labels <- function(repo_spec = github_repo_spec(),
                                     auth_token = github_token(), #todo: replace with liblab config approach
                                     host = NULL){



}

# todo: when labels get auto-deleted when this is run,
# they need to be reapplied if they get put back in
use_aclu_issue_labels <- function(repo_spec = github_repo_spec(),
                                  auth_token = github_token(), #todo: replace with liblab config approach
                                  host = NULL
                                  ){

  labels_df <- aclu_label_colors() %>%
    mutate(label_final = paste(label,icon),
           colour_final = stringr::str_remove_all(colour,"#") %>% stringr::str_to_lower(),
           descriptions_final = description#glue::glue("{description} \n (eg {examples})")
           ) #descriptions

  #delete labels first to be sure
  delete_issue_labels(pull(labels_df,label_final),
                      repo_spec = repo_spec, auth_token = auth_token, host = host
                      )

  usethis::use_github_labels(
    labels = pull(labels_df,label_final),
    colours = deframe(select(labels_df,label_final,colour_final)),
    descriptions = deframe(select(labels_df,label_final,descriptions_final)),
    delete_default = TRUE,
    repo_spec = repo_spec,
    auth_token = auth_token,
    host = host
  )

  return(invisible())
}
