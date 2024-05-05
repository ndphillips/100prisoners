#' Title
#'
#' @param game game. A game object created by `prisoners_simulate()`
#'
#' @return
#' @export
#'
#' @examples
plot_boxes_max <- function(game) {
  outcomes_tbl <- game |>
    pull_outcomes()

  success_p <- game |> pull_success_p()

  open_max <- game |> pull_param("open_max")

  p <- outcomes_tbl |>
    ggplot2::ggplot(ggplot2::aes(boxes_opened_n_max)) +
    ggplot2::stat_ecdf() +
    ggplot2::labs(
      x = "Max Boxes Opened",
      y = "Cumulative Probability",
    ) +

    # Add intersecting lines at open_max

    ggplot2::geom_vline(
      xintercept = game$params$open_max,
      linetype = "dashed",
      color = "red"
    ) +

    # add horizontal line where open_max intersects the cdf

    ggplot2::geom_hline(
      yintercept = game |> pull_success_p(),
      linetype = "dashed",
      color = "darkgreen"
    )

  # Add title indicating the probability of success

  p <- p + ggplot2::ggtitle(
    glue::glue("Probability of Success with {open_max} max looks : {success_p}")
  )

  p <- p +
    caption_game_params(game)

  p
}


caption_game_params <- function(game) {
  ggplot2::labs(
    caption = glue::glue(
      "Params\n",
      "Teams: {game$params$teams_n}\n",
      "Prisoners: {game$params$prisoners_n}\n",
      "open Max: {game$params$open_max}"
    )
  )
}


#' Title
#'
#' @param room room. A room object created by `create_room()`
#' @param color_loops logical. Should the boxes be colored by loop?
#' @param arrange_loops logical. Should the boxes be arranged?
#'
#' @return
#' @export
#'
#' @examples
plot_room <- function(room,
                      color_by_loop = TRUE,
                      sort_by_loop = TRUE,
                      show_loops = TRUE) {

  if (show_loops == FALSE) {
    color_by_loop <- FALSE
    sort_by_loop <- FALSE
  }

  # room <- create_room(16) |>
  #   add_loops()

  if ("loop" %in% colnames(room) == FALSE) {
    room <- room |>
      add_loops_to_room()
  }

  if (sort_by_loop) {
    room <- room |>
      dplyr::arrange(loop, index_in_loop)
  }

  if (color_by_loop) {
    room <- room |>
      dplyr::mutate(loop = factor(loop))

    mapping <- ggplot2::aes(x = row, y = column, label = box, fill = loop)
  } else {
    mapping <- ggplot2::aes(x = row, y = column, label = box)
  }

  boxes_n <- nrow(room)

  rows_n <- floor(sqrt(boxes_n))
  columns_n <- ceiling(sqrt(boxes_n))

  room <- room |>
    dplyr::mutate(
      row = rep(1:rows_n, times = columns_n)[1:boxes_n],
      column = rev(rep(1:columns_n, each = rows_n))[1:boxes_n]
    )

  p <- ggplot2::ggplot(room, mapping) +
    ggplot2::theme_void() +
    ggplot2::geom_tile(width = .3, height = .3) +
    ggplot2::geom_text(nudge_y = .3) +
    ggplot2::geom_text(mapping = ggplot2::aes(label = ticket), col = "white") +
    ggplot2::theme(legend.position = "none")

  # Add arrows pointing between sequential boxes within a loop


  if (show_loops) {

    room <- room |>
      dplyr::group_by(loop) |>
      dplyr::mutate(arrow_start_x = row + .17,
                    arrow_start_y = column) |>
      dplyr::mutate(is_last_in_loop = index_in_loop == max(index_in_loop)) |>

      dplyr::mutate(arrow_end_x = dplyr::case_when(
        is_last_in_loop & index_in_loop == 1 ~ row - .17,
        is_last_in_loop & index_in_loop != 1 ~ row[index_in_loop == 1],
        TRUE ~ dplyr::lead(row) - .17
      ),
      arrow_end_y = dplyr::case_when(
        is_last_in_loop & index_in_loop == 1 ~ column,
        is_last_in_loop & index_in_loop != 1 ~ column[index_in_loop == 1] - .17,
        TRUE ~ dplyr::lead(column)
      ),
      arrow_color = ifelse(is_last_in_loop, "black", "grey")
      )

    p <- p +
      ggplot2::geom_curve(curvature = .2,
                          data = room |> dplyr::filter(!is_last_in_loop),
    ggplot2::aes(
          x = arrow_start_x,
          y = arrow_start_y,
          xend = arrow_end_x,
          yend = arrow_end_y,
          color = arrow_color
        ),
        arrow = ggplot2::arrow(type = "closed", length = grid::unit(0.1, "inches"))
      ) +
      ggplot2::geom_curve(curvature = -.2,
                          data = room |> dplyr::filter(is_last_in_loop),
                          ggplot2::aes(
                            x = arrow_start_x,
                            y = arrow_start_y,
                            xend = arrow_end_x,
                            yend = arrow_end_y,
                            color = arrow_color
                          ),
                          arrow = ggplot2::arrow(type = "closed", length = grid::unit(0.1, "inches"))
      ) +
      ggplot2::scale_color_identity()
  }


  # if (color_by_loop) {
  #   p <- p +
  #     ggplot2::theme(legend.position = "top")
  #
  # }

  p
}
