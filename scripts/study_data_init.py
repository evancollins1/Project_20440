'''
Initialization script for the PPMI study data.

This script is used to load the participant status table into a pandas dataframe
(acts as the initial entrypoint to the study data). It also filters the data to
only include participants that are enrolled, withdrew, or completed the study.
It also filters the data to only include PD, Prodromal, and Healthy Control
participants.

Main exports:
    study_data_csvs: list of csv file paths for the study data
    filtered_participant_status: dataframe of participant status data
    table_name_to_file: mapping of table names to file names
'''

import os
import pandas as pd

study_data_dir = os.path.join(os.path.dirname(os.getcwd()), 'data',
                              'study_data_PPMI')
study_data_csvs = [os.path.join(study_data_dir, f) for f in
                   os.listdir(study_data_dir) if f.endswith('.csv')]

# filter participant status

participant_status = pd.read_csv(study_data_dir + '/Participant_Status.csv')

# filter enrollment status to only include enrolled, withdrew, and complete
# (study data available)
enroll_filter = ['Enrolled', 'Withdrew', 'Complete']
# filter cohorts to only include PD (1), Prodromal (4), and Healthy Controls (2)
cohort_filter = [1, 2, 4]

filters = {'ENROLL_STATUS': enroll_filter, 'COHORT': cohort_filter}
filtered_participant_status_mask = participant_status.isin(filters)[
                                   filters.keys()].all(1)
filtered_participant_status = participant_status[
                              filtered_participant_status_mask]

# mappping of table names to file names
# see section 3.5 of the PPMI Data User Guide for more details

data_dict = pd.read_csv(study_data_dir + '/Data_Dictionary_-__Annotated_.csv')
table_name_to_file = data_dict[data_dict['ITM_NAME'] == ' '][['MOD_NAME',
                                                             'DSCR']]
table_name_to_file.set_index('MOD_NAME', inplace=True)
table_name_to_file = table_name_to_file['DSCR'].apply(lambda x:
                     os.path.join(study_data_dir, x.replace(' ', '_') + '.csv'))

code_list = pd.read_csv(study_data_dir + '/Code_List_-__Annotated_.csv')
