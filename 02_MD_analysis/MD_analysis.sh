#!/bin/bash
set -e

# Script location: 02_MD_analysis/
# Simulation files: ../01_MD_simulation/280K/50ns/
#                   ../01_MD_simulation/300K/50ns/
#                   ../01_MD_simulation/320K/50ns/

# 280K 50ns
mkdir -p 280K/50ns
cd 280K/50ns

# Remove PBC and output corrected trajectory
gmx trjconv -s ../../../01_MD_simulation/280K/50ns/md_280K_50ns.tpr -f ../../../01_MD_simulation/280K/50ns/md_280K_50ns.xtc -o md_noPBC.xtc -pbc mol -center
# Selection: 1 0

# Calculate RMSD vs. initial equilibrated structure (simulation start)
gmx rms -s md_280K_50ns.tpr -f md_noPBC.xtc -o rmsd_280K_50ns.xvg -tu ns
# Selection: 4 4

# Calculate RMSD vs. original energy-minimized PDB structure
gmx rms -s ../../../01_MD_simulation/em.tpr -f md_noPBC.xtc -o rmsd_xtal_280K_50ns.xvg -tu ns
# Selection: 4 4

# Calculate and output radius of gyration (Rg)
gmx gyrate -s md_280K_50ns.tpr -f md_noPBC.xtc -o gyrate_280K_50ns.xvg
# Selection: 1

# Generate final stable structure (average from 45ns to 50ns) after fit structure.
gmx trjconv -s md_280K_50ns.tpr -f md_noPBC.xtc -o md_noPBC_fit.xtc -fit rot+trans
# Selection: 4 1
gmx rmsf -s md_280K_50ns.tpr -f md_noPBC_fit.xtc -ox 280K_50ns_last5ns_avg.pdb -b 45000 -e 50000
# Selection: 1
cd ../../

# 300K 50ns
mkdir -p 300K/50ns
cd 300K/50ns
gmx trjconv -s ../../../01_MD_simulation/300K/50ns/md_300K_50ns.tpr -f ../../../01_MD_simulation/300K/50ns/md_300K_50ns.xtc -o md_noPBC.xtc -pbc mol -center
# Selection: 1 0

gmx rms -s md_300K_50ns.tpr -f md_noPBC.xtc -o rmsd_300K_50ns.xvg -tu ns
# Selection: 4 4

gmx rms -s ../../../01_MD_simulation/em.tpr -f md_noPBC.xtc -o rmsd_xtal_300K_50ns.xvg -tu ns
# Selection: 4 4

gmx gyrate -s md_300K_50ns.tpr -f md_noPBC.xtc -o gyrate_300K_50ns.xvg
# Selection: 1

gmx trjconv -s md_300K_50ns.tpr -f md_noPBC.xtc -o md_noPBC_fit.xtc -fit rot+trans
# Selection: 4 1
gmx rmsf -s md_300K_50ns.tpr -f md_noPBC_fit.xtc -ox 300K_50ns_last5ns_avg.pdb -b 45000 -e 50000
# Selection: 1
cd ../../

# 320K 50ns
mkdir -p 320K/50ns
cd 320K/50ns
gmx trjconv -s ../../../01_MD_simulation/320K/50ns/md_320K_50ns.tpr -f ../../../01_MD_simulation/320K/50ns/md_320K_50ns.xtc -o md_noPBC.xtc -pbc mol -center
# Selection: 1 0

gmx rms -s md_320K_50ns.tpr -f md_noPBC.xtc -o rmsd_320K_50ns.xvg -tu ns
# Selection: 4 4

gmx rms -s ../../../01_MD_simulation/em.tpr -f md_noPBC.xtc -o rmsd_xtal_320K_50ns.xvg -tu ns
# Selection: 4 4

gmx gyrate -s md_320K_50ns.tpr -f md_noPBC.xtc -o gyrate_320K_50ns.xvg
# Selection: 1

gmx trjconv -s md_320K_50ns.tpr -f md_noPBC.xtc -o md_noPBC_fit.xtc -fit rot+trans
# Selection: 4 1
gmx rmsf -s md_320K_50ns.tpr -f md_noPBC_fit.xtc -ox 320K_50ns_last5ns_avg.pdb -b 45000 -e 50000
# Selection: 1
cd ../../