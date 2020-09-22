the_plan <-
  drake_plan(
    
    d = read_rds('data-raw/downloadedTweets_all_6months.rds') %>% 
      janitor::clean_names() %>% 
      as_tibble(),
    
    key = read_csv("data-raw/summary_data.txt") %>% 
      janitor::clean_names(),
    
    state_level_vars = readxl::read_xlsx("data-raw/TeachersonTwitter.xlsx") %>% 
      janitor::clean_names(),
    
    new_state_level_vars = read_excel("data-raw/TwitterTeachersData.xlsx") %>% 
      janitor::clean_names()
    
)
