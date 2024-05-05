#' Title
#'
#' @param boxes_n integer. The number of boxes in the room
#'
#' @return
#' @export
#'
#' @examples
prisoners_create_room <- function(boxes_n = 100) {
  tickets_v <- sample(1:boxes_n,
    size = boxes_n
  )

  room <- tibble::tibble(
    box = 1:boxes_n,
    ticket = tickets_v
  )

  room
}
