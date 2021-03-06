
#' Generate a random port number
#'
#' Ideally, phantomjs should support a random port, assigned by the OS.
#' But it does not, so we generate one randomly and hope for the best.
#'
#' @param min lower limit
#' @param max upper limit
#' @return integer scalar, generated port number
#'
#' @keywords internal

random_port <- function(min = 3000, max = 9000) {
  if (min < max) sample(min:max, 1) else min
}

check_external <- function(x) {
  if (Sys.which(x) == "") {
    stop("Cannot start '", x, "', make sure it is in the path")
  }
}

parse_class <- function(x) {
  strsplit(x, "\\s+")[[1]]
}

`%||%` <- function(l, r) if (is.null(l)) r else l

#' @importFrom utils packageName

package_version <- function(pkg = packageName()) {
  asNamespace(pkg)$`.__NAMESPACE__.`$spec[["version"]]
}

`%+%` <- function(l, r) {
  assert_string(l)
  assert_string(r)
  paste0(l, r)
}

str <- function(x) as.character(x)
