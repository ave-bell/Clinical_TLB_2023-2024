library(tidyverse)
library(clinicalDSCdata)
library(fpc)
library(cluster)
library(factoextra)
library(ClusterR)

codes <- c('SCL', 'RAF', 'JOF', 'ERA', 'ROF', 'CCP', 'CEN', 'CHR', 'S70') #LUF

groups <- MixedThermograms %>%
  filter(code %in% codes) %>% 
  group_by(code) %>% 
  summarize( count = n())

# get labels
# labs <- as.numeric(factor(MixedThermograms$DiseaseGroup))
# labs_1 <- data.frame(Disease = unique(factor(MixedThermograms$DiseaseGroup)), Cluster_Num = unique(labs))
# 
# labels <- as.factor(MixedThermograms$DiseaseGroup)

cluster_df <- MixedThermograms %>%
  filter(code %in% codes)%>% 
  select(c(3, T50:T83))

labs <- MixedThermograms %>% 
  filter(code %in% codes)%>% 
  select(DiseaseGroup) 

labs_1 <- as.factor(labs$DiseaseGroup)


labs <- as.numeric(as.factor(labs$DiseaseGroup))

cluster_df <- column_to_rownames(cluster_df, 'sampleID')

# cluster_df_1_1 <- t(cluster_df)
# 
# cluster_df_1_2 <- diff(cluster_df_1_1)
# 
# cluster_df_1 <- as.data.frame(t(cluster_df_1_2))

gower.dist <- daisy(cluster_df, metric = 'gower')
class(gower.dist)

# Using "complete" linkage - agglomerative
agg_clust_c <- hclust(gower.dist, method = "complete")

# Using "complete" linkage - divisive
divisive_clust <- diana(as.matrix(gower.dist), 
                        diss = TRUE, keep.diss = TRUE)


result_df <- data.frame(k = numeric(), purity = numeric(), silhouette = numeric(), twss = numeric())

for (k in 2:length(unique(labs))) {
  
  # Agglomerative clustering
  clusters_agg <- cutree(agg_clust_c, k = k)
  
  # Divisive clustering
  clusters_div <- cutree(divisive_clust, k = k)
  
  # Calculate cluster statistics for agglomerative clustering
  cluster_stats_agg <- cluster.stats(gower.dist, clusters_agg)
  
  # Calculate purity for agglomerative clustering
  purity_result_agg <- external_validation(clusters_agg, labs, method = "purity")
  
  # Calculate silhouette for agglomerative clustering
  silhouette_result_agg <- cluster_stats_agg$avg.silwidth
  
  # Calculate TWSS for agglomerative clustering
  twss_result_agg <- cluster_stats_agg$within.cluster.ss
  
  # Calculate cluster statistics for divisive clustering
  cluster_stats_div <- cluster.stats(gower.dist, clusters_div)
  
  # Calculate purity for divisive clustering
  purity_result_div <- external_validation(clusters_div, labs, method = "purity")
  
  # Calculate silhouette for divisive clustering
  silhouette_result_div <- cluster_stats_div$avg.silwidth
  
  # Calculate TWSS for divisive clustering
  twss_result_div <- cluster_stats_div$within.cluster.ss
  
  # Combine all results into a single dataframe for agglomerative clustering
  cluster_results_agg <- data.frame(k = k, method = "agglomerative", 
                                    purity = purity_result_agg, silhouette = silhouette_result_agg, 
                                    twss = twss_result_agg)
  
  # Combine all results into a single dataframe for divisive clustering
  cluster_results_div <- data.frame(k = k, method = "divisive", 
                                    purity = purity_result_div, silhouette = silhouette_result_div, 
                                    twss = twss_result_div)
  
  # Append the results to result_df
  result_df <- rbind(result_df, cluster_results_agg, cluster_results_div)
  
}



fviz_dend(x = divisive_clust, cex = 0.8, lwd = 0.8, k = 4,
          k_colors = c("jco"),
          rect = TRUE, 
          rect_border = "jco", 
          rect_fill = TRUE)

rclusters <- cutree(agg_clust_c, k = 9)
# Create a contingency table
contingency_table <- table(Disease = labs_1, Clusters = rclusters)

# Calculate proportions
proportions <- prop.table(contingency_table, margin = 1)
