
<!-- README.md is generated from README.Rmd. Please edit that file -->

# prisoners

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/prisoners)](https://CRAN.R-project.org/package=prisoners)
<!-- badges: end -->

The goal of prisoners is to provide functinoality to simulate the 100
prisoners problem
(<https://en.wikipedia.org/wiki/100_prisoners_problem>)

## Installation

You can install the development version of prisoners from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ndphillips/prisoners")
```

## Example

``` r
library(prisoners)
```

### Simulate Prisoner Games

Simulate multiple teams of prisoners using `prisoners_simulate()`

``` r
set.seed(123)

# Simulate 100 teams of 100 prisoners using the 'agent' method
result_agent <- prisoners_simulate(
  teams_n = 100,
  prisoners_n = 100,
  pick_max = 50,
  method = "environment"
)
```

``` r
# Print the result
result_agent
#> Prisoner Game
#> Teams: 100
#> Prisoners: 100
#> Simulation Completed?: TRUE
```

Access key results using `pull_*()` functions:

``` r
# What were the key outcomes for each team?
pull_outcomes(result_agent)
#> # A tibble: 100 × 2
#>    is_success boxes_opened_n_max
#>    <lgl>                   <dbl>
#>  1 FALSE                      86
#>  2 FALSE                      77
#>  3 FALSE                      82
#>  4 FALSE                      57
#>  5 FALSE                      60
#>  6 FALSE                      79
#>  7 TRUE                       46
#>  8 FALSE                      62
#>  9 FALSE                      74
#> 10 FALSE                      91
#> # ℹ 90 more rows

# What was the overall success rate?
pull_success_p(result_agent)
#> [1] 0.32

# How long did the simulation take?
pull_duration_mean(result_agent)
#> NULL
```

Visualise the results using `plot_*()` functions:

``` r
plot_boxes_max(result_agent)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

### Helpers

Create your own rooms using `create_rooms()`

``` r
# Create 10 rooms of 100 boxes
boxes_ls <- create_rooms(rooms_n = 10, boxes_n = 100)
```
