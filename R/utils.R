
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


# HTTP request
http_req <- function(url) {
  url |>
    httr2::request() |>
    httr2::req_retry(max_tries = 3, max_seconds = 10)
}


# HTTP response
http_resp <- function(req, ...) {
  req |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform(...)
}


# HTTP response error message
http_error_message <- function(response, source) {

  req_url <- response$url
  req_status <- httr2::resp_status(resp = response)

  print_error(
    c(
      "x" = paste0(source, " request failed with status: {", req_status, "}"),
      "!" = paste0("URL: {.url ", req_url, "}")
      )
    )
}
