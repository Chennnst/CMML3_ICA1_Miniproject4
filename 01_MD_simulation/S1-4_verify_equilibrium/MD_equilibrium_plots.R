# Adapted from MD_plots.R provided in CMML3 Week 3 Practical 2
# This script is used to check whether the MD simulations at each temperature have reached equilibrium
# All xvg files are extracted from GROMACS MD simulation outputs.
# The energy minimization result is shared by all temperature systems.
# Temperature, pressure, and density outputs are unique for each temperature system.

library(ggplot2)

# Set working directory
# setwd("/verify_equilibrium")

# 1. Energy minimization
# Reads potential.xvg
potential <- read.table("potential.xvg", sep = "" , header = FALSE , skip = 24, na.strings = "",
                        stringsAsFactors = FALSE)

ggplot(data = potential, aes(x = V1, y = V2)) +
  geom_line() +
  geom_point() +
  ylim(min(potential$V2), 0) +
  labs(x = "Energy Minimization Step", y = bquote("Potential Energy (kJ "*~mol^-1*')')) +
  ggtitle("Energy Minimization, Steepest Descent") +
  theme_bw() +
  theme(plot.title = element_text(size = rel(1.5), face = "bold"))

# 2. Function to plot equilibrium properties
# Includes 10 ps running average to assess stabilization
plot_equilibration <- function(file_path, y_label, plot_title) {
  data <- read.table(file_path, sep = "", header = FALSE, skip = 24,
                     na.strings = "", stringsAsFactors = FALSE)
  
  # Calculate 10 ps running average
  data$average10ps <- NA
  data$average10ps[10:nrow(data)] <- sapply(10:nrow(data), function(x){mean(data$V2[(x-9):x])})
  
  ggplot(data = data, aes(x = V1, y = V2)) +
    geom_line() +
    geom_point() +
    geom_line(aes(y = average10ps), color = "red", linewidth = 0.8) +
    labs(x = "Time (ps)", y = y_label) +
    ggtitle(plot_title) +
    theme_bw() +
    theme(legend.position = "none",
          plot.title = element_text(size = rel(1.5), face = "bold"))
}

# 3. Temperature equilibration (NVT) and Pressure / Density equilibration (NPT)
# Loop over all temperature systems: 280K, 300K, 320K
temps <- c("280K", "300K", "320K")

for (temp in temps) {
  
  # Temperature plot during NVT equilibration
  p_temp <- plot_equilibration(
    file_path = paste0(temp, "/temperature.xvg"),
    y_label = "Temperature (K)",
    plot_title = paste0("Temperature, NVT equilibration (", temp, ")")
  )
  print(p_temp)
  
  # Pressure plot during NPT equilibration
  p_press <- plot_equilibration(
    file_path = paste0(temp, "/pressure.xvg"),
    y_label = "Pressure (bar)",
    plot_title = paste0("Pressure, NPT equilibration (", temp, ")")
  )
  print(p_press)
  
  # Density plot during NPT equilibration
  p_dens <- plot_equilibration(
    file_path = paste0(temp, "/density.xvg"),
    y_label = bquote("Density (kg "*~m^-3*')'),
    plot_title = paste0("Density, NPT equilibration (", temp, ")")
  )
  print(p_dens)
}
