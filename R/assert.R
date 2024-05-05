assert_is_prisoner_game <- function(game) {
  assertthat::assert_that(inherits(game, "prisoner_game"))
}

assert_has_summaries <- function(game) {
  assert_is_prisoner_game(game)

  assertthat::assert_that(!is.null(game$summaries))
}

assert_has_outcomes <- function(game) {
  assert_is_prisoner_game(game)

  assertthat::assert_that(!is.null(game$outcomes))
}

assert_is_room <- function(room) {
  assertthat::assert_that(inherits(room, "room"))
}
