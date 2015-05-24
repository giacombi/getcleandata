# CodeBook 

##Wearable computing data analysis
####Author: Giacomo Bianchi

Wereable computing is a new frontier in reaserch and a huge source for data analysis. The source is UCI Machine Learning Repository. At their [webpage][link] there are basic informations about the source of data and the materials and method along with explanations of the variables involved. 

The file `README.md` contains all the narrative and code explanation, from data downloading to tidy dataset. 

The entire source script is `run_analysis.R` and provides as output a tidy dataset in the format of a text file `tidy_dataset.txt` in the `/Data` directory.

####Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file for further details about this dataset.

Attribute Information:

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment. 

[link]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones