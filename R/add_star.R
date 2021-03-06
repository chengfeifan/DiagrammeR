#' Add a star of nodes to the graph
#' @description With a graph object of class
#' \code{dgr_graph}, add a node star to the graph.
#' @param graph a graph object of class
#' \code{dgr_graph}.
#' @param n the number of nodes comprising the star.
#' The first node will be the center of the star.
#' @param type an optional string that describes the
#' entity type for the nodes to be added.
#' @param label either a vector object of length
#' \code{n} that provides optional labels for the new
#' nodes, or, a boolean value where setting to
#' \code{TRUE} ascribes node IDs to the label and
#' \code{FALSE} yields a blank label.
#' @param rel an optional string for providing a
#' relationship label to all new edges created in the
#' node star.
#' @param ... optional node attributes supplied as
#' vectors.
#' @return a graph object of class \code{dgr_graph}.
#' @examples
#' # Create a new graph and add 2 stars of
#' # varying numbers of nodes
#' graph <-
#'   create_graph() %>%
#'   add_star(
#'     n = 4,
#'     type = "four_star") %>%
#'   add_star(
#'     n = 5,
#'     type = "five_star")
#'
#' # Get node information from this graph
#' node_info(graph)
#' #>   id      type label deg indeg outdeg loops
#' #> 1  1 four_star     1   3     0      3     0
#' #> 2  2 four_star     2   1     1      0     0
#' #> 3  3 four_star     3   1     1      0     0
#' #> 4  4 four_star     4   1     1      0     0
#' #> 5  5 five_star     1   4     0      4     0
#' #> 6  6 five_star     2   1     1      0     0
#' #> 7  7 five_star     3   1     1      0     0
#' #> 8  8 five_star     4   1     1      0     0
#' #> 9  9 five_star     5   1     1      0     0
#'
#' # Attributes can be specified in extra
#' # arguments and these are applied in order;
#' # Usually these attributes are applied to
#' # nodes (e.g., `type` is a node attribute)
#' # but the `rel` attribute will apply to the
#' # edges
#' graph_w_attrs <-
#'   create_graph() %>%
#'   add_star(
#'     n = 6,
#'     label = c("one", "two",
#'               "three", "four",
#'               "five", "six"),
#'     type = c("a", "a",
#'              "b", "b",
#'              "c", "c"),
#'     value = c(1.2, 8.4,
#'               3.4, 5.2,
#'               6.1, 2.6),
#'     rel = "star")
#'
#' # Get the graph's node data frame
#' get_node_df(graph_w_attrs)
#' #>   id type label value
#' #> 1  1    a   one   1.2
#' #> 2  2    a   two   8.4
#' #> 3  3    b three   3.4
#' #> 4  4    b  four   5.2
#' #> 5  5    c  five   6.1
#' #> 6  6    c   six   2.6
#'
#' # Get the graph's edge data frame
#' get_edge_df(graph_w_attrs)
#' #>   id from to  rel
#' #> 1  1    1  2 star
#' #> 2  2    1  3 star
#' #> 3  3    1  4 star
#' #> 4  4    1  5 star
#' #> 5  5    1  6 star
#' @importFrom dplyr select bind_cols
#' @importFrom tibble as_tibble
#' @export add_star

add_star <- function(graph,
                     n,
                     type = NULL,
                     label = TRUE,
                     rel = NULL,
                     ...) {

  # Get the time of function start
  time_function_start <- Sys.time()

  # Validation: Graph object is valid
  if (graph_object_valid(graph) == FALSE) {
    stop("The graph object is not valid.")
  }

  # Stop if n is too small
  if (n <= 3) {
    stop("The value for `n` must be at least 4.")
  }

  # Create bindings for specific variables
  id <- index__ <- NULL

  # Get the number of nodes ever created for
  # this graph
  nodes_created <- graph$last_node

  # Get the number of edges ever created for
  # this graph
  edges_created <- graph$last_edge

  # Get the graph's global attributes
  global_attrs <- graph$global_attrs

  # Get the graph's log
  graph_log <- graph$graph_log

  # Get the graph's info
  graph_info <- graph$graph_info

  # Get the graph's state of being directed
  # or undirected
  graph_directed <- graph$directed

  # Get the sequence of nodes required
  nodes <- seq(1, n)

  # Collect extra vectors of data as `extras`
  extras <- list(...)

  if (length(extras) > 0) {

    extras_tbl <- tibble::as_tibble(extras)

    if (nrow(extras_tbl) < length(nodes)) {

      extras$index__ <- 1:length(nodes)

      extras_tbl <-
        tibble::as_tibble(extras) %>%
        dplyr::select(-index__)
    }

    if ("id" %in% colnames(extras_tbl)) {
      extras_tbl <-
        extras_tbl %>%
        dplyr::select(-id)
    }
  }

  # Create a node data frame for the star graph
  star_nodes <-
    create_node_df(
      n = length(nodes),
      type = type,
      label = label)

  # Add extra columns if available
  if (exists("extras_tbl")) {

    star_nodes <-
      star_nodes %>%
      dplyr::bind_cols(extras_tbl)
  }

  # Create an edge data frame for the star graph
  star_edges <-
    create_edge_df(
      from = rep(nodes[1], n - 1),
      to = nodes[2:length(nodes)],
      rel = rel)

  # Create the star graph
  star_graph <-
    create_graph(
      directed = graph_directed,
      nodes_df = star_nodes,
      edges_df = star_edges)

  # If the input graph is not empty, combine graphs
  # using the `combine_graphs()` function
  if (!is_graph_empty(graph)) {

    combined_graph <- combine_graphs(graph, star_graph)

    # Update the `last_node` counter
    combined_graph$last_node <- nodes_created + nrow(star_nodes)

    # Update the `last_edge` counter
    combined_graph$last_edge <- edges_created + nrow(star_edges)

    # Update the `graph_log` df with an action
    graph_log <-
      add_action_to_log(
        graph_log = graph_log,
        version_id = nrow(graph_log) + 1,
        function_used = "add_star",
        time_modified = time_function_start,
        duration = graph_function_duration(time_function_start),
        nodes = nrow(combined_graph$nodes_df),
        edges = nrow(combined_graph$edges_df))

    combined_graph$global_attrs <- global_attrs
    combined_graph$graph_log <- graph_log
    combined_graph$graph_info <- graph_info

    # Perform graph actions, if any are available
    if (nrow(combined_graph$graph_actions) > 0) {
      combined_graph <-
        combined_graph %>%
        trigger_graph_actions()
    }

    # Write graph backup if the option is set
    if (combined_graph$graph_info$write_backups) {
      save_graph_as_rds(graph = combined_graph)
    }

    return(combined_graph)
  } else {

    # Update the `graph_log` df with an action
    graph_log <-
      add_action_to_log(
        graph_log = graph_log,
        version_id = nrow(graph_log) + 1,
        function_used = "add_star",
        time_modified = time_function_start,
        duration = graph_function_duration(time_function_start),
        nodes = nrow(star_graph$nodes_df),
        edges = nrow(star_graph$edges_df))

    star_graph$global_attrs <- global_attrs
    star_graph$graph_log <- graph_log
    star_graph$graph_info <- graph_info

    # Perform graph actions, if any are available
    if (nrow(star_graph$graph_actions) > 0) {
      star_graph <-
        star_graph %>%
        trigger_graph_actions()
    }

    # Write graph backup if the option is set
    if (star_graph$graph_info$write_backups) {
      save_graph_as_rds(graph = star_graph)
    }

    return(star_graph)
  }
}
