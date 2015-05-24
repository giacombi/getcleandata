#README 

##Description
Weareable computing is a new area of research and a source of data for data science. The script `run_analysis.R` performs all the analysis from downloading data up to provide a tidy dataset. The steps are described below.

###Library Used for Analysis
The following libraries are used for the data analysis:
```
library("RCurl")
library("dplyr")
library("tidyr")
```
All are invoked at the beginning of the script.

###Data Downloading
The presence of a directory called "Data" is made by a script
```
if (!file.exists("Data")){
    dir.create("Data")
}
```
The source URL is specified and downloaded; the `method = "curl` is used because the script has been originally developed on an Apple computer.
```
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = url, destfile = "Data/data.zip",  method="curl")
dateDownloaded <- date()
```
The last line of code is to record the date of file download.


The file is unzipped in the target directory according to the `unzip()` function.
```
#unzip the file
unzip(zipfile = "Data/data.zip", exdir = "Data")
```

###Full dataset
The above commands end up to a directory called `UCI HAR Dataset` that contains four text files and two directories.
```
activity_labels.txt
features.txt
features_info.txt
README.txt

\test
\train
```

####The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

###Merging train and test datasets
The files containing the Subject, Label and Activity are read as dataframe using `read.table()` function. Summary dataframe are created using `cbind()` command.
```
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
```
Eventually, a whole dataset is made using `rbind`.
```
#unifying the datasets in a whole dataset
df <- rbind(train, test)
```

###Assing the Variable names
After that, the "features" , i.e. the variables obtained from accelerator and gyroscope are imported. Furthermore, the Activity labels are imported. Than, column names are assigned using `names()` function.
```
#import the "features" as vector of names
features <- read.table(file = "Data/UCI HAR Dataset/features.txt", as.is = T)
activity.labels <- read.table(file = "Data/UCI HAR Dataset/activity_labels.txt", as.is = T)
names(df) <- c("Subject", "Activity", features[,2])
```

###Assign the name to "Activity" variable
The Activity class `class(df$Activity)` returns "Integer" and must be recoded as a factor in order to assign the name that is stored in the `activity.labels` vector.
```
#recode "Activity" as factor
df$Activity <- as.factor(df$Activity)

#assign names to the "levels" of the "Activity"
levels(df$Activity) <- c(activity.labels[,2])
```

###Get rid of duplicate column names
In order to not have duplicates the following code is used
```
#get rid of duplicated column names
df <- data.frame(df, check.names = T)
```

###Get the columns with Variables names containing the mean and the standard deviation
In order to select only the columns that contain the aforementioned values, a selection using regular expression and the `grep()` function is used.
```
#select only the data columns that contain the "mean" 
#and the "standard deviation" of a measurement
df.selected <- df[, as.vector(grep("Subject|Activity|mean|std|Mean" ,colnames(df), value = F))]
```

###Edit the names of some columns
Apart the explamations of the Variable names provided, to make it more "human readable", two abbreviations are recoded with the following code using `gsub()` function.
```
#use gsub to explain some varibles
df.selected.names <- gsub("Acc", "Accelerometer", names(df.selected))
df.selected.names <- gsub("Gyro", "Gyroscope", df.selected.names)
names(df.selected) <- df.selected.names
```

###Calculate the mean of the measured variables
The final dataset reports the avarage of each measured variable for each activity and each subject. To do so, the `dplyr` library is used. The first step consist of making a tabular dataset.  
```
#make a tabular dataset to use dplyr
df.final <- tbl_df(df.selected)
```
After that the tabular dataset is processed using the `group_by()` function of the dplyr package specifying the order (Activity and then Subject) and using the "pipe" operator "%>%" to pass the first step to the `summarise_each()` function that takes "mean" as function argument `funs(mean)`. The following code returns the tidy dataset.
```
#make the calculation chaining the group_by function and 
#summarise_each with mean as statistical function
df.end <- df.final %>% group_by(Activity, Subject) %>% summarise_each(funs(mean))
```

