'''
This script generates the X and y data for the sncRNA counts data to be used in
the machine learning models.
'''

import pandas as pd
from study_data_init import participant_status

# Load the participant status data and extract patient numbers and cohort
participant_status = participant_status[['PATNO', 'COHORT']]

# Load the sncRNA counts data
df = pd.read_csv('../data/PPMI_sncRNAcounts/counts/all_quantification_matrix_rpm_norm.csv.gz', sep='\t').T

# Reshape the data
df.columns = df.loc['Reference']
df.drop('Reference', axis=0, inplace=True)

# Filter for baseline samples
baseline_mask = df.index.str.split('.').str[2] == 'BL'
df = df[baseline_mask]

# Extract patient numbers from the index
df['PATNO'] = df.index.str.split('.').str[1]
df['PATNO'] = pd.to_numeric(df['PATNO'], errors='coerce')
df.dropna(subset=['PATNO'], inplace=True)

# Merge the dataframes
df = pd.merge(df, participant_status, on='PATNO', how='left')

# Drop rows with missing values
df.dropna(subset=['COHORT'], inplace=True)

# Filter out SWEDD (3) samples
swedd_mask = df['COHORT'] != 3
df = df[swedd_mask]

df.to_csv('../data/PPMI_sncRNAcounts/counts/ML.csv', index=False)

# Generate X and y data
X = df.drop(['PATNO', 'COHORT'], axis=1)
y = df['COHORT']

# Save the data
X.to_csv('../data/PPMI_sncRNAcounts/counts/X.csv', index=False)
y.to_csv('../data/PPMI_sncRNAcounts/counts/y.csv', index=False)
