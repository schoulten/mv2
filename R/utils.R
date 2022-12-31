
# Useful general functions


# Transform a fail-prone function to retry on failures
retry <- function(
    fun,
    tries = purrr::rate_delay(pause = 5, max_times = 3),
    default = NULL,
    quiet = FALSE
    ) {

  insist <- purrr::insistently(
    f     = fun,
    rate  = tries,
    quiet = quiet
    )

  otherwise <- purrr::possibly(
    .f        = insist,
    otherwise = default,
    quiet     = quiet
    )

  return(otherwise)

}
