# Predicting Parkinson's Disease Risk Using Multimodal Deep Learning

Authors: Evan Collins and Brian Cheng

This repository is for the 20.440 final project at MIT. The objective of this project is to evaluate the clinical and -omics features that are significantly different between healthy, prodromal (at risk), and Parkinson's disease (PD) subjects. These findings will hopefully in turn enable us to build models to predict PD risk using multimodal deep learning.

Data for this project is sourced from the Parkinson's Progression Markers Initiative (PPMI) database. Brian and I obtained access to PPMI by signing user agreements. As part of the user agreement, we cannot make public any raw data from PPMI. Professor Blainey has allowed this.

For PSET 4, this repository contains only one script (`plot_pca_prodromal_vs_pd.R`) to generate one figure (`pca_biplot_prodromal_vs_pd.png`). The script generates a PCA biplot figure to show PC scores [points] of Parkinson's disease (PD) patients vs. prodromal patients and show loadings of the significant clinical variables [vectors] that distinguish the two cohorts.

## Repository structure

The repository is structures as follows:

- `/data`: an open folder where user would add necessary data as specified in the section **Downloading PPMI data** below.

- `/scripts`: contains the .R scripts used to process data and generate figures.

- `/figures`: contains the figures used in the report.

*Note that additional folders will be added as the project progresses. This `README.md` will be updated accordingly.*

## Downloading PPMI data

All data analyzed in this project is sourced from PPMI. As specified in the user agreement, we cannot make public any data from PPMI. To apply for access to PPMI data, visit [this page](https://www.ppmi-info.org/access-data-specimens/download-data). 

Once access is granted, download the two `.csv` files required to run the script for PSET 4.

1. `PPMI_Prodromal_Cohort_BL_to_Year_1_Dataset_Apr2020.csv`

2. `PPMI_Original_Cohort_BL_to_Year_5_Dataset_Apr2020.csv`

Once downloaded, put these files in the `/data` folder.

## Running the code

To run the script (`scripts/plot_pca_prodromal_vs_pd.R`) and generate the figure (`figures/pca_biplot_prodromal_vs_pd.png`) for PSET 4, simply `cd [path]/scripts` and run the command. 

```bash
Rscript plot_pca_prodromal_vs_pd.R
```

Note that this R script uses two packages, `ggplot2` (version 3.4.1) and `factoextra` (version 1.0.7). The R script commences by ensuring installation of both packages with these specific versions.

## Citations

Data used in the preparation of this article were obtained from the Parkinson’s Progression Markers Initiative (PPMI) [database](www.ppmi-info.org/access-data-specimens/download-data). For up-to-date information on the study, visit www.ppmi-info.org.








