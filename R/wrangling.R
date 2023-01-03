
# Create functions to data wrangling routines


# Check if column names exist in a data frame
column_exist <- function(df, columns) {
  columns %in% colnames(df) |>
    setNames(nm = columns)
}


# Check if the dimensions of the data frame are not null
is_df_null <- function(df) {
  !all(dim(df) != 0L)
}
check_dimensions <- function(df, source) {
  if (is_df_null(df)) {
    print_error("One of the dimensions in the {.field source} tibble is null.")
  } else {
    print_ok(paste0("{.field ", source, "} tibble is OK!"))
  }
}
