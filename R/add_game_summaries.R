#' Title
#'
#' @param prisoner_game
#'
#' @return
#'
#' @examples
add_game_summaries <- function(prisoner_game) {
  p_success <- mean(prisoner_game$outcomes$is_success)

  prisoner_game$summaries$p_success <- p_success

  return(prisoner_game)
}
