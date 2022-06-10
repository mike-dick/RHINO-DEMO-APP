box::use(
  shiny[...],
  mongolite,
  tidylog
)

# Initialize 
#' @export
init <- function(session) {
  print("Initializing database")
  
  # Connect to database
  session$userData$con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  
  # Initialize current dataframe and history
  session$userData$curr_df <- NULL
  session$userData$history <- NULL
  session$userData$curr_ind <- 1
  
  # Output stream to log.txt
  cat("", file = "log.txt")
  log_to_file <- function(text) {
    cat(text, file = "log.txt", sep = "\n", append = TRUE)
  }
  options("tidylog.display" = list(message, log_to_file))
}

# Disconnect 
#' @export
disc <- function(session) {
  print("Doing application cleanup")
  
  # Save log to database (as if database is remote)
  DBI::dbWriteTable(session$userData$con, "log", "log.txt")
  
  # Disconnect database
  DBI::dbDisconnect(session$userData$con)
}

#' #' @export
#' db_insert <- function(df) {
#'   print("Inserting")
#'   con$insert(df)
#' }
#' 
#' #' @export
#' db_df <- function() {
#'   print("Returning df")
#'   return(con$find('{}'))
# }

