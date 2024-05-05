#' Title
#'
#' @param prisoner_game
#'
#' @return
#' @export
#'
#' @examples
add_outcomes <- function(game) {
  sim_time_start <- Sys.time()

  outcomes <- create_outcomes(
    rooms = game |> pull_rooms(),
    prisoners_n = game |> pull_param("prisoners_n"),
    open_max = game |> pull_param("open_max"),
    method = game |> pull_param("method")
  )

  game$outcomes <- outcomes

  sim_time_end <- Sys.time()

  sim_duration_total <- as.numeric(difftime(sim_time_end, sim_time_start, units = "secs"))
  sim_duration_mean <- sim_duration_total / (game |> pull_param("teams_n"))

  game$meta$sim_duration_total <- sim_duration_total
  game$meta$sim_duration_mean <- sim_duration_mean

  return(game)
}

#' Create game outcomes based on a method
#'
#' @param rooms list. A list of rooms created by `create_rooms`
#' @param open_max integer. The maximum number of boxes that can be opened
#' @param method character. The method to use. Can be 'environment' or 'agent'
#'
#' @return
#' @export
#'
#' @examples
create_outcomes <- function(rooms,
                            open_max,
                            prisoners_n,
                            method) {
  out <- switch(method,
    "environment" = create_outcomes_environment(rooms = rooms, open_max = open_max, prisoners_n = prisoners_n),
    "agent" = create_outcomes_agent(rooms = rooms, open_max = open_max, prisoners_n = prisoners_n)
  )

  out
}


#' Add game outcomes using the environment method
#'
#' @param rooms list. A list of rooms created by `create_rooms`
#' @param prisoners_n integer. The number of prisoners
#' @param open_max integer. The maximum number of boxes that can be opened
#'
#' @return
#' @export
#'
#' @examples
create_outcomes_environment <- function(rooms,
                                        prisoners_n,
                                        open_max) {
  teams_n <- length(rooms)

  cli::cli_progress_bar(glue::glue("Simulating {prisoners_n} prisoners across {teams_n} rooms"), total = teams_n)

  for (team_i in 1:teams_n) {
    rooms[[team_i]] <- rooms[[team_i]] |>
      add_loops_to_room()

    cli::cli_progress_update()
  }

  outcomes_tbl <- rooms |>
    purrr::map(
      \(x) {
        tibble::tibble(
          is_success = max(x$index_in_loop) <= open_max,
          boxes_opened_n_max = max(x$index_in_loop)
        )
      }
    ) |>
    purrr::list_rbind()

  return(outcomes_tbl)
}

#' Add game outcomes using the agent method
#'
#' @param prisoner_game prisoner_game. A game created by `create prisoner_game`
#'
#' @return
#' @export
#'
#' @examples
create_outcomes_agent <- function(rooms,
                                  prisoners_n,
                                  open_max) {
  teams_n <- length(rooms)

  cli::cli_progress_bar(glue::glue("Simulating {prisoners_n} prisoners across {teams_n} rooms"), total = teams_n)

  outcomes_ls <- lapply(1:length(rooms), function(x) {
    list()
  })

  for (team_i in 1:teams_n) {
    room_i <- rooms[[team_i]]

    prisoners_n <- nrow(room_i)

    team_result_ls <- purrr::map(
      1:prisoners_n,
      \(prisoner_i) {
        simulate_agent_prisoner(
          room = room_i,
          prisoner_i = prisoner_i,
          open_max = open_max
        )
      }
    )

    boxes_opened_n_vec <- purrr::map_int(
      team_result_ls,
      \(x) x$boxes_opened_n
    )

    outcomes_ls[[team_i]] <- tibble::tibble(
      boxes_opened_n = boxes_opened_n_vec
    )
    cli::cli_progress_update()
  }

  outcomes_tbl <- outcomes_ls |>
    purrr::map_dfr(
      \(x) {
        tibble::tibble(
          boxes_opened_n_max = max(x$boxes_opened_n)
        )
      }
    ) |>
    dplyr::mutate(is_success = boxes_opened_n_max <= open_max) |>
    dplyr::select(is_success, boxes_opened_n_max)

  return(outcomes_tbl)
}
