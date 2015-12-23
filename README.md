# Getting-and-Cleaning-Data

The script run_analysis.R assumes that the UCI HAR Dataset folder exists in your working directory. The script does the following:

1. Reads data files from UCI \HAR \Dataset folder (in your working directory). 

2. Merges train and test subject data (UCI \HAR \Dataset/train/subject_train.txt and UCI \HAR \Dataset/test/subject_test.txt).

3. Merges train and test activity data (UCI \HAR \Dataset/train/Y_train.txt and UCI \HAR \Dataset/test/Y_test.txt). 

4. Merges train and test acc and gyro measurements (UCI \HAR \Dataset/train/X_train.txt and UCI \HAR \Dataset/test/X_test.txt). 

5. Finds the features that refer to mean and std measurements (UCI \HAR \Dataset/features.txt), and process rows with measurements to include only columns that refer to those features.

6. Renames column names to have meaningful descriptions (use UCI \HAR \Dataset/features.txt to get the feature names, and UCI \HAR \Dataset/activity_labels.txt to get activity names)

7. Computes measurement means per subject per activity

8. Writes the 'tidy' dataset
