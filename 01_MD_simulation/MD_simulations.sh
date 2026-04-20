#!/bin/bash
set -e

# Note:
# Some GROMACS commands require interactive selections (annotated above).


# Script location: 01_MD_simulation/
# Dependencies in ../input_data/ and ../mdp_parameter_files/

# Clean PDB
grep -v "A 328" ../input_data/3HW2.pdb > ../input_data/3HW2_clean.pdb
awk '!( $5=="B" && $6<788 )' ../input_data/3HW2_clean.pdb > ../input_data/3HW2_final.pdb

# Process topology
gmx pdb2gmx -f ../input_data/3HW2_final.pdb -o processed.gro -water spce -ff oplsaa

# Build box and solvate
gmx editconf -f processed.gro -o newbox.gro -c -d 1.0 -bt cubic
gmx solvate -cp newbox.gro -cs spc216.gro -o solv.gro -p topol.top

# Add ions
gmx grompp -f ../mdp_parameter_files/ions.mdp -c solv.gro -p topol.top -o ions.tpr
# Selection: 13
gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral

# Energy minimization
gmx grompp -f ../mdp_parameter_files/minim.mdp -c solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em
# Selection: 10 0
gmx energy -f em.edr -o potential.xvg

# 280K simulation
mkdir -p 280K
cd 280K
gmx grompp -f ../../mdp_parameter_files/280K_nvt.mdp -c ../em.gro -r ../em.gro -p ../topol.top -o nvt.tpr
gmx mdrun -deffnm nvt
# Selection: 16 0
gmx energy -f nvt.edr -o temperature.xvg

gmx grompp -f ../../mdp_parameter_files/280K_npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p ../topol.top -o npt.tpr
gmx mdrun -deffnm npt
# Selection: 18 0
gmx energy -f nvt.edr -o pressure.xvg
# Selection: 24 0
gmx energy -f nvt.edr -o density.xvg

mkdir -p 50ns
cd 50ns
gmx grompp -f ../../../mdp_parameter_files/280K_50ns_md.mdp -c ../npt.gro -t ../npt.cpt -p ../../topol.top -o md_280K_50ns.tpr
gmx mdrun -deffnm md_280K_50ns -ntomp 16 -nb gpu
cd ../../

# 300K simulation
mkdir -p 300K
cd 300K
gmx grompp -f ../../mdp_parameter_files/300K_nvt.mdp -c ../em.gro -r ../em.gro -p ../topol.top -o nvt.tpr
gmx mdrun -deffnm nvt
# Selection: 16 0
gmx energy -f nvt.edr -o temperature.xvg

gmx grompp -f ../../mdp_parameter_files/300K_npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p ../topol.top -o npt.tpr
gmx mdrun -deffnm npt
# Selection: 18 0
gmx energy -f nvt.edr -o pressure.xvg
# Selection: 24 0
gmx energy -f nvt.edr -o density.xvg

mkdir -p 50ns
cd 50ns
gmx grompp -f ../../../mdp_parameter_files/300K_50ns_md.mdp -c ../npt.gro -t ../npt.cpt -p ../../topol.top -o md_300K_50ns.tpr
gmx mdrun -deffnm md_300K_50ns -ntomp 16 -nb gpu
cd ../../

# 320K simulation
mkdir -p 320K
cd 320K
gmx grompp -f ../../mdp_parameter_files/320K_nvt.mdp -c ../em.gro -r ../em.gro -p ../topol.top -o nvt.tpr
gmx mdrun -deffnm nvt
# Selection: 16 0
gmx energy -f nvt.edr -o temperature.xvg

gmx grompp -f ../../mdp_parameter_files/320K_npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p ../topol.top -o npt.tpr
gmx mdrun -deffnm npt
# Selection: 18 0
gmx energy -f nvt.edr -o pressure.xvg
# Selection: 24 0
gmx energy -f nvt.edr -o density.xvg

mkdir -p 50ns
cd 50ns
gmx grompp -f ../../../mdp_parameter_files/320K_50ns_md.mdp -c ../npt.gro -t ../npt.cpt -p ../../topol.top -o md_320K_50ns.tpr
gmx mdrun -deffnm md_320K_50ns -ntomp 16 -nb gpu
cd ../../
