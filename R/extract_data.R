
# Code to extract data from several online sources


# Packages ----------------------------------------------------------------

# Explicity load packages
library(jsonlite)


# Get functions -----------------------------------------------------------

# Funcion to import Excel files
import_xls <- retry(fun = rio::import)

# Function to import SIDRA tables
import_sidra <- function(api) {

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
    return(data)
  }

}


# Economic activity -------------------------------------------------------

# ICVA (Cielo)
print_info("Extracting ICVA data...")
raw_icva <- import_xls(
  file   = urls_econ_activity$icva,
  format = "xlsx",
  sheet  = "Índice Mensal",
  skip   = 6,
  n_max  = 4,
  na     = "-"
  )
print_ok("Extraction completed.")


# Vehicle Production (ANFAVEA)
print_info("Extracting ANFAVEA data...")
raw_anfavea <- import_xls(
  file   = urls_econ_activity$anfavea,
  format = "xlsx",
  skip   = 4
  )
print_ok("Extraction completed.")

# GDP growth (rate of change of the quarterly volume index from IBGE)
print_info("Extracting GDP/SIDRA data...")
raw_gdp <- import_sidra(api = parameters_econ_activity$gdp)
print_ok("Extraction completed.")


