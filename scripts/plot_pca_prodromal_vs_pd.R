###############################################################################
# All code written by Evan Collins for MIT 20.440 PSET 4
# 13 March 2023
# Any questions can be sent to evanc@mit.edu

# All data acquired from Parkinson's Progression Markers Initiative (PPMI)
# as part of AMP PD database
# AMP PD database requires signed user agreements to access
# Hence, no data will be made public in this repo.
# Two datasets from PPMI are referenced in this script:
# 1. PPMI_Prodromal_Cohort_BL_to_Year_1_Dataset_Apr2020.csv
# 2. PPMI_Original_Cohort_BL_to_Year_5_Dataset_Apr2020.csv
# which contain clinical data for prodromal and Parkinson's disease patients
# (clinical data variable examples: age, tremor scale, other tests, etc.)

# Purpose of this script:
# Generate a PCA biplot to show PC scores [points] of Parkinson's disease
# (PD) patients vs. prodromal patients and show loadings of the significant 
# clinical variables [vectors] that distinguish the two cohorts

# To do this: 
# First, data is cleaned to remove columns & rows with missing data
# Then, individual variables that significantly relate to cohort id (i.e., PD
# or prodromal) in a GLM are identified.
# PCA is run on these significant variables to reduce further dimensionality
# Data is projected onto the first two PCs, colored according to cohort id, and
# vectors are drawn indicating the 10 variables with the greatest contributions 
###############################################################################

# Install packages (up-to-date versions as of 14 March 2023)
install.packages("ggplot2",
                 version = "3.4.1",
                 repos = "https://cloud.r-project.org")
install.packages("factoextra", 
                 version = "1.0.7",
                 repos = "https://cloud.r-project.org")

# Load packages
library(ggplot2)
library(factoextra)

# Load .csv datasets for prodromal cohort and Parkinson's disease (PD) cohort
prodromal_df <- read.csv("../data/PPMI_Prodromal_Cohort_BL_to_Year_1_Dataset_Apr2020.csv")
pd_df <- read.csv("../data/PPMI_Original_Cohort_BL_to_Year_5_Dataset_Apr2020.csv")

# Keep columns that are shared between the two datasets
pd_df_shared <- pd_df[, colnames(pd_df) %in% colnames(prodromal_df)]
prodromal_df_shared <- prodromal_df[, colnames(prodromal_df) %in% colnames(pd_df)]

# Add explicit cohort column
pd_df_shared$cohort <- "PD" # has parkinson's disease
prodromal_df_shared$cohort <- "Prodromal" # prodromal, i.e., at risk for PD

# Combine the two dataframes
pd_prodromal_df <- rbind(pd_df_shared, prodromal_df_shared)

# Keep only baseline measurement values for each patient
pd_prodromal_df <- pd_prodromal_df[pd_prodromal_df$EVENT_ID == "BL", ]

# Remove some categorical variables not important for factor analysis
pd_prodromal_df <- pd_prodromal_df[, !colnames(pd_prodromal_df) %in% c("SITE", 
                                                                       "APPRDX", 
                                                                       "EVENT_ID",
                                                                       "YEAR",
                                                                       "visit_date",
                                                                       "ST_startdate",
                                                                       "ST_year1"
)]

# Remove columns that have more than 11 NA values
pd_prodromal_df <- pd_prodromal_df[, !colSums(is.na(pd_prodromal_df)) > 11]
# Remove subjects that have NA values
pd_prodromal_df <- pd_prodromal_df[!rowSums(is.na(pd_prodromal_df)) > 0, ]
# Remove othneuro, tau_txt, and ptau_txt columns since  mostly "" characters
pd_prodromal_df <- pd_prodromal_df[!colnames(pd_prodromal_df) %in% c("othneuro", 
                                                                     "tau_txt",
                                                                     "ptau_txt")]
# Remove PD_MED_USE as all zeros
pd_prodromal_df <- pd_prodromal_df[!colnames(pd_prodromal_df) %in% c("PD_MED_USE")]
# Remove NP1DDS as it causes GLM not to converge; insignificant
pd_prodromal_df <- pd_prodromal_df[!colnames(pd_prodromal_df) %in% c("NP1DDS")]

# Make the patient number the rownames instead of own column
rownames(pd_prodromal_df) <- pd_prodromal_df$PATNO
pd_prodromal_df <- pd_prodromal_df[, !colnames(pd_prodromal_df) == "PATNO"]
# Make the cohort column the leftmost
pd_prodromal_df <- pd_prodromal_df[, c(ncol(pd_prodromal_df), 
                                       1:ncol(pd_prodromal_df)-1
)] 
# Make the cohort column a factor to run GLM
pd_prodromal_df$cohort <- as.factor(pd_prodromal_df$cohort)

# Final dimensions are 712 patients by 78 variables (+ cohort variable)
# dim(pd_prodromal_df)

# Calculate p values from GLM for each column in relation to cohort 
p_values_by_column <- rep(NA, ncol(pd_prodromal_df))
for (i in 2:ncol(pd_prodromal_df)){
  p_values_by_column[i] <- coef(summary(glm(pd_prodromal_df$cohort ~ pd_prodromal_df[,i], 
                                            family = "binomial")))[2,4]
}

# Apply Bonferroni correction based on number of GLM tests ran
bonferroni_alpha <- 0.05/(ncol(pd_prodromal_df) - 1)
# Evaluate which columns are suggested to be signifcant
sig_factors <- colnames(pd_prodromal_df)[which(p_values_by_column < bonferroni_alpha)]

# Realization: remove variables that are simply categorical versions of others
# e.g. remove "age_cat", i.e., categorical variable for "age"
sig_factors_clean <- sig_factors[!sig_factors %in% c("age_cat",
                                                     "hy_on",
                                                     "NHY_ON",
                                                     "rigidity_on",
                                                     "td_pigd_on",
                                                     "tremor_on",
                                                     "updrs3_score_on",
                                                     "updrs_totscore_on",
                                                     "rem_cat"
)]

# Make dataframe with only significant columns
pd_prodromal_sig_df <- pd_prodromal_df[, colnames(pd_prodromal_df) %in% c("cohort", sig_factors_clean)]

# Run PCA
pca_results <- prcomp(pd_prodromal_sig_df[-1], center = TRUE, scale = TRUE)

# Plot PCA biplot with variables as directional lines
pca_biplot_fig <- fviz_pca_biplot(pca_results,
                                  col.ind = pd_prodromal_sig_df$cohort,
                                  addEllipses = TRUE,
                                  col.var = "black",
                                  label = "var",
                                  select.var = list(contrib = 10),
                                  repel = TRUE,
                                  labelsize = 3,
                                  legend.title = "Cohort") + 
  theme_classic() +
  ggtitle("PCA biplot from clinical data - PD vs. prodromal subjects") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("../figures/pca_biplot_prodromal_vs_pd.png", plot = pca_biplot_fig)

#print(pca_biplot_fig)
