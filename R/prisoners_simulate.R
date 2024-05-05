# Simulate Prisoner Game | prisoners_simulate() ----------------------------

#' Simulate the prisoner game
#'
#' @param prisoners_n integer. The number of prisoners in each team
#' @param teams_n integer. The number of (separate) teams of prisoners
#' @param pick_max integer. The maximum number of boxes individual prisoners can open
#' @param method character. The method to use for simulation. Either "agent" or "environment"
#'
#' @return list. A list with the structure of the game
#' @export
#'
#' @examples
prisoners_simulate <- function(prisoners_n = 100,
                               teams_n = 10,
                               pick_max = floor(prisoners_n / 2),
                               method = c("environment", "agent")) {
  method <- match.arg(method)

  game <- prisoners_create_game(
    teams_n = teams_n,
    prisoners_n = prisoners_n,
    pick_max = pick_max,
    method = method
  )

  game <- add_game_outcomes(game)

  game <- add_game_summaries(game)

  return(game)
}
