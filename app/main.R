# app/main.R

box::use(
  shiny[...],
  mongolite,
  DBI,
  rsconnect[...]
)

box::use(
  app/view/upload,
  app/view/actions,
  app/logic/helpers[init],
  app/logic/helpers[disc]
)

#rsconnect path
#' @export
ui <- function(id) {
  ns <- NS(id)
  
  bootstrapPage(
    upload$ui(ns("upload")),
    actions$ui(ns("actions"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    onStop(function() {
      disc(session)
    })
    init(session)
    
    upload$server("upload")
    actions$server("actions")
  })
}