
# API parameters to extract raw data from several sources


# Economic activity -------------------------------------------------------

# Create list of URLs
parameters_econ_activity <- list(

  # GDP (percent changes)
  gdp = paste0(
    "/t/5932/n1/all/v/all/p/all/c11255/90687,90691,90696,90707,93404,93405,",
    "93406,93407,93408/d/v6561%201,v6562%201,v6563%201,v6564%201"
    ),

  # GDP (R$ million, current prices)
  gdp_brl = paste0(
    "/t/1846/n1/all/v/all/p/all/c11255/90687,90691,90696,90707,93404,93405,",
    "93406,93407,93408/d/v585%200"
    ),

  # PMC (retail trade from IBGE)
  pmc = "/t/3416/n1/all/v/all/p/all/c11046/90668/d/v564%201,v565%201",

  # PMC (expanded retail trade from IBGE)
  pmc_expanded = paste0(
    "/t/3417/n1/all/v/all/p/all/c11046/90668/d/v1186%201,v1190%201"
    ),

  # PMS (Monthly Service Survey from IBGE)
  pms = "/t/6442/n1/all/v/all/p/all/c11046/90668/d/v8676%201,v8677%201",

  # PIM (Monthly Industrial Survey from IBGE - YoY rate of change)
  pim = paste0(
    "/t/3653/n1/all/v/3139/p/all/c544/129314,129315,129316,129338/d/v3139%201"
    )

  )