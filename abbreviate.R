
# Packages ------------------------------------------------------------------------------------

library(here)
library(magrittr)
library(tools)
library(glue)
library(mgsub)
library(tidyverse)

# Functions -----------------------------------------------------------------------------------

kickout <- function(list) {
  
  # This function removes any element from the list of input files
  # (from root/input, usually) which does not have one of the allowed
  # extensions or which has "deprecated" in its name
  
  allowed_ext <- c("bib", "bibtex")
  
  for (i in rev(seq_along(list))) {
    
    if (!(tolower(tools::file_ext(list[[i]])) %in% allowed_ext)) {
      
      list[[i]] <- NULL 
      
    } else if (str_detect(tolower(list[[i]]), fixed("deprecated", TRUE)) == TRUE) {
      
      list[[i]] <- NULL 
      
    }
  }
  
  return(list)
}

# Load Files ----------------------------------------------------------------------------------

setwd(here())

# Sanity check to see if there is an input/ directory

if (dir.exists("input/") == FALSE) {
  stop("No input/ directory found.")
}

filelist <- 
  list.files("input/", recursive = F, include.dirs = F, full.names = T) %>%
  as.list %>% kickout

# Sanity check to see if there were any bib or bibtex files in input/

if (length(filelist) == 0) {
  stop("No acceptable input files, check input/ directory!")
}

bibliolist <- filelist %>% map(read_file)

names(bibliolist) <- filelist %>% as_vector %>% basename

full_names <-
  read_csv("journal_abbrevs.csv",
           locale = readr::locale(encoding = "latin1")) %>%
  drop_na() %>% .$full_name

abbrev_names <-
  read_csv("journal_abbrevs.csv", 
           locale = readr::locale(encoding = "latin1")) %>%
  drop_na() %>% .$abbrev_name

# Replace Full Names --------------------------------------------------------------------------

# The mgsub function from the same-named package is used to replace full names
# with corresponding abbreviated names

biblio_output <-
  bibliolist %>% map(mgsub, 
                     pattern = full_names,
                     replacement = abbrev_names,
                     fixed = TRUE)


# Output --------------------------------------------------------------------------------------

# Check for an output directory and make it if it doesn't exist

if (dir.exists("output/") == FALSE) {dir.create("output/")}

# Map a generic function which writes outputs to separate .bib files

biblio_output %>% 
  map2(filelist, function(bib, file_name) {
    
    bib %>% 
      write_file(glue("output/{file_path_sans_ext(basename(file_name))}_abbreviated.bib"))
    
  }
  )
