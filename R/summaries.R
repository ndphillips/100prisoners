#' Title
#'
#' @param outcomes_tbl
#'
#' @return
#' @export
#'
#' @examples
create_game_summaries <- function(outcomes_tbl) {
  success_p <- mean(outcomes_tbl$is_success)

  out_ls <- list(success_p = success_p)

  return(out_ls)
}

#' Title
#'
#' @param prisoner_game
#'
#' @return
#'
#' @examples
add_game_summaries <- function(prisoner_game) {
  summaries <- create_game_summaries(prisoner_game$outcomes)

  prisoner_game$summaries <- summaries

  return(prisoner_game)
}
