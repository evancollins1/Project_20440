# sncRNA transcriptomics as a predictive marker of Parkinson’s disease

Authors: Evan Collins and Brian Cheng

This repository is for the 20.440 final project at MIT. The objective of this project is to evaluate the small noncoding RNA (sncRNA) expression profiles from whole blood that are significantly different between healthy, prodromal (at risk), and Parkinson's disease (PD) subjects. These findings will in turn enable us to build models to predict PD risk using machine learning.

Data for this project is sourced from the Parkinson's Progression Markers Initiative (PPMI) database. Brian and I obtained access to PPMI by signing user agreements. As part of the user agreement, we cannot make public any raw data from PPMI. Professor Blainey has allowed this. 

## Repository structure

The repository is structured as follows:

- `/data`: an open folder where user adds necessary PPMI .csv files as referenced in R and Python scripts.

- `/scripts`: contains the R and Python scripts used to process data and generate figures.

- `/figures`: contains the figures used in the report.

- `/models`: (BRIAN'S COMMENT)

- `/results`: (BRIAN'S COMMENT)

## Downloading PPMI data

All data analyzed in this project is sourced from PPMI. As specified in the user agreement, we cannot make public any data from PPMI. To apply for access to PPMI data, visit [this page](https://www.ppmi-info.org/access-data-specimens/download-data). 

## Running the code

The code is broken down into two main parts:

(1) All non-machine learning analyses (i.e., Figures 2-4, S1-S3 in the report) were coded in R in a single, organiezd R markdown script. This R markdown file is `/scripts/PPMI_data_processing_and_analysis.Rmd` and is best run in RStudio. Running the annotated code line by line will result in the production Figures 2-4, S1-S3 as featured in the report. Note that this R markdown was run with R version 4.1.1 and uses 11 non-base packages: `data.table` (1.14.8), `umap` (0.2.10.0), `ggplot2` (3.4.1), `ggprism` (1.0.4), `rstatix` (0.7.2), `factoextra` (1.0.7), `MASS` (7.3.58.3), `dplyr` (1.1.1), `ggpubr` (0.6.0), `BiocManager` (1.30.20). The R markdown commences by ensuring installation of all packages with these specific versions.

(2) All machine learning analyses... (BRIAN'S COMMENTS)

## Citations

- Data used in the preparation of this article were obtained from the Parkinson’s Progression Markers Initiative (PPMI) [database](https://www.ppmi-info.org/access-data-specimens/download-data). For up-to-date information on the study, visit www.ppmi-info.org.

- `.gitignore` file was adapted from `R.gitignore` in the [gitignore repo](https://github.com/github/gitignore).
