# seths-policy

## Data

One file is needed to run the analysis,

`downloadedTweets_all_6months.rds`

Add this file to the `data-raw` directory

## Use

This project uses {drake}. To run the project from start to finish, run `drake::r_make()`.

Running this function:

- sources `packages.R` and all of the `.R` files in the `/R` directory
- runs `plan.R`, which includes the plan for the analysis

## Site

<to be added>
