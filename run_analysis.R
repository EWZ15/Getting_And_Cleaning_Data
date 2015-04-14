## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable 
##    for each activity and each subject.

library(data.table)

#download data
setwd("D:/R/UCI HAR Dataset")
testData <- read.table("test/X_test.txt", header=FALSE)
testData_labels <- read.table("test/y_test.txt", header=FALSE)
testData_sub <- read.table("test/subject_test.txt", header=FALSE)
trainData <- read.table("train/X_train.txt", header=FALSE)
trainData_labels <- read.table("train/y_train.txt", header=FALSE)
trainData_sub <- read.table("train/subject_train.txt", header=FALSE)

#3 Load activity labels and use descriptive activity names to name activities
activities <- read.table("activity_labels.txt", header=FALSE)
testData_labels$V1 <- factor(testData_labels$V1, levels=activities$V1, labels=activities$V2)
trainData_labels$V1 <- factor(trainData_labels$V1, levels=activities$V1, labels=activities$V2)

#2 pull only mean and standard deviation for each measurement
features <- read.table("features.txt", header=FALSE, colClasses="character")
extract_features <- grepl("mean|std", features)

#4 Label data with descriptive activity names
colnames(testData) <- features$V2
colnames(trainData) <- features$V2
colnames(testData_labels) <- c("Activity")
colnames(trainData_labels) <- c("Activity")
colnames(testData_sub) <- c("Subject")
colnames(trainData_sub) <- c("Subject")

#1 merge all data (test, training, activities) together into one dataset
testData <- cbind(testData, testData_labels)
testData <- cbind(testData, testData_sub)
trainData <- cbind(trainData, trainData_labels)
trainData <- cbind(trainData, trainData_sub)
MergedData <- rbind(testData, trainData)

#5 create tidy dataset with averages for each variable, activity, and subject
table <- data.table(MergedData)
tidy <- table[,lapply(.SD, mean), by="Activity,Subject"]
write.table(tidy, file="D:/R/tidy.txt", sep=",", row.names = FALSE)
