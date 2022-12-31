
# Code to extract data from several online sources


# Get functions -----------------------------------------------------------

# Funcion to import Excel files
import_xls <- retry(fun = rio::import)


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
