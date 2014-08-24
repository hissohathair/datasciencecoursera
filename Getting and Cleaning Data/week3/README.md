# Getting and Cleaning Data

## Peer-Reviewed Assignment (Week 3)

The following files can be found in this directory
* Features.md: Updated data dictionary.
* README.md: This file.
* run_analysis.R: Submission for course assignment (see below).
* UCI HAR Dataset.zip: [Source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used by the analysis script.

## Analysis

The file `run_analysis.R` does the following:
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The files are saved as `merged_tidy.txt` and `merged_tidy2.txt`.

