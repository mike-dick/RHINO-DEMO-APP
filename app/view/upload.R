box::use(
  shiny[...],
  DT[...],
  DBI
)

# box::use(
#   app/logic/helpers[db_insert],
#   app/logic/helpers[db_fetch]
# )


#' @export
ui <- function(id) {
  ns <- NS(id)

  bootstrapPage(
    tags$div(
      class = "title",
      tags$h1("Amador Demo App")
      ################experiment-start################
      # tags$img(src = "amadorlogo.png", height = 500, width = 500),
      # imageOutput('image')
      ################experiment-end################
    ),
    tagList(
      div(
      class = "upload-container",
      h2("Upload"),
      fileInput(ns('target_upload'), 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  '.csv'
                )),
      ),
      h3("Uploading the following:"),
      DT::dataTableOutput(ns("table")),
      div(
        class = "line-break"
      ),
      div(
        class = "sqlite-store-1",
        h3("SQLite store1:"),
      ),
        DT::dataTableOutput(ns("con_table")),
    )
  )
  
}

#' @export
server <- function(id, con) {
  moduleServer(
    id, 
    function(input, output, session) {
      
      # Reactive upload df
      df_products_upload <- reactive({
        inFile <- input$target_upload
        if (is.null(inFile))
          return(NULL)
        df <- utils::read.csv(inFile$datapath)
        return(df)
      })
      
      # Render upload table
      output$table <- DT::renderDataTable({
        df <- df_products_upload()
        req(df)
        DBI::dbWriteTable(session$userData$con, "raw", df_products_upload())
        DBI::dbWriteTable(session$userData$con, "save", df_products_upload())
        output$con_table <- DT::renderDataTable({
          DT::datatable(DBI::dbGetQuery(session$userData$con, "SELECT * FROM raw"))
        })
        session$userData$raw <- df
        DT::datatable(df)
      })
      ################experiment-start################
      output$image <- renderImage({
        list(src = "amadorlogo.png",
             alt = "Amador Logo")
      }, deleteFile = FALSE)
      ################experiment-end################
      
      
      # return(reactive({ df_products_upload() }))
    }
  )
}