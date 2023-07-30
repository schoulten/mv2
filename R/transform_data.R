
# Code to data wrangling the imported data


# Economic activity -------------------------------------------------------

# Console messages
cli::cli_h1("Starting data wrangling")
cli::cli_h2("Economic activity")


# |-- ICVA (Cielo) ----
tbl_icva <- raw_icva |>
  dplyr::rename_with(.fn = ~"variable", .cols = dplyr::all_of("Visão")) |>
  dplyr::select(-dplyr::all_of(c("Setor", "Localidade"))) |>
  tidyr::pivot_longer(
    cols      = -"variable",
    names_to  = "date",
    values_to = "value"
    ) |>
  dplyr::filter(variable == "Deflacionado - Com Ajuste Calendário") |>
  dplyr::mutate(
    value = value * 100,
    date  = janitor::excel_numeric_to_date(as.numeric(date)),
    .keep = "none"
    ) |>
  dplyr::as_tibble()

# Check dimensions
check_dimensions(df = tbl_icva, source = "ICVA")


# |-- Vehicle Production (ANFAVEA) ----
anfavea <- raw_anfavea

anfavea |>
  dplyr::select(
    "date" = where(is_date),
    "value" = dplyr::all_of("Produção...5")
    )
  dplyr::na_if(0) %>%
  tidyr::drop_na() %>%
  mutate(
    date = lubridate::as_date(date),
    value = round(value / 1e3, 1) %>% paste0("k")
  ) %>%
  filter(date == last(date))
