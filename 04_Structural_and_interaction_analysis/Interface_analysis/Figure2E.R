# This script is used to visualize the interface hydrogen bond number and interface area
# between the AlphaFold predicted structure and MD final averaged structures (45–50 ns) for Figure2E.
# Four groups are included: AlphaFold, MD 280 K, MD 300 K, and MD 320 K.
# Results of interface hydrogen bond number were obtained from PyMOL analysis.
# Results of interface area were obtained from PISA at PDBe website.

library(ggplot2)
library(tidyr)

# 1. Create data frame for interface interactions
# HBonds: number of interface hydrogen bonds; Area: interface area (Å²)
raw_data <- data.frame(
  temp = c("AlphaFold", "MD280K", "MD300K", "MD320K"),
  HBonds = c(18, 11, 11, 7),
  Area = c(853.4, 674.1, 764.2, 713.6)
)

# 2. Set axis ranges for dual-y plot visualization
hbond_limits <- c(0, 25)      # Left axis: range for hydrogen bond number
area_limits <- c(0, 900)      # Right axis: range for interface area

# 3. Calculate scaling parameters for dual y-axis transformation
scale <- (area_limits[2] - area_limits[1]) / (hbond_limits[2] - hbond_limits[1])
offset <- area_limits[1] - hbond_limits[1] * scale

# 4. Reshape data to long format for grouped bar plot
data_plot <- pivot_longer(raw_data, cols = c("HBonds", "Area"), names_to = "type", values_to = "orig_val")

# Map area values to the hydrogen bond coordinate system for visualization
data_plot$plot_val <- ifelse(data_plot$type == "HBonds", 
                             data_plot$orig_val, 
                             (data_plot$orig_val - offset) / scale)

# Set fixed x-axis order
data_plot$temp <- factor(data_plot$temp, levels = c("AlphaFold", "MD280K", "MD300K", "MD320K"))

# 5. Figure 2E: Grouped bar chart with dual y-axis
ggplot(data_plot, aes(x = temp, y = plot_val, fill = type)) +
  
  # Grouped bars
  geom_col(position = position_dodge(width = 0.5), width = 0.4) +
  
  # Show value labels on top of bars
  geom_text(
    aes(group = type, label = round(orig_val, 1)),
    position = position_dodge(width = 0.5), 
    vjust = -0.7, 
    size = 3.5
  ) +
  
  # Dual y-axis configuration
  scale_y_continuous(
    name = "Number of Hydrogen Bonds",
    limits = hbond_limits,
    expand = expansion(mult = c(0, 0.1)),
    sec.axis = sec_axis(~ . * scale + offset, name = "Interface Area (Å²)")
  ) +
  
  # Consistent color scheme with all other figures
  scale_fill_manual(
    values = c("HBonds" = "#6090C1", "Area" = "#f2724D"),
    labels = c("Interface H-bonds", "Interface Area (Å²)")
  ) +
  
  labs(x = "Groups", title = "Interface Interactions between AF and MD Sturcture") +
  
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.title.y.left = element_text(color = "#6090C1", face = "bold"),
    axis.title.y.right = element_text(color = "#f2724D", face = "bold"),
    legend.position = "top",
    axis.text.x = element_text(angle = 0, size = 10)
  )
