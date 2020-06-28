convert_labels_template <- function(path){

  #todo - avoid lengthy github re-reads
  labels_list <- purrr::map_dfr(.x = path,
                           .f = ~new_issue_label(.x$name,
                                                 icon = .x$icon,
                                                 description = .x$description,
                                                 examples = .x$examples
                                                 )
                           )

  labels_coloured <- dplyr::filter(labels_list, !is.na(colour))
  labels_remaining <- dplyr::filter(labels_list,is.na(colour))
  if(nrow(labels_remaining) > 0){
    min_color <- unname(LibLabTemplates::aclu_colors("red"))
    med_color <- unname(LibLabTemplates::aclu_colors("blue"))
    max_color <- unname(LibLabTemplates::aclu_colors("green"))
    x <- seq(0, 1, length.out = nrow(labels_remaining))
    cols <- scales::gradient_n_pal(c(min_color,med_color,max_color))(x)
    labels_remaining$colour <- cols
  }
  res <- dplyr::bind_rows(labels_coloured,labels_remaining)

  return(res)
}

# todo: when labels get auto-deleted when this is run,
# they need to be reapplied if they get put back in
apply_issue_labels <- function(.labels_data,
                                repo_spec = github_repo_spec(),
                                auth_token = github_token(), #todo: replace with liblab config approach
                                host = NULL
                                  ){

  labels_df <- .labels_data %>%
    dplyr::mutate(label_final = paste(label,icon),
           colour_final = stringr::str_remove_all(colour,"#") %>% stringr::str_to_lower(),
           descriptions_final = description#glue::glue("{description} \n (eg {examples})")
           ) #descriptions

  #delete labels first to be sure
  delete_issue_labels(dplyr::pull(labels_df,label_final),
                      repo_spec = repo_spec, auth_token = auth_token, host = host
                      )

  usethis::use_github_labels(
    labels = dplyr::pull(labels_df,label_final),
    colours = tibble::deframe(dplyr::select(labels_df,label_final,colour_final)),
    descriptions = tibble::deframe(dplyr::select(labels_df,label_final,descriptions_final)),
    delete_default = TRUE,
    repo_spec = repo_spec,
    auth_token = auth_token,
    host = host
  )

  return(invisible())
}
