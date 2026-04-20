# This script is used to visualize Rg (Radius of Gyration) during 0-50 ns molecular dynamics simulations for Figure 1C, including three different temperatures: 280 K, 300 K, and 320 K.

library(ggplot2)

# Function used to read xyg file of Rg results
read_rg <- function(file) {
  df <- read.table(file, skip=27, header=FALSE, na.strings="")
  colnames(df) <- c("time", "value")
  df$time <- df$time / 1000
  return(df)
}

# 1. Read all the Rg data
# setwd("stability_analysis/Rg")
rg_280 <- read_rg("gyrate_280K_50ns.xvg")
rg_300 <- read_rg("gyrate_300K_50ns.xvg")
rg_320 <- read_rg("gyrate_320K_50ns.xvg")

# 2. Merge all data into one data frame for plotting
rg <- data.frame(
  time = rg_280$time,
  rg_280 = rg_280$value,
  rg_300 = rg_300$value,
  rg_320 = rg_320$value
)

# 3. Figure 1C: Rg (Radius of Gyration) during MD simulations
ggplot(data = rg, aes(x = time)) +
  geom_line(aes(y = rg_280, color = "280K"), linewidth=0.5) +
  geom_line(aes(y = rg_300, color = "300K"), linewidth=0.5) +
  geom_line(aes(y = rg_320, color = "320K"), linewidth=0.5) +
  
  scale_color_manual(values = c("280K"="#6090C1", "300K"="#fee395", "320K"="#f2724D")) +
  
  # Keep all data but limit y-axis view to reasonable range, avoiding broken lines from outliers.
  coord_cartesian(ylim = c(2.25, 2.6)) + 
  
  labs(x = "Time (ns)", y = bquote(~R[g]*" (nm)"), color="Temperature") +
  ggtitle("Radius of Gyration") +
  theme_bw() +
  theme(
    plot.title = element_text(face="bold", size=14, hjust = 0.5),
    legend.position = c(0.85, 0.2),
    legend.background = element_rect(fill="white", color="black", linewidth=0.4),
    legend.key.size = unit(0.4, "cm"),
    legend.text = element_text(size=9),
    legend.title = element_text(size=9),
    axis.title.x = element_text(size=12),
    axis.title.y = element_text(size=12),
    axis.text = element_text(size=11)
  )
