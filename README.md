
<!-- README.md is generated from README.Rmd. Please edit that file -->

# prisoners

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/prisoners)](https://CRAN.R-project.org/package=prisoners)
<!-- badges: end -->

The goal of prisoners is to …

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

Simulate multiple teams of prisoners using `prisoners_simulate()`

``` r
set.seed(123)
result_agent <- prisoners_simulate(
  prisoners_n = 100,
  teams_n = 10,
  method = "environment"
)
```
