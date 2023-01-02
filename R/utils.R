
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


# Pretty print messages
print_info <- function(text) {cli::cli_alert_info(text = text)}
print_ok <- function(text) {cli::cli_alert_success(text = text)}
print_error <- function(text) {cli::cli_abort(message = text, call = NULL)}


# Check class
is_date <- function(obj) {inherits(x = obj, what = "Date")}


# Format characters
format_dmy <- function(value) {format(x = value, format = "%d/%m/%Y")}


# Check package is installed
is_installed <- function(pkg) {
  if (!requireNamespace(package = pkg, quietly = TRUE)) {
    print_error(
      c(
        "x" = paste0(
          "Package {.pkg ", pkg, "} must be installed to use this function."
          )
        )
      )
  }
}
