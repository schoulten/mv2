
# URLs to extract raw data from several sources


# Economic activity -------------------------------------------------------

# Create list of URLs
urls_econ_activity <- list(

  # ICVA (spreadsheet data of the Cielo Index)
  icva = paste0(
    "https://api.mziq.com/mzfilemanager/v2/d/4d1ebe73-b068-4443-992a-3d72d57",
    "3238c/163a9070-918c-2f20-035e-b40da951bc9f?origin=2"
    ),

  # Vehicle Production (spreadsheet data from ANFAVEA)
  anfavea = paste0(
    "http://www.anfavea.com.br/docs/SeriesTemporais_Autoveiculos.xlsm"
    )
)
