#' Title
#'
#' @param prisoner_game
#'
#' @return
#' @export
#'
#' @examples
add_game_outcomes <- function(prisoner_game) {
  sim_time_start <- Sys.time()

  prisoner_game <- dispatch_add_game_outcomes(prisoner_game)

  sim_time_end <- Sys.time()

  sim_duration <- as.numeric(difftime(sim_time_end, sim_time_start, units = "secs"))

  prisoner_game$processing$sim_duration <- sim_duration

  return(prisoner_game)
}

dispatch_add_game_outcomes <- function(x) {
  UseMethod("add_game_outcomes")
}

#' Add game outcomes using the environment method
#'
#' @param prisoner_game prisoner_game. A game created by `create prisoner_game`
#'
#' @return
#' @export
#'
#' @examples
add_game_outcomes.environment <- function(prisoner_game) {
  teams_n <- util_get_param(prisoner_game, "teams_n")
  prisoners_n <- util_get_param(prisoner_game, "prisoners_n")
  pick_max <- util_get_param(prisoner_game, "pick_max")

  rooms_ls <- lapply(1:teams_n, function(x) {
    list()
  })

  cli::cli_progress_bar(glue::glue("Simulating {teams_n} teams of {prisoners_n} prisoners"), total = teams_n)

  for (team_i in 1:teams_n) {
    rooms_ls[[team_i]] <- prisoners_create_room(prisoners_n) |>
      add_loops()

    cli::cli_progress_update()
  }

  cli::cli_progress_done()

  outcomes_tbl <- rooms_ls |>
    purrr::map(
      \(x) {
        tibble::tibble(
          is_success = max(x$index_in_loop) <= pick_max,
          boxes_opened_n_max = max(x$index_in_loop)
        )
      }
    ) |>
    purrr::list_rbind()

  prisoner_game$outcomes <- outcomes_tbl

  return(prisoner_game)
}

#' Add game outcomes using the agent method
#'
#' @param prisoner_game prisoner_game. A game created by `create prisoner_game`
#'
#' @return
#' @export
#'
#' @examples
add_game_outcomes.agent <- function(prisoner_game) {
  teams_n <- util_get_param(prisoner_game, "teams_n")
  prisoners_n <- util_get_param(prisoner_game, "prisoners_n")
  pick_max <- util_get_param(prisoner_game, "pick_max")

  rooms_ls <- purrr::map(1:teams_n, \(x) {
    prisoners_create_room(prisoners_n)
  })

  outcomes_tbl <- purrr::map(
    1:teams_n,
    \(x) {
      prisoner_game$pb$tick()
      simulate_agent_team(
        rooms_ls[[x]],
        pick_max = pick_max
      )
    }
  ) |>
    purrr::map_dfr(
      \(x) {
        tibble::tibble(
          boxes_opened_n_max = max(x$boxes_opened_n)
        )
      }
    ) |>
    dplyr::mutate(is_success = boxes_opened_n_max <= pick_max) |>
    dplyr::select(is_success, boxes_opened_n_max)

  prisoner_game$outcomes <- outcomes_tbl

  return(prisoner_game)
}
