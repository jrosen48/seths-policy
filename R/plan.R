the_plan <-
  drake_plan(
    
    d = read_rds(file_in("data-raw/downloadedTweets_all_6months.rds")) %>% 
      janitor::clean_names() %>% 
      as_tibble(),
    
    key = read_csv(file_in("data-raw/summary_data.txt")) %>% 
      janitor::clean_names(),
    
    state_level_vars = readxl::read_xlsx(file_in("data-raw/TeachersonTwitter.xlsx")) %>% 
      janitor::clean_names(),
    
    new_state_level_vars = read_excel(file_in("data-raw/TwitterTeachersData.xlsx")) %>% 
      janitor::clean_names(),
    
    written_prepared_data_as_csv = rmarkdown::render(
      knitr_in("prepare-data.Rmd"),
      output_file = file_out("docs/prepare-data.html"),
      params = list(d = d,
                    key = key,
                    state_level_vars = state_level_vars,
                    new_state_level_vars = new_state_level_vars)),
    
    linear_models = rmarkdown::render(
      knitr_in("analysis-linear-models.Rmd"),
      output_file = file_out("docs/analysis-linear-models.html")),
    
    # multi_level_models = rmarkdown::render(
    #   knitr_in("analysis-multi-level-models.Rmd"),
    #   output_file = file_out("docs/analysis-linear-models.html")),
    
)
