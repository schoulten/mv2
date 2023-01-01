
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

  resp <- httr2::req_perform(req = req, path = tempfile(fileext = ".xlsx"))

  if (httr2::resp_is_error(resp = resp)) {
    print_error(
      paste0(
        "Excel file request failed with status: ",
        httr2::resp_status(resp = resp)
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

  resp <- httr2::req_perform(req = req)

  if (httr2::resp_is_error(resp = resp)) {
    print_error(
      paste0(
        "SIDRA API request failed with status: ",
        httr2::resp_status(resp = resp)
        )
      )
  } else {
    data <- httr2::resp_body_json(resp = resp, simplifyDataFrame = TRUE)
    print_ok("Extraction completed.")
    return(data)
  }

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


# GDP growth (rate of change of the quarterly volume index from IBGE)
raw_gdp_pct <- import_sidra(api = parameters$gdp_pct, source = "GDP (%)/SIDRA")


# GDP (values at current prices from IBGE)
raw_gdp_brl <- import_sidra(api = parameters$gdp_brl, source = "GDP (R$)/SIDRA")


# PMC (retail trade from IBGE)
raw_pmc <- import_sidra(api = parameters$pmc, source = "PMC/SIDRA")


# PMC (expanded retail trade from IBGE)
raw_pmc_expanded <- import_sidra(
  api    = parameters$pmc_expanded,
  source = "PMC expanded/SIDRA"
  )


# PMS (Monthly Service Survey from IBGE)
raw_pms <- import_sidra(api = parameters$pms, source = "PMS/SIDRA")


# PIM (Monthly Industrial Survey from IBGE - YoY rate of change)
raw_pim <- import_sidra(api = parameters$pim)
