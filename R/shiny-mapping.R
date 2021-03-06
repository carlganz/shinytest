
#' Try to deduce the shiny input/output element type from its name
#'
#' @param self me
#' @param private private me
#' @param name The name of the Shiny input or output to search for.
#' @param iotype It is possible that an input has the same name as
#'   an output, and in this case there is no way to get element without
#'   knowing whether it is an input or output element.
#'
#' @keywords internal

app_find_widget <- function(self, private, name, iotype) {

  el <- self$find_element(css = paste0("#", name))
  el_input <- tryCatch(
    self$find_element(css = paste0("#", name, ".shiny-bound-input")),
    error = function(x) NULL
  )
  el_output <- tryCatch(
    self$find_element(css = paste0("#", name, ".shiny-bound-output")),
    error = function(x) NULL
  )

  res <- if (iotype == "auto") {
    find_input_widget(self, private, el_input) %||%
    find_output_widget(self, private, el_output) %||%
    find_input_widget(self, private, el) %||%
    find_output_widget(self, private, el)
  } else if (iotype == "input") {
    find_input_widget(self, private, el_input)
  } else {
    find_output_widget(self, private, el_output)
  }

  if (is.null(res)) {
    stop("Cannot find shiny input/output widget ", sQuote(name))
  }

  widget$new(
    name = name,
    element = res$element,
    type = res$type,
    iotype = res$iotype
  )
}

find_input_widget <- function(self, private, el) {

  if (is.null(el)) return(NULL)

  tag <- el$get_name()
  type <- el$get_attribute("type")
  class <- parse_class(el$get_attribute("class"))

  e <- function(name) {
    list(element = el, iotype = "input", type = name)
  }

  ## If a <button>, then it is an actionbutton
  if (tag == "button") return(e("actionButton"))

  ## Only checkboxInput has type "checkbox"
  if (tag == "input" && type == "checkbox") {
    return(e("checkboxInput"))
  }

  ## checkboxGroupInput has specific class
  if (tag == "div" && "shiny-input-checkboxgroup" %in% class) {
    return(e("checkboxGroupInput"))
  }

  ## dateInput has class
  if (tag == "div" && "shiny-date-input" %in% class) {
    return(e("dateInput"))
  }

  ## dateRangeInput has class
  if (tag == "div" && "shiny-date-range-input" %in% class) {
    return(e("dateRangeInput"))
  }

  ## fileInput has type "file"
  if (tag == "input" && type == "file") return(e("fileInput"))

  ## numericInput is <input> type number
  if (tag == "input" && type == "number") return(e("numericInput"))

  ## radioButtons has a class
  if (tag == "div" && "shiny-input-radiogroup" %in% class) {
    return(e("radioButtons"))
  }

  ## If tag is <select> it is a selectInput
  if (tag == "select") return(e("selectInput"))

  ## sliderInput has class js-range-slider
  if (tag == "input" && "js-range-slider" %in% class) {
    return(e("sliderInput"))
  }

  ## textInput has type
  if (tag == "input" && type == "text") return(e("textInput"))

  ## passwordInput has type
  if (tag == "input" && type == "password") return(e("passwordInput"))

  NULL
}

find_output_widget <- function(self, private, el) {

  if (is.null(el)) return(NULL)

  tag <- el$get_name()
  type <- el$get_attribute("type")
  class <- parse_class(el$get_attribute("class"))

  e <- function(name) {
    list(element = el, iotype = "output", type = name)
  }

  ## htmlOutput has class
  if ("shiny-html-output" %in% class) return(e("htmlOutput"))

  ## plotOutput has class
  if ("shiny-plot-output" %in% class) return(e("plotOutput"))

  ## tableOutput has classes datatables shiny-bound-output
  if ("datatables" %in% class && "shiny-bound-output" %in% class) {
    return(e("tableOutput"))
  }

  ## verbatimTextOutput is <pre> and has class
  if (tag == "pre" && "shiny-text-output" %in% class) {
    return(e("verbatimTextOutput"))
  }

  ## textOutput has the same class, but not <pre> (we assume)
  if (tag != "pre" && "shiny-text-output" %in% class) {
    return(e("textOutput"))
  }
}
