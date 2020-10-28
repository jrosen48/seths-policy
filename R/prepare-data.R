prepare_data <- function(d, key, state_level_vars, new_state_level_vars, nces_data, nces_data_1415, account_created) {
  
  new_state_level_vars <- new_state_level_vars %>% 
    mutate(state = tolower(state),
           state = tools::toTitleCase(state))
  
  nces_data <- nces_data %>% 
    mutate(state = tolower(state_name),
           state = tools::toTitleCase(state)) %>% 
    select(-state_name) %>% 
    select(state, everything())
  
  nces_data_1415 <- nces_data_1415 %>% 
    mutate(state = tolower(state_name),
           state = tools::toTitleCase(state)) %>% 
    select(-state_name) %>% 
    select(state, everything())
  
  d_long <- d %>% 
    unnest(hashtags)
  
  key <- key %>% 
    mutate(hashtags = str_sub(seth, start = 2))
  
  # joining state-level vars
  
  state_level_vars_combined <- state_level_vars %>% 
    left_join(new_state_level_vars, by = "state") %>% 
    left_join(nces_data) %>% 
    left_join(nces_data_1415)
  
  # joining all data
  
  d_long <- d_long %>% 
    mutate(hashtags = tolower(hashtags)) 
  
  d_long <- d_long %>% 
    left_join(key, by = "hashtags")
  
  d_long <- d_long %>% 
    left_join(state_level_vars_combined, by = "state")
  
  d_long <- d_long %>% 
    left_join(account_created, by = "user_id")
  
  # filtering data
  
  d_long <- d_long %>%
    filter(created_at >= lubridate::ymd('2016-01-1') &
             created_at <= lubridate::ymd('2016-06-30'))
  
  # creating time_of_account var 
  
  d_long <- d_long %>% 
    mutate(time_of_account = 
             lubridate::time_length(lubridate::interval(account_created_at, lubridate::ymd("2016-01-01")), "years"))
  
  # selecting only certain variables to include to make this file easier to work with 
  
  d_long <- d_long %>% 
    select(user_id, screen_name, account_created_at, hashtag = hashtags, state_abbre:time_of_account, state)
  
  # filtering data to only include those from one of our 47 states (so filtering cases associated with hashtags not in the key)
  
  d_to_model <- d_long %>% 
    filter(!is.na(state))
  
  # creating new variables
  
  d_to_model <- d_to_model %>%
    mutate(pct_students_frpl = as.integer(free_and_reduced_lunch_students_public_school_2015_16) / 
             as.integer(total_students_state_2015_16),
           pct_students_frpl = ifelse(is.na(pct_students_frpl), 
                                      as.integer(free_and_reduced_lunch_students_public_school_2014_15) / 
                                        as.integer(total_students_state_2014_15), pct_students_frpl),
           state_spending_per_child = as.numeric(state_spending_on_public_elementary_secondary_spending_fy_2016_census_in_thousands) /
             as.integer(total_students_state_2015_16),
           teacher_student_ratio = as.integer(total_students_state_2015_16) / 
             as.integer(full_time_equivalent_fte_teachers_state_2015_16))
  
  n_tweets_at_state_level <- d_to_model %>% 
    count(state) %>% 
    rename(n_tweets_at_state_level = n)
  
  n_tweets_by_user_in_state <- d_to_model %>% 
    count(state, screen_name) %>% 
    rename(n_tweets_by_user_in_state = n)
  
  d_to_model <- d_to_model %>% 
    left_join(n_tweets_at_state_level)
  
  d_to_model <- d_to_model %>% 
    left_join(n_tweets_by_user_in_state)
  
  voices <- d_to_model %>% 
    count(screen_name, state) %>%
    count(state) %>% 
    rename(voices = n)
  
  d_to_model <- d_to_model %>% 
    left_join(voices)
  
  d_to_model
}