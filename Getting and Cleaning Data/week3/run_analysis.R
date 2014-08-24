# Assignment 3
#
# Task: "You should create one R script called run_analysis.R that does the following
# (see numbered comments below)

library(reshape2)

setwd("~/Dropbox/Study/Getting and Cleaning Data/week3")

#   1. Merges the training and the test sets to create one data set.
#
message("Step 1 of 5: Reading and merging training and test data...")
train   <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
test    <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject <- rbind(train, test)

train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
test  <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
Y     <- rbind(train, test)

train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
test  <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
X     <- rbind(train, test)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#
message("Step 2 of 5: Extracting mean and stddev measurements...")
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
looking_for_features <- grep("-(mean|std)[^a-z]", ignore.case = TRUE, features[, 2])
#str(looking_for_features)

# Sub-select just the columns that we are looking for
X <- X[, looking_for_features]

# Fix variable names (brackets causing problems in R when used in var names)
names(X) <- features[looking_for_features, 2]
names(X) <- gsub("\\(|\\)", "-", names(X))
names(X) <- gsub("[-]+", "-", names(X))
names(X) <- gsub("-$", "", names(X))
names(X)


# 3. Uses descriptive activity names to name the activities in the data set
#
message("Step 3 of 5: Appling descriptive activity names")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activities[, 2] = gsub("_", ".", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]  # set col 1 of Y to lookup value from activities


# 4. Appropriately labels the data set with descriptive activity names.
#
message("Step 4 of 5: Labelling data set")
names(Y) <- "activity"
names(subject) <- "subject"

# This is the merged data set
#
merged <- cbind(X, Y, subject)
write.table(merged, "merged_tidy.txt", row.names = TRUE)


# 5. Creates a 2nd, independent tidy data set with the average of each variable for each 
#    activity and each subject.
#
message("Step 5 of 5: Creating new tidy data set")
merged.long <- melt(merged, id = c("subject", "activity"))
merged.wide <- dcast(merged.long, subject + activity ~ variable, mean)
write.table(merged.wide, "merged_tidy2.txt", row.names = FALSE)

message("Done. Created merged_tidy.txt and merged_tidy2.txt")
