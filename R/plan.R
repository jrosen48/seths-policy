the_plan <-
  drake_plan(
    
    d = read_rds(file_in("data-raw/downloadedTweets_all_6months.rds")) %>% 
      janitor::clean_names() %>% 
      as_tibble(),
    
    account_created = read_rds(file_in("data-raw/account_created.rds")) %>% 
      janitor::clean_names() %>% 
      as_tibble(),
    
    key = read_csv(file_in("data-raw/summary_data.csv")) %>% 
      janitor::clean_names(),
    
    state_level_vars = readxl::read_xlsx(file_in("data-raw/TeachersonTwitter.xlsx")) %>% 
      janitor::clean_names(),
    
    new_state_level_vars = read_excel(file_in("data-raw/TwitterTeachersData.xlsx")) %>% 
      janitor::clean_names(),
    
    nces_data = read_csv(file_in("data-raw/ELSI_csv_export_6373645497929597249073.csv"), na = "‡", skip = 6) %>% 
      janitor::clean_names(),
    
    nces_data_1415 = read_csv(file_in("data-raw/ELSI_csv_export_6373766714138694852607.csv"), na = "‡", skip = 6) %>% 
      janitor::clean_names(),
    
    d_to_model = prepare_data(d, key, state_level_vars, new_state_level_vars, nces_data, nces_data_1415, account_created),
    
    linear_models = rmarkdown::render(
      knitr_in("analysis-linear-models.Rmd"),
      output_file = file_out("docs/analysis-linear-models.html"),
      params = list(d_to_model = d_to_model)),
    
    multi_level_models = rmarkdown::render(
      knitr_in("analysis-multi-level-models.Rmd"),
      output_file = file_out("docs/analysis-multi-level-models.html"),
      params = list(d_to_model = d_to_model)),
    
  )
