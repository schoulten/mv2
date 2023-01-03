
# Code to extract data from several online sources


# Economic activity -------------------------------------------------------

# Console messages
cli::cli_h1("Starting data extraction")
cli::cli_h2("Economic activity")


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
raw_pim <- import_sidra(api = parameters$pim, source = "PIM/SIDRA")


# Installed Capacity Utilization Level (NUCI/FGV)
raw_nuci <- import_sgs(code = parameters$nuci)


# IBC-Br (economic activity index, Central Bank of Brazil)
raw_ibc <- purrr::map(
  .x = parameters$ibc,
  .f = ~import_sgs(code = .x)
  )
