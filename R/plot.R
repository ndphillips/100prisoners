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

  p <- outcomes_tbl |>
    ggplot2::ggplot(ggplot2::aes(boxes_opened_n_max)) +
    ggplot2::stat_ecdf() +
    ggplot2::labs(
      x = "Max Boxes Opened",
      y = "Cumulative Probability",
    ) +

    # Add intersecting lines at pick_max

    ggplot2::geom_vline(
      xintercept = game$params$pick_max,
      linetype = "dashed",
      color = "red"
    ) +

    # add horizontal line where pick_max intersects the cdf

    ggplot2::geom_hline(
      yintercept = game |> pull_success_p(),
      linetype = "dashed",
      color = "darkgreen"
    )

  # Add title indicating the probability of success

  p <- p + ggplot2::ggtitle(
    glue::glue("Probability of Success: {success_p}")
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
      "Pick Max: {game$params$pick_max}"
    )
  )
}
