#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
print.prisoner_game <- function(x) {
  cat("Prisoner Game\n")
  cat("Teams: ", x$params$teams_n, "\n", sep = "")
  cat("Prisoners: ", x$params$prisoners_n, "\n", sep = "")
  cat("Simulation Completed?: ", !is.null(x$outcomes), "\n", sep = "")
}
