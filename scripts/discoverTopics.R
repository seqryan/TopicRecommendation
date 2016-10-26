library(igraph)
library(tm)
library(Matrix)


setwd("C:\\Users\\ryan\\Documents\\GitHub\\TopicRecommendation\\data")
sparseToVector <- function(x)as.matrix(summary(x))

#mydf <- read.table(file='test.tsv', header=F, sep="\t", fileEncoding="UTF-8")
## tab-separated (header assumed)
tsv.data <- read.delim("hash_pair_02.tsv", header=T, sep="\t", fileEncoding="UTF-8")

A <- sparseMatrix(i = as.numeric(factor(tsv.data$hashtag)),
                j = as.numeric(factor(tsv.data$word)),
                x = rep(1, length(as.numeric(tsv.data$hashtag))))

rownames(A) <- levels(factor(tsv.data$hashtag)) 
colnames(A) <- levels(factor(tsv.data$word))


# one mode projectons
hashtag_projection <- A %*% t(A)
words_projection <- t(A) %*% A

graph = graph.adjacency(words_projection, mode = "undirected", weighted=TRUE)
graph = delete.edges(graph, which(E(graph)$weight <=2))
graph=delete.vertices(graph,which(degree(graph)<1))

deg <- degree(graph, mode="all")
V(graph)$size <- deg*6


E(graph)$width <- E(graph)$weight/6
E(graph)$arrow.size <- .2
E(graph)$edge.color <- "gray80"
E(graph)$width <- 1+E(graph)$weight/12

plot(graph, 
     vertex.label.font=2, vertex.label.color="gray40",
     vertex.label.cex=.7, edge.color="gray85", , layout = layout.fruchterman.reingold(graph))


