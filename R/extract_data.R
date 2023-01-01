
# Code to extract data from several online sources


# Packages ----------------------------------------------------------------

# Explicity load packages
library(jsonlite)



# Get functions -----------------------------------------------------------

# Funcion to import Excel files
import_xls <- function(url, source = NULL, ...) {

  print_info(paste(c("Extracting", source, "data..."), collapse = " "))

  req <- url |>
    httr2::request() |>
    httr2::req_retry(max_tries = 3, max_seconds = 10)

  resp <- req |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform(path = tempfile(fileext = ".xlsx"))

  if (httr2::resp_is_error(resp = resp)) {


    req_url <- req$url
    req_status <- httr2::resp_status(resp = resp)

    print_error(
      c(
        "x" = "Excel file request failed with status: {req_status}",
        "!" = "URL: {.url {req_url}}"
        )
      )

  } else {
    data <- readxl::read_xlsx(path = resp$body, ...)
    print_ok("Extraction completed.")
    return(data)
  }

}


# Function to import SIDRA tables
import_sidra <- function(api, source = NULL) {

  print_info(paste(c("Extracting", source, "data..."), collapse = " "))

  req <- paste0("https://apisidra.ibge.gov.br/values", api) |>
    httr2::request() |>
    httr2::req_retry(max_tries = 3, max_seconds = 10)

  resp <- req |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_is_error(resp = resp)) {

    req_url <- req$url
    req_status <- httr2::resp_status(resp = resp)

    print_error(
      c(
        "x" = "SIDRA API request failed with status: {req_status}",
        "!" = "URL: {.url {req_url}}"
        )
      )

  } else {
    data <- httr2::resp_body_json(resp = resp, simplifyDataFrame = TRUE)
    print_ok("Extraction completed.")
    return(data)
  }

}


# Function to import SGS/BCB time series
import_sgs <- function(code, start = NULL, end = NULL) {

  if (!is.numeric(code)) {print_error(c("x" = "{.var code} must be numeric."))}

  base_url <- paste0(
    "https://api.bcb.gov.br/dados/serie/bcdata.sgs.", code, "/dados?",
    "formato=json"
    )

  if (!is.null(start) & !inherits(x = start, what = "Date")) {
    print_error(c("x" = "{.var start} must be Date."))
  } else if (!is.null(start)) {
    start <- paste0("&dataInicial=", format(start, format = "%d/%m/%Y"))
  }

  if (!is.null(end) & !inherits(x = end, what = "Date")) {
    print_error(c("x" = "{.var end} must be Date."))
  } else if (!is.null(end)) {
    end <- paste0("&dataFinal=", format(end, format = "%d/%m/%Y"))
  }

  req <- paste0(base_url, start, end) |>
    httr2::request() |>
    httr2::req_retry(max_tries = 3, max_seconds = 10)

  code_names <- names(code)
  null_names <- is.null(code_names)
  print_info(
    paste(
      c(
        "Extracting",
        dplyr::if_else(
          null_names,
          paste0("SGS (code = ", code, ")"),
          paste0("SGS (", code_names, " = ", code, ")")
          ),
        "data..."
        ),
      collapse = " "
      )
    )

  resp <- req |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()

  if (httr2::resp_is_error(resp = resp)) {

    req_url <- req$url
    req_status <- httr2::resp_status(resp = resp)

    print_error(
      c(
        "x" = "SGS/BCB API request failed with status: {req_status}",
        "!" = "URL: {.url {req_url}}"
      )
    )

  } else {
    data <- httr2::resp_body_json(resp = resp, simplifyDataFrame = TRUE)
    print_ok("Extraction completed.")
  }

  return(data)

}



# Economic activity -------------------------------------------------------

# ICVA (Cielo)
raw_icva <- import_xls(
  url    = parameters$icva,
  sheet  = "Índice Mensal",
  skip   = 6,
  n_max  = 4,
  na     = "-",
  source = "ICVA"
  )


# Vehicle Production (ANFAVEA)
raw_anfavea <- import_xls(
  url    = parameters$anfavea,
  skip   = 4,
  source = "ANFAVEA"
  )


# GDP growth (rate of change of the quarterly volume index, IBGE)
raw_gdp_pct <- import_sidra(api = parameters$gdp_pct, source = "GDP (%)/SIDRA")


# GDP (values at current prices, IBGE)
raw_gdp_brl <- import_sidra(api = parameters$gdp_brl, source = "GDP (R$)/SIDRA")


# PMC (retail trade, IBGE)
raw_pmc <- import_sidra(api = parameters$pmc, source = "PMC/SIDRA")


# PMC (expanded retail trade, IBGE)
raw_pmc_expanded <- import_sidra(
  api    = parameters$pmc_expanded,
  source = "PMC expanded/SIDRA"
  )


# PMS (Monthly Service Survey, IBGE)
raw_pms <- import_sidra(api = parameters$pms, source = "PMS/SIDRA")


# PIM (Monthly Industrial Survey, YoY rate of change, IBGE)
raw_pim <- import_sidra(api = parameters$pim)


# Installed Capacity Utilization Level (NUCI/FGV)
raw_nuci <- import_sgs(code = parameters$nuci)


# IBC-Br (economic activity index, Central Bank of Brazil)
raw_ibc <- purrr::map(
  .x = parameters$ibc,
  .f = ~import_sgs(code = .x)
  )
