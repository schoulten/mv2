
# Create functions to import data from several sources


# Funcion to import Excel files
import_xls <- function(url, source = NULL, ...) {

  print_info(paste(c("Extracting", source, "data..."), collapse = " "))

  req <- http_req(url = url)

  resp <- http_resp(req = req, path = tempfile(fileext = ".xlsx"))

  if (httr2::resp_is_error(resp = resp)) {
    http_error_message(response = resp, source = "Excel file")
  } else {
    data <- readxl::read_xlsx(path = resp$body, ...)
    print_ok("Extraction completed.")
    return(data)
  }

}


# Function to import SIDRA tables
import_sidra <- function(api, source = NULL) {

  is_installed("jsonlite")

  print_info(paste(c("Extracting", source, "data..."), collapse = " "))

  req <- http_req(
    url = paste0("https://apisidra.ibge.gov.br/values", api, "?formato=json")
    )

  resp <- http_resp(req = req)

  if (httr2::resp_is_error(resp = resp)) {
    http_error_message(response = resp, source = "API SIDRA")
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

  if (is.null(start)) {
    start <- start
  } else if (is_date(start)) {
    start <- paste0("&dataInicial=", format_dmy(start))
  } else {
    print_error(c("x" = paste0("{.var start} must be Date.")))
  }

  if (is.null(end)) {
    end <- end
  } else if (is_date(end)) {
    end <- paste0("&dataFinal=", format_dmy(end))
  } else {
    print_error(c("x" = paste0("{.var end} must be Date.")))
  }

  is_installed("jsonlite")

  req <- http_req(url = paste0(base_url, start, end))

  code_names <- names(code)
  null_names <- is.null(code_names)
  print_info(
    paste(
      c(
        "Extracting",
        ifelse(
          null_names,
          paste0("SGS (code = ", code, ")"),
          paste0("SGS (", code_names, " = ", code, ")")
          ),
        "data..."
        ),
      collapse = " "
      )
    )

  resp <- http_resp(req = req)

  if (httr2::resp_is_error(resp = resp)) {
    http_error_message(response = resp, source = "SGS/BCB API")
  } else {
    data <- httr2::resp_body_json(resp = resp, simplifyDataFrame = TRUE)
    print_ok("Extraction completed.")
  }

  return(data)

}
