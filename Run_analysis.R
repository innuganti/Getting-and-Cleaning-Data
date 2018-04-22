if (!getwd() == "./out-of-box-samples") {
  dir.create("./out-of-box-samples")
}


rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization

temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE) #This provides the list of variables and I choose the ones that are applicable for this data set
YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) # very important to remove this

## Data Cleaning

colnames(XTrain) <- t(Features[2])
colnames(XTest) <- t(Features[2])
## Merging
XTrain$activities <- YTrain[, 1]
XTrain$participants <- SubjectTrain[, 1]
XTest$activities <- YTest[, 1]
XTest$participants <- SubjectTest[, 1]
## Assignment 1

Master <- rbind(XTrain, XTest)
duplicated(colnames(Master))
Master <- Master[, !duplicated(colnames(Master))]

## Assignment 2

Mean <- grep("mean()", names(Master), value = FALSE, fixed = TRUE)
#In addition, we need to include 555:559 as they have means and are associated with the gravity terms
Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- Master[Mean]
# For STD
STD <- grep("std()", names(Master), value = FALSE)
InstrumentSTDMatrix <- Master[STD]

## Assignment 3
## Task: Uses descriptive activity names to name the activities in the data set

## Changing the class is useful for replacing strings

Master$activities <- as.character(Master$activities)
Master$activities[Master$activities == 1] <- "Walking"
Master$activities[Master$activities == 2] <- "Walking Upstairs"
Master$activities[Master$activities == 3] <- "Walking Downstairs"
Master$activities[Master$activities == 4] <- "Sitting"
Master$activities[Master$activities == 5] <- "Standing"
Master$activities[Master$activities == 6] <- "Laying"
Master$activities <- as.factor(Master$activities)

## Assignment 4
names(Master)  # survey the data

names(Master) <- gsub("Acc", "Accelerator", names(Master))
names(Master) <- gsub("Mag", "Magnitude", names(Master))
names(Master) <- gsub("Gyro", "Gyroscope", names(Master))
names(Master) <- gsub("^t", "time", names(Master))
names(Master) <- gsub("^f", "frequency", names(Master))

## Assignment 5
## Create a tidy data set
print.table(TidyData)
