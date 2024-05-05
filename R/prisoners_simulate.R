# Simulate Prisoner Game | prisoners_simulate() ----------------------------

#' Simulate the prisoner game
#'
#' @param prisoners_n integer. The number of prisoners in each team
#' @param teams_n integer. The number of (separate) teams of prisoners
#' @param open_max integer. The maximum number of boxes individual prisoners can open
#' @param method character. The method to use for simulation. Either "agent" or "environment"
#'
#' @return list. A list with the structure of the game
#' @export
#'
#' @examples
prisoners_simulate <- function(rooms = NULL,
                               prisoners_n = 100,
                               teams_n = 100,
                               open_max = floor(prisoners_n / 2),
                               method = c("environment", "agent")) {
  method <- match.arg(method)

  if (!is.null(rooms)) {
    teams_n <- length(rooms)
  }

  game <- prisoners_create_game(
    teams_n = teams_n,
    prisoners_n = prisoners_n,
    open_max = open_max,
    method = method
  )

  game <- add_rooms(game, rooms = rooms)

  game <- add_outcomes(game)

  game <- add_game_summaries(game)

  return(game)
}
