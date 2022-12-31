
# Code to extract data from several online sources


# Get functions -----------------------------------------------------------

# Funcion to import Excel files
import_xls <- retry(fun = rio::import)

# Function to import SIDRA tables
import_sidra <- function(api) {
  paste0("https://apisidra.ibge.gov.br/values", api) |>
    httr2::request() |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyDataFrame = TRUE)
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
#raw_gdp <- import_sidra(api = parameters_econ_activity$gdp)
test1 <- httr2::request(
  paste0("https://apisidra.ibge.gov.br/values", parameters_econ_activity$gdp)
  ) |> httr2::req_options(ssl_verifypeer = 0)
test2 <- httr2::req_perform(test1)
test3 <- httr2::resp_body_json(test2, simplifyDataFrame = TRUE)
print_ok("Extraction completed.")


