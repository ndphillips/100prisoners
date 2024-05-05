#' Title
#'
#' @param room tbl. A tibble created by prisoners_create_room()
#'
#' @return
#' @export
#'
#' @examples
add_loops <- function(room) {
  room <- room |>
    dplyr::mutate(
      loop = c(1, rep(NA_integer_, nrow(room) - 1)),
      index_in_loop = c(1, rep(NA_integer_, nrow(room) - 1))
    )

  while (any(is.na(room$loop))) {
    loop_current <- util_get_current_loop(room)
    loop_box_start <- util_get_start_box_in_loop(room, loop_current)
    last_ticket <- util_get_last_ticket(room)
    loop_current_last_index <- util_get_last_index_in_loop(room, loop_current)

    room <- room |>
      util_set_box_loop_and_index(
        .loop_current = loop_current,
        .last_ticket = last_ticket
      )
  }
  room
}

util_set_box_loop_and_index <- function(room, .last_ticket, .loop_current) {
  last_index_in_loop <- util_get_last_index_in_loop(room, .loop_current)
  start_box_in_loop <- util_get_start_box_in_loop(room, .loop_current)

  if (.last_ticket == start_box_in_loop) {
    room <- room |>
      dplyr::mutate(
        loop = dplyr::if_else(is.na(loop) & box == min(dplyr::if_else(is.na(loop), box, Inf)), .loop_current + 1, loop),
        index_in_loop = dplyr::if_else(loop == .loop_current + 1, 1, index_in_loop)
      )
  } else {
    room <- room |>
      dplyr::mutate(
        loop = dplyr::if_else(box == .last_ticket, .loop_current, loop),
        index_in_loop = dplyr::if_else(box == .last_ticket, last_index_in_loop + 1, index_in_loop)
      )
  }

  return(room)
}

util_get_last_ticket <- function(room) {
  ticket <- room |>
    dplyr::filter(loop == max(loop, na.rm = TRUE)) |>
    dplyr::filter(index_in_loop == max(index_in_loop, na.rm = TRUE)) |>
    dplyr::pull(ticket)

  return(ticket)
}

util_get_last_index_in_loop <- function(room, .loop) {
  last_index <- room |>
    dplyr::filter(loop == .loop) |>
    dplyr::filter(index_in_loop == max(index_in_loop, na.rm = TRUE)) |>
    dplyr::pull(index_in_loop)

  return(last_index)
}

util_get_start_box_in_loop <- function(room, .loop) {
  start_box <- room |>
    dplyr::filter(loop == .loop) |>
    dplyr::filter(index_in_loop == 1) |>
    dplyr::pull(box)

  return(start_box)
}

util_get_current_loop <- function(room) {
  current_loop <- room |>
    dplyr::filter(!is.na(loop)) |>
    dplyr::pull(loop) |>
    max(na.rm = TRUE)

  return(current_loop)
}
