% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_coreness.R
\name{get_coreness}
\alias{get_coreness}
\title{Get coreness values for graph nodes}
\usage{
get_coreness(graph, direction = "all")
}
\arguments{
\item{graph}{a graph object of class
\code{dgr_graph}.}

\item{direction}{using \code{all} (the default), the
search will ignore edge direction while traversing
through the graph. With \code{out}, measurements of
paths will be from a node whereas with \code{in},
measurements of paths will be to a node.}
}
\value{
a data frame with coreness values for
each of the nodes.
}
\description{
Get the coreness values for all nodes
in a graph.
}
\examples{
# Create a random graph
graph <-
  create_random_graph(
    n = 10, m = 22,
    set_seed = 23)

# Get coreness values for all nodes
# in the graph
get_coreness(graph)
#>    id coreness
#> 1   1        3
#> 2   2        3
#> 3   3        3
#> 4   4        3
#> 5   5        3
#> 6   6        3
#> 7   7        3
#> 8   8        2
#> 9   9        3
#> 10 10        3

# Add the coreness values to the graph
# as a node attribute
graph <-
  graph \%>\%
  join_node_attrs(
    df = get_coreness(.))

# Display the graph's node data frame
get_node_df(graph)
#>    id type label value coreness
#> 1   1 <NA>     1   6.0        3
#> 2   2 <NA>     2   2.5        3
#> 3   3 <NA>     3   3.5        3
#> 4   4 <NA>     4   7.5        3
#> 5   5 <NA>     5   8.5        3
#> 6   6 <NA>     6   4.5        3
#> 7   7 <NA>     7  10.0        3
#> 8   8 <NA>     8  10.0        2
#> 9   9 <NA>     9   8.5        3
#> 10 10 <NA>    10  10.0        3
}
