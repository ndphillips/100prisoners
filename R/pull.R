#' Pull the success rate of the prisoners game
#'
#' @param game A game object
#'
#' @return
#' @export
#'
#' @examples
pull_success_p <- function(game) {
  assert_has_summaries(game)

  game$summaries$success_p
}


#' Pull the success rate of the prisoners game
#'
#' @param game A game object
#'
#' @return
#' @export
#'
#' @examples
pull_duration_total <- function(game) {
  assert_has_outcomes(game)

  game$meta$duration_total
}

#' Pull the success rate of the prisoners game
#'
#' @param game A game object
#'
#' @return
#' @export
#'
#' @examples
pull_duration_mean <- function(game) {
  assert_has_outcomes(game)

  game$meta$sim_duration_mean
}

#' Title
#'
#' @param game
#'
#' @return
#' @export
#'
#' @examples
pull_rooms <- function(game) {
  game$rooms
}

#' Title
#'
#' @param game
#'
#' @return
#' @export
#'
#' @examples
pull_outcomes <- function(game) {
  game$outcomes
}


#' Pull a room out of a list of rooms
#'
#' @param room_ls list. A list of rooms created by `create_rooms()`
#' @param room integer. The room number to pull
#'
#' @return tbl. A tbl indicating a room
#' @export
#'
#' @examples
pull_room <- function(room_ls, room) {
  assertthat::assert_that(inherits(room_ls, "list_of_rooms"))

  room_ls[[room]]
}
