#' Title
#'
#' @param boxes_n integer. The number of boxes in the room
#' @param rooms_n integer. The number of rooms
#'
#' @return
#' @export
#'
#' @examples
create_rooms <- function(boxes_n = 100,
                         rooms_n = 1) {
  rooms_ls <- lapply(1:rooms_n, \(x) {
    tickets_v <- sample(1:boxes_n,
      size = boxes_n
    )

    tibble::tibble(
      box = 1:boxes_n,
      ticket = tickets_v
    )
  })

  rooms_ls
}

#' Title
#'
#' @param prisoner_game
#'
#' @return
#' @export
#'
#' @examples
add_rooms <- function(game) {
  teams_n <- util_get_param(game, "teams_n")
  prisoners_n <- util_get_param(game, "prisoners_n")

  rooms_ls <- create_rooms(
    boxes_n = prisoners_n,
    rooms_n = teams_n
  )

  game$rooms <- rooms_ls

  return(game)
}
