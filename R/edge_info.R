#' Get detailed information on edges
#' @description Obtain a data frame with
#' detailed information on edges and
#' their interrelationships within a graph.
#' @param graph a graph object of class
#' \code{dgr_graph}.
#' @return a data frame containing information
#' specific to each edge within the graph.
#' @examples
#' # Create a node data frame (ndf)
#' ndf <-
#'   create_node_df(
#'     n = 4,
#'     label = TRUE,
#'     type = c("A", "A", "B", "C"))
#'
#' # Create an edge data frame (edf)
#' edf <-
#'   create_edge_df(
#'     from = c(1, 3, 3, 4),
#'     to = c(2, 2, 1, 3),
#'     rel = c("X", "Y", "Y", "Z"))
#'
#' # Create a graph using the ndf and edf
#' graph <-
#'   create_graph(
#'     nodes_df = ndf,
#'     edges_df = edf)
#'
#' # Get a data frame with information about
#' # the graph's edges
#' edge_info(graph)
#' #>   id from to rel
#' #> 1  1    1  2   X
#' #> 2  2    3  2   Y
#' #> 3  3    3  1   Y
#' #> 4  4    4  3   Z
#' @importFrom dplyr select_
#' @export edge_info

edge_info <- function(graph) {

  # Validation: Graph object is valid
  if (graph_object_valid(graph) == FALSE) {
    stop("The graph object is not valid.")
  }

  # For graphs with no edges, return NA
  if (nrow(graph$edges_df) == 0) {
    return(NA)
  }

  # Extract only the first 4 columns of the
  # edge data frame
  graph$edges_df %>%
    dplyr::select_("id", "from", "to", "rel")
}
