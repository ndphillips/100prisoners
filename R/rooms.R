#' Title
#'
#' @param boxes_n integer. The number of boxes in the room
#' @param rooms_n integer. The number of rooms
#'
#' @return
#' @export
#'
#' @examples
create_rooms <- function(prisoners_n = 100,
                         rooms_n = 10) {
  rooms <- lapply(1:rooms_n, \(x) {
    tickets_v <- sample(1:prisoners_n,
      size = prisoners_n
    )

    room <- tibble::tibble(
      box = 1:prisoners_n,
      ticket = tickets_v)

    room
  })

  out <- structure(rooms, class = "list_of_rooms")
  out
}

#' Title
#'
#' @param prisoner_game
#'
#' @return
#' @export
#'
#' @examples
add_rooms <- function(game, rooms = NULL) {
  teams_n <- pull_param(game, "teams_n")
  prisoners_n <- pull_param(game, "prisoners_n")

  if (is.null(rooms)) {
    rooms <- create_rooms(
      prisoners_n = prisoners_n,
      rooms_n = teams_n
    )
  }

  game$rooms <- rooms

  return(game)
}
