get_github_icons <- function(){

  r_emojis <- emo::jis
  r_emoji_names <- emo::ji_name %>%
    enframe(name = "exact_name", value = "emoji_symbol") %>%
    mutate(is_exact_name = TRUE)

  #todo - change to system.file packaeg based path(s)
  github_page <- jsonlite::read_json("inst/emojis.json",simplifyVector = TRUE) %>%
    enframe(name = "github_name", value = "png_url") %>%
    unnest(png_url) %>%
    mutate(github_txt = paste0(":",github_name,":"))

  r_emojis_all <- r_emojis %>%
    rowwise() %>%
    mutate(all_names = list(unique(c(name,keywords,aliases)))) %>%
    ungroup() %>%
    unnest(all_names)

  res <- github_page %>%
    left_join(
      r_emojis_all,
      by = c("github_name" = "all_names")
    ) %>%
    arrange(github_name) %>%
    left_join(
      r_emoji_names,
      by = c("github_name" = "exact_name")
    ) %>%
    rowwise() %>%
    mutate(names_prioritization = case_when(
      is_exact_name == TRUE ~ 1,
      github_name == name ~ 2,
      github_name %in% keywords & qualified == "fully-qualified" ~ 3,
      github_name %in% keywords ~ 4,
      github_name %in% aliases & qualified == "fully-qualified" ~ 5,
      github_name %in% aliases ~ 6,
      TRUE ~ 7
    )) %>%
    ungroup() %>%
    filter(emoji == emoji_symbol) %>%
    group_by(github_name) %>%
    mutate(tmp_min_priority = min(names_prioritization, na.rm = TRUE)) %>%
    ungroup() %>%
    filter(names_prioritization == tmp_min_priority) %>%
    select(-tmp_min_priority,-names_prioritization,-is_exact_name,-emoji_symbol) %>%
    arrange(desc(nchar(github_name))) %>%
    group_by(emoji) %>%
    sample_n(1) %>%
    ungroup()

  return(res)
}

get_emoji_github <- function(x){

  emo_ji <- emo::ji(x)
  github_icons <- get_github_icons() #TODO: Save as a dataset
  github_icon_filter <- filter(github_icons, emoji %in% emo_ji)

  if(length(emo_ji) != nrow(github_icon_filter))
      stop("emojis returned by emo::ji should equal those in th github_icons")

  emoji_names <- pull(github_icon_filter,github_txt)
  class(emoji_names) <- append("git_emoji",class(emoji_names))
  attr(emoji_names,"emoji") <- emo_ji

  return(emoji_names)
}

print.git_emoji <- function(x){

  for(i in 1:length(x)){
    cat(x[i], " - ", attr(x,"emoji")[i],"\n")
  }

}
