# This script is used to visualize the structural alignment RMSD 
# between the MD final structures (45–50 ns averaged) and the AlphaFold predicted structure.
# Simulations were performed at three different temperatures: 280 K, 300 K, and 320 K.

library(ggplot2)

# 1. Create data frame for alignment RMSD results
# RMSD data obtained from PyMOL align command
rmsd_data <- data.frame(
  temp = c("280K", "300K", "320K"),        # Temperature conditions
  rmsd = c(1.455, 2.290, 2.700)/10          # RMSD (Å) converted to nm
)

# 2. Figure2D: Alignment RMSD at different temperatures
ggplot(rmsd_data, aes(x = temp, y = rmsd, fill = temp)) +
  geom_col(width = 0.3, show.legend = FALSE) +
  
  # Show RMSD value on top of each bar
  geom_text(aes(label = sprintf("%.4f", rmsd)), vjust = -0.5, size = 4) +
  
  # Consistent color scheme with all other figures
  scale_fill_manual(values = c("280K"="#6090C1", "300K"="#fee395", "320K"="#f2724D")) +
  
  scale_y_continuous(limits = c(0, 0.3), expand = c(0, 0)) +
  
  labs(x = "Temperature",
       y = "RMSD (nm)",
       title = "RMSD between AlphaFold and MD structures") +
  
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text = element_text(size = 11),
    legend.position = "none"
  )
