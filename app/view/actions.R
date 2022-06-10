box::use(
  shiny[...],
  DT[...],
  dplyr #installed
)

# box::use(
#   app/logic/helpers[db_insert],insta
#   app/logic/helpers[db_df]
# )

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    tagList(
      div(
      class = "action-container",
      h2("Actions"),
      
      selectInput("action", "Action:",
                  c("",
                    "Delete Column" = "del_col",
                    "Delete Row" = "del_row")),
      conditionalPanel("input.action == 'del_col'",
                       textInput(ns("col"), "Column to be deleted(Name)"),
                       actionButton(ns("del_col_btn"), "Delete")),
      conditionalPanel("input.action == 'del_row'",
                       textInput(ns("row"), "Row to be deleted(Number)"),
                       actionButton(ns("del_row_btn"), "Delete")),
      
      actionButton(ns("back_btn"), "<"),
      actionButton(ns("forward_btn"), ">"),
      checkboxInput(ns("saving"), "Save edits", TRUE),
      ),
      div(
        class = "local-dataframe",
        h3("Local dataframe:"),
      ),
      div(
        class = "line-break"
      ),
      DT::dataTableOutput(ns("table")),
      div(
        class = "sqlite-store-1",
        h3("SQLite store2:"),
        ),
      DT::dataTableOutput(ns("con_table")),
      
    )
  )
  
}

#' @export
server <- function(id) {
  moduleServer(
    id, 
    function(input, output, session) {
      
      # General update before each action
      preaction <- function() {
        # Set current dataframe
        if (is.null(session$userData$curr_df)) {
          session$userData$history <<- list(session$userData$raw)
          session$userData$curr_df <<- session$userData$raw
        } else {
          session$userData$curr_df <<- data.frame(session$userData$curr_df)
          session$userData$history <<- session$userData$history[0:session$userData$curr_ind]
        }
        
        
      }
      
      # General update after each action
      postaction <- function() {
        # Render new table
        if (!is.null(session$userData$curr_df)) {
          output$table <- DT::renderDataTable(session$userData$curr_df)
        }
        
        # Store in history
        session$userData$history <<- c(session$userData$history, list(session$userData$curr_df))
        session$userData$curr_ind <<- session$userData$curr_ind + 1
        
        # Store in database
        if (input$saving) {
          DBI::dbWriteTable(session$userData$con, "save", session$userData$curr_df, overwrite = TRUE)
        }
        output$con_table <- DT::renderDataTable({
          DT::datatable(DBI::dbGetQuery(session$userData$con, "SELECT * FROM save"))
        })
        
      }
      
      # Back button
      observeEvent(input$back_btn, {
        if (!is.null(session$userData$history) && session$userData$curr_ind > 1) {
          session$userData$curr_ind <<- session$userData$curr_ind - 1
          session$userData$curr_df <<- session$userData$history[[session$userData$curr_ind]]
          output$table <- DT::renderDataTable(session$userData$curr_df)
        }
        cat("Back", file = "log.txt", sep = "\n", append = TRUE)
      })
      
      # Forward button
      observeEvent(input$forward_btn, {
        if (!is.null(session$userData$history) && session$userData$curr_ind < length(session$userData$history)) {
          session$userData$curr_ind <<- session$userData$curr_ind + 1
          session$userData$curr_df <<- session$userData$history[[session$userData$curr_ind]]
          output$table <- DT::renderDataTable(session$userData$curr_df)
        }
        cat("Forward", file = "log.txt", sep = "\n", append = TRUE)
      })
      
      # Action: Delete column
      observeEvent(input$del_col_btn, {
        preaction()
        session$userData$curr_df <<- tidylog::select(session$userData$curr_df, -c(input$col))
        postaction()
      })
      
      # Action: Delete row
      observeEvent(input$del_row_btn, {
        preaction()
        temp_df <- session$userData$curr_df 
        temp_df <- tidylog::slice(temp_df, -strtoi(input$row))
        session$userData$curr_df <<- temp_df
        postaction()
      })
      
    }
  )
}