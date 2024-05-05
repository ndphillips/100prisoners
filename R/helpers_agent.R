#' Title
#'
#' @param room tbl. A tibble created by prisoners_create_room()
#' @param prisoner_i integer. The prisoner number
#' @param open_max integer. The maximum number of boxes to search
#'
#' @return  list. A list with the following elements:
#' - prisoner: integer. The prisoner number
#' - is_success: logical. Whether the prisoner was successful
#' - ticket_v: integer. The ticket numbers in the order they were opened
#' - boxes_opened_n: integer. The number of boxes opened by the prisoner
#'
#'
simulate_agent_prisoner <- function(room = NULL,
                                    prisoner_i = 1,
                                    open_max = NULL) {
  open_i <- 1

  ticket_v <- room |>
    dplyr::filter(box == prisoner_i) |>
    dplyr::pull(ticket)

  is_success_i <- FALSE

  if (ticket_v == prisoner_i) {
    is_success_i <- TRUE
  }

  while (length(ticket_v) <= nrow(room) && is_success_i == FALSE) {
    open_i <- open_i + 1

    ticket_i <- room |>
      dplyr::filter(box == ticket_v[open_i - 1]) |>
      dplyr::pull(ticket)

    ticket_v <- c(ticket_v, ticket_i)

    if (ticket_i == prisoner_i) {
      is_success_i <- TRUE
    }
  }

  is_success_i <- length(ticket_v) <= open_max

  out <- list(
    prisoner = prisoner_i,
    is_success = is_success_i,
    ticket_v = ticket_v,
    boxes_opened_n = length(ticket_v)
  )

  return(out)
}
