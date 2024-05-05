#' Title
#'
#' @param room
#' @param prisoner
#' @param arrange_loops
#'
#' @return
#' @export
#'
#' @examples
plot_prisoner_search <- function(room,
                                 prisoner,
                                 arrange_loops = TRUE) {
  # room <- prisoners_create_room(16) |>
  #   add_loops()

  if (arrange_loops) {
    room <- room |>
      dplyr::arrange(loop, index_in_loop)
  }

  boxes_n <- nrow(room)

  rows_n <- floor(sqrt(boxes_n))
  columns_n <- ceiling(sqrt(boxes_n))

  room <- room |>
    dplyr::mutate(
      row = rep(1:rows_n, times = columns_n)[1:boxes_n],
      column = rev(rep(1:columns_n, each = rows_n))[1:boxes_n]
    )

  ggplot2::ggplot(room, ggplot2::aes(x = row, y = column, label = box)) +
    ggplot2::theme_void() +
    ggplot2::geom_tile(width = .2, height = .2, fill = "white", col = "black") +
    ggplot2::geom_text(nudge_y = .2) +
    ggplot2::geom_text(mapping = ggplot2::aes(label = ticket), col = gray(.4))
}
