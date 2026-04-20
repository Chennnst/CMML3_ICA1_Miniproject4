# This script is used to visualize RMSD during 0-50 ns molecular dynamics simulations for Figure 1A-B, including three different temperatures: 280 K, 300 K, and 320 K.
# Two types of RMSD are plotted:
# 1. RMSD relative to the equilibrated structure (minimized, equilibrated)
# 2. RMSD relative to the crystal structure (original starting structure)

library(ggplot2)

# Function to read the xyg file of RMSD
read_rmsd <- function(file) {
  df <- read.table(file, skip=18, header=FALSE, na.strings="")
  colnames(df) <- c("time", "value")
  return(df)
}

# 1. Read all the RMSD data
# setwd("stability_analysis/RMSD") 

# 280K
rmsd_280_equil <- read_rmsd("rmsd_280K_50ns.xvg")
rmsd_280_orig  <- read_rmsd("rmsd_xtal_280K_50ns.xvg")

# 300K
rmsd_300_equil <- read_rmsd("rmsd_300K_50ns.xvg")
rmsd_300_orig  <- read_rmsd("rmsd_xtal_300K_50ns.xvg")

# 320K
rmsd_320_equil <- read_rmsd("rmsd_320K_50ns.xvg")
rmsd_320_orig  <- read_rmsd("rmsd_xtal_320K_50ns.xvg")

# 2. Merge all data into one data frame for plotting
rmsd <- data.frame(
  time = rmsd_280_equil$time,   # Time(ns)
  
  # equilibrated
  equil_280 = rmsd_280_equil$value,
  equil_300 = rmsd_300_equil$value,
  equil_320 = rmsd_320_equil$value,
  
  # original
  orig_280 = rmsd_280_orig$value,
  orig_300 = rmsd_300_orig$value,
  orig_320 = rmsd_320_orig$value
)

# 3. Figure 1A: RMSD Relative to equilibrated structure
ggplot(data = rmsd, aes(x = time)) +
  geom_line(aes(y = equil_280, color = "280K"), linewidth=0.5) +
  geom_line(aes(y = equil_300, color = "300K"), linewidth=0.5) +
  geom_line(aes(y = equil_320, color = "320K"), linewidth=0.5) +
  
  # Keep all data but limit y-axis view to 0–0.5 nm, avoiding broken lines from outliers.
  coord_cartesian(ylim = c(0, 0.5)) +
  
  scale_color_manual(values = c("280K"="#6090C1", "300K"="#fee395", "320K"="#f2724D")) +
  labs(x = "Time (ns)", y = "RMSD (nm)", color="Temperature") +
  ggtitle("RMSD (Ref: Equilibrated)") +
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

# 4. Figure 1B: RMSD Relative to original crystal structure
ggplot(data = rmsd, aes(x = time)) +
  geom_line(aes(y = orig_280, color = "280K"), linewidth=0.5) +
  geom_line(aes(y = orig_300, color = "300K"), linewidth=0.5) +
  geom_line(aes(y = orig_320, color = "320K"), linewidth=0.5) +
  
  # Keep all data but limit y-axis view to 0–0.5 nm, avoiding broken lines from outliers.
  coord_cartesian(ylim = c(0, 0.5)) +
  
  scale_color_manual(values = c("280K"="#6090C1", "300K"="#fee395", "320K"="#f2724D")) +
  labs(x = "Time (ns)", y = "RMSD (nm)", color="Temperature") +
  ggtitle("RMSD (Ref: Original)") +
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
