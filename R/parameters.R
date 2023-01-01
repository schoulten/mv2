
# API parameters and URLs to extract raw data from several sources


# Economic activity -------------------------------------------------------

# Create list of parameters/URLs
parameters_econ_activity <- list(

  # ICVA (spreadsheet data, Cielo)
  icva = paste0(
    "https://api.mziq.com/mzfilemanager/v2/d/4d1ebe73-b068-4443-992a-3d72d57",
    "3238c/163a9070-918c-2f20-035e-b40da951bc9f?origin=2"
    ),

  # Vehicle Production (spreadsheet data, ANFAVEA)
  anfavea = paste0(
    "http://www.anfavea.com.br/docs/SeriesTemporais_Autoveiculos.xlsm"
    ),

  # GDP (percent changes, IBGE)
  gdp_pct = paste0(
    "/t/5932/n1/all/v/all/p/all/c11255/90687,90691,90696,90707,93404,93405,",
    "93406,93407,93408/d/v6561%201,v6562%201,v6563%201,v6564%201"
    ),

  # GDP (R$ million, current prices, IBGE)
  gdp_brl = paste0(
    "/t/1846/n1/all/v/all/p/all/c11255/90687,90691,90696,90707,93404,93405,",
    "93406,93407,93408/d/v585%200"
    ),

  # PMC (retail trade, IBGE)
  pmc = "/t/3416/n1/all/v/all/p/all/c11046/90668/d/v564%201,v565%201",

  # PMC (expanded retail trade, IBGE)
  pmc_expanded = paste0(
    "/t/3417/n1/all/v/all/p/all/c11046/90668/d/v1186%201,v1190%201"
    ),

  # PMS (Monthly Service Survey, IBGE)
  pms = "/t/6442/n1/all/v/all/p/all/c11046/90668/d/v8676%201,v8677%201",

  # PIM (Monthly Industrial Survey, YoY rate of change, IBGE)
  pim = paste0(
    "/t/3653/n1/all/v/3139/p/all/c544/129314,129315,129316,129338/d/v3139%201"
    )

  )



# Full list ---------------------------------------------------------------

# All parameters and URLs
parameters <- c(parameters_econ_activity)
