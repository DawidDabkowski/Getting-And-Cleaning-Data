#POINT 1
X_train <- read.fwf(".\\UCI HAR Dataset\\train\\X_train.txt", widths=rep(16, 561))
X_test <- read.fwf(".\\UCI HAR Dataset\\test\\X_test.txt", widths=rep(16, 561))
X <- rbind(X_train, X_test)

features <- readLines(".\\UCI HAR Dataset\\features.txt")
colnames(X) <- features

y_train <- read.fwf(".\\UCI HAR Dataset\\train\\y_train.txt", 16)
y_test <- read.fwf(".\\UCI HAR Dataset\\test\\y_test.txt", 16)
y <- rbind(y_train, y_test)
y <- factor(unlist(y))

subject_train <- read.fwf(".\\UCI HAR Dataset\\train\\subject_train.txt", 16)
subject_test <- read.fwf(".\\UCI HAR Dataset\\test\\subject_test.txt", 16)
subject <- rbind(subject_train, subject_test)
subject <- factor(unlist(subject))

tidy_data <- cbind(y, subject, X)
colnames(tidy_data)[1:2] <- c("activity", "subject")

#POINT 2

cols <- colnames(tidy_data)
good_cols <- grep("mean\\(|std\\(", cols)
tidy_data <- tidy_data[,c(1,2,good_cols)]

#POINT 3

activities <- readLines(".\\UCI HAR Dataset\\activity_labels.txt")
activities <- substr(activities, 3, 100)
activities <- gsub("_", "", activities)
activities <- tolower(activities)
levels(tidy_data$activity) <- activities

#POINT 4
cols <- colnames(tidy_data)
checkpoint1 <- length(unique(cols))
cols <- gsub(" ", "", cols)
cols <- gsub("-", "", cols)
cols <- gsub(",", "", cols)
cols <- gsub("\\(", "", cols)
cols <- gsub("\\)", "", cols)
cols <- tolower(cols)
checkpoint2 <- length(unique(cols))
if (checkpoint1!=checkpoint2)
    warning("New variable names are not unique!")
colnames(tidy_data) <- cols

write.table(tidy_data, "tidy_data.txt", row.names=F)

#POINT 5
library(dplyr)
tidy_data_agg <- tidy_data %>% group_by(activity, subject) %>% summarize_all(funs(mean))

write.table(tidy_data_agg, "tidy_data_agg.txt", row.names=F)


#body_acc_x <- read.fwf(paste0(".\\", "UCI HAR Dataset\\", set, "\\", "Inertial Signals\\", "body_acc_x_", set, ".txt"), 16)