clean_data <- function(set){
    features <- readLines(paste0(".\\", "UCI HAR Dataset\\", "features.txt"))
    checkpoint1 <- length(unique(features))
    features <- gsub(" ", "", features)
    features <- gsub("-", "", features)
    features <- gsub(",", "", features)
    features <- gsub("\\(", "", features)
    features <- gsub("\\)", "", features)
    features <- tolower(features)
    checkpoint2 <- length(unique(features))
    if (checkpoint1!=checkpoint2)
        warning("New variable names are not unique!")
    
    X <- read.fwf(paste0(".\\", "UCI HAR Dataset\\", set, "\\X_", set, ".txt"), widths=rep(16, 561))
    colnames(X) <- features

    y <- read.fwf(paste0(".\\", "UCI HAR Dataset\\", set, "\\y_", set, ".txt"), 16)
    y <- factor(unlist(y))
    names(y) <- "activity"
    
    subject <- read.fwf(paste0(".\\", "UCI HAR Dataset\\", set, "\\subject_", set, ".txt"), 16)
    subject <- factor(unlist(subject))
    names(subject) <- "subject"
    
    tidy_data <- cbind(y, subject, X)
    write.table(tidy_data, paste0(set, ".txt"), row.names=F)
}

clean_data("train")
clean_data("test")

#activities <- readLines(paste0(".\\", "UCI HAR Dataset\\", "activity_labels.txt"))
#body_acc_x <- read.fwf(paste0(".\\", "UCI HAR Dataset\\", set, "\\", "Inertial Signals\\", "body_acc_x_", set, ".txt"), 16)