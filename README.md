# CMML3 ICA1 Miniproject 4
Multi-temperature Molecular Dynamics Simulation of 3HW2 Protein Complex and Comparison with AlphaFold Prediction

## Overview
This project investigates the effect of temperature (280 K, 300 K, 320 K) on the co-folding stability of the 3HW2 protein complex using molecular dynamics (MD) simulations in GROMACS.  

Final MD-derived structures are compared with AlphaFold predictions to evaluate the limitations of static structure prediction in capturing temperature-dependent conformational variability.  

## Project Structure

```text
CMML3_ICA1_Miniproject4/
├── README.md
│ 
├── 01_MD_simulation/
│   ├── MD_simulations.sh               # MD simulation pipeline script
│   ├── input_data/
│   │   ├── 3HW2.pdb                    # Original PDB structure from RCSB PDB
│   │   └── 3HW2_final.pdb              # Cleaned structure after MD preprocessing
│   ├── mdp_parameter_files/            # GROMACS parameter files for MD
│   └── S1-4_verify_equilibrium/        # MD equilibrium analysis for Figure S1-S4

├── 02_MD_analysis/
│   ├── MD_analysis.sh                  # RMSD, Rg, and final structure generation
│   ├── RMSD/                           # RMSD results and R visualization files
│   ├── Rg/                             # Rg results and R visualization files
│   └── final_structure/                # Final stable MD structures (45-50ns averaged)

├── 03_AlphaFold_prediction/
│   ├── input_sequences.txt             # Input sequences for AlphaFold prediction
│   └── model_results/                  # AlphaFold predicted models

└── 04_Structural_and_interaction_analysis/
    ├── AFvsMD_RMSD/                    # RMSD comparison between AlphaFold and MD
    ├── Interface_analysis/             # Interface H-bond count by PyMOL, and interaction area visualization
    ├── Secondary_structure/            # Secondary structure proportion visualization
    └── Structural_superposition/       # Structural visualization in PyMOL
```

## How to Reproduce the Analysis

### 1. Molecular Dynamics Simulations
- Perform MD simulations using **GROMACS (v2024.3)**  
- Input structure: 3HW2 complex from RCSB PDB  
- Preprocess structure to remove residues with missing atoms  
- Run simulations at **280 K, 300 K, and 320 K** following standard workflow:  
  - Energy minimization  
  - NVT equilibration  
  - NPT equilibration  
  - Production MD (50 ns)  

```bash
cd 01_MD_simulation
chmod +x MD_simulation.sh
./MD_simulation.sh
# Select group numbers following the comments in the script.
```

### 2. Trajectory Analysis
- Apply periodic boundary condition (PBC) correction to all trajectories  
- Compute structural stability metrics:
  - Root-mean-square deviation (RMSD) relative to equilibrated and original structures  
  - Radius of gyration (Rg) to assess structural compactness  
- Extract representative structures by averaging the final 5 ns (45–50 ns)  
- Generate all plots and visualizations using **R (v4.4.2)**  

```bash
cd 02_MD_analysis
chmod +x MD_analysis.sh
./MD_analysis.sh
# Select group numbers following the comments in the script.
```

### 3. AlphaFold Prediction
- Retrieve protein sequences from UniProt  
- Trim sequences to ensure consistency with MD-preprocessed structures  
- Perform structure prediction using **AlphaFold Server**:  
  https://alphafoldserver.com/  
- Download the top-ranked predicted model (CIF format) for subsequent analysis  

### 4. Structural and Interaction Analysis
- Perform structural alignment and visualization using **PyMOL (v3.1.6.1)**  
- Compare MD-derived and AlphaFold-predicted structures through:
  - Structural superposition  
  - Interface hydrogen bond quantification  
  - RMSD calculation  

- Calculate interaction interface areas using **PISA (PDBe)**:  
  https://www.ebi.ac.uk/pdbe/pisa/  

- Perform structural validation and secondary structure analysis using **PDBsum**:  
  https://www.ebi.ac.uk/thornton-srv/databases/pdbsum/Generate.html  
  - Secondary structure assignment (DSSP)  
  - Ramachandran outlier analysis (PROCHECK)  

- All quantitative results are summarized in **Supplementary Table S1**  
- All analysis scripts and visualization workflows are available in this repository  