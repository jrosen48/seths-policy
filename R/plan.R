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
    
    d_to_model = prepare_data(d, key, state_level_vars, new_state_level_vars),
    
    linear_models = rmarkdown::render(
      knitr_in("analysis-linear-models.Rmd"),
      output_file = file_out("docs/analysis-linear-models.html"),
      params = list(d_to_model = d_to_model)),
    
    # multi_level_models = rmarkdown::render(
    #   knitr_in("analysis-multi-level-models.Rmd"),
    #   output_file = file_out("docs/analysis-linear-models.html")),
    
  )
