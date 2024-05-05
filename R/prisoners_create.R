#' Create a new prisoner game object
#'
#' @param teams_n integer. The number of teams of prisoners
#' @param prisoners_n integer. The number of prisoners per team
#' @param pick_max integer. The maximum number of boxes individual prisoners can open
#' @param method character. The method to use for simulation. Either "agent" or "environment"
#'
#' @export
#' @return list. A list with the structure of the game
#'
prisoners_create_game <- function(teams_n, prisoners_n, pick_max, method = "environment") {
  pb <- progress::progress_bar$new(
    format = "Team :current/:total [:bar] :percent eta: :eta",
    total = teams_n,
    clear = FALSE
  )

  params <- list(
    method = method,
    pick_max = pick_max,
    teams_n = teams_n,
    prisoners_n = prisoners_n
  )

  out <- structure(list(
    pb = pb,
    params = params,
    outcomes = NULL,
    summaries = NULL,
    processing = NULL
  ), class = c(method, "prisoner_game"))

  return(out)
}
