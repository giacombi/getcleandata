library("RCurl") 
library("dplyr")
library("stringr") 
library("tidyr")

#check the existence of the directory "Data" and if not create it
if (!file.exists("Data")){
    dir.create("Data")
}
#URL of the dataset and download into a file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = url, destfile = "Data/data.zip",  method="curl")
dateDownloaded <- date()
#unzip the file
unzip(zipfile = "Data/data.zip", exdir = "Data")

#merge train and test

#merge train

subj.train <- read.table(file = "Data/UCI HAR Dataset/train/subject_train.txt")
label.train <- read.table(file = "Data/UCI HAR Dataset/train/y_train.txt")
data.train <-  read.table(file = "Data/UCI HAR Dataset/train/X_train.txt")

train <- cbind(subj.train, label.train, data.train)

#merge test
subj.test <- read.table(file = "Data/UCI HAR Dataset/test/subject_test.txt")
label.test <- read.table(file="Data/UCI HAR Dataset/test/y_test.txt")
data.test <- read.table(file="Data/UCI HAR Dataset/test/X_test.txt")

test <- cbind(subj.test, label.test, data.test)

#unifying the datasets in a whole dataset
df <- rbind(train, test)

#import the "features" as vector of names
features <- read.table(file = "Data/UCI HAR Dataset/features.txt", as.is = T)
activity.labels <- read.table(file = "Data/UCI HAR Dataset/activity_labels.txt", as.is = T)
names(df) <- c("Subject", "Activity", features[,2])

#recode "Activity" as factor
df$Activity <- as.factor(df$Activity)
#assign names to the "levels" of the "Activity"
levels(df$Activity) <- c(activity.labels[,2])

#get rid of duplicated column names
df <- data.frame(df, check.names = T)

#select only the data columns that contain the "mean" and the "standard deviation" of a measurement
df.selected <- df[, as.vector(grep("Subject|Activity|mean|std|Mean" ,colnames(df), value = F))]

#use gsub to explain some varibles
df.selected.names <- gsub("Acc", "Accelerometer", names(df.selected))
df.selected.names <- gsub("Gyro", "Gyroscope", df.selected.names)
names(df.selected) <- df.selected.names

#make a tabular dataset to use dplyr
df.final <- tbl_df(df.selected)
#make the calculation chaining the group_by function and summarise_each with mean as statistical function
df.end <- df.final %>% group_by(Activity, Subject) %>% summarise_each(funs(mean)) 
 
#write the tidy dataset 
write.table(df.end, file = "Data/tidy_dataset.txt", row.names = F)
    
                