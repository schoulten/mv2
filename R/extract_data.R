
# Code to extract data from several online sources


# Get functions -----------------------------------------------------------

# Funcion to import Excel files
import_xls <- retry(fun = rio::import)


# Economic activity -------------------------------------------------------

# ICVA (Cielo)
raw_icva <- import_xls(
  file   = urls_econ_activity$icva,
  format = "xlsx",
  sheet  = "Índice Mensal",
  skip   = 6,
  n_max  = 4,
  na     = "-"
  )
