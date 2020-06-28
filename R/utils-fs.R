special_file_copy <- function(path, new_path, overwrite = FALSE){

  if(overwrite == TRUE) {
    fs::file_copy(path = path, new_path = new_path, overwrite = overwrite)
  } else {
    new <- fs::path_expand(new_path)
    is_directory <- fs::file_exists(new) & fs:::is_dir(new)
    if(!is_directory){
      if(fs::file_exists(new)){
        warning_line(glue::glue("{new_path} already exists. Skipping file copy."))
      } else {
        fs::file_copy(path = path, new_path = new_path, overwrite = overwrite)
      }
    } else {
      #new is a directory
      new_specific <- fs::path(new_path,basename(path))
      special_file_copy(path = path, new_path = new_specific, overwrite = overwrite)
    }
  }

  return(invisible())
}
