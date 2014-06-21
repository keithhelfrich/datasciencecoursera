############################################### DETAIL #############################################################
#                                                                                                                  #
# @author: Keith Helfrich                                                                                          #
#                                                                                                                  #  
# This script produces two tidy data sets as output from the UCI HAR Dataset according to                          #  
# requirements for the "Getting and Cleaning Data" course project, as part of the JHU Data                         #
# Science Specialization track offered on Coursera.                                                                #  
#                                                                                                                  #
# After extracting the UCI HAR Dataset zip, place this file inside of the top level directory.                     #
#                                                                                                                  #
# The UCI HAR Dataset zip file is found at the following location:                                                 #
#     - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip                     #
#                                                                                                                  #  
# Once done, the directory structure should be as follows:                                                         #
#                                                                                                                  #    
#   UCI HAR Dataset                                                                                                #
#   |                                                                                                              #
#   |---------- activity_labels.txt                                                                                #
#   |---------- features.txt                                                                                       #
#   |---------- features_info.txt                                                                                  #
#   |---------- README.txt                                                                                         #
#   |---------- run_analysis.R                                                                                     #
#   |                                                                                                              #
#   |---------- test                                                                                               #
#   |             |---------- Inertial Signals                                                                     #  
#   |             |               |---------- Other Files...                                                       #
#   |             |                                                                                                #
#   |             |---------- X_test.txt                                                                           #
#   |             |---------- y_test.txt                                                                           #
#   |             |---------- subject_test.txt                                                                     #
#   |                                                                                                              #  
#   |---------- train                                                                                              #    
#   |             |---------- Inertial Signals                                                                     #
#   |             |               |---------- Other Files...                                                       #
#   |             |                                                                                                #
#   |             |---------- X_train.txt                                                                          #  
#   |             |---------- y_train.txt                                                                          #
#   |             |---------- subject_train.txt                                                                    #
#                                                                                                                  #
#                                                                                                                  #
# INSTRUCTIONS:                                                                                                    #
# Open this file in RStudio and execute the following commands in the R console:                                   #
#        >  setwd("Drive:/path/to/UCI HAR Dataset") ## Use Forward Slashes!                                        #
#        >  source("run_analysis.R")                                                                               #
#        >  tidy_data()                                                                                            #
#                                                                                                                  #
#                                                                                                                  #
# OUTPUT:                                                                                                          #
# -------                                                                                                          #
# Clean Dataset: clean_data.csv & clean_data.txt (clean data with mean and std features only)                      #
# Tidy Dataset: tidy_data.csv & tidy_data.txt    (tidy data w/ avg of mean & std features per person per activity) #
#                                                                                                                  #
####################################################################################################################



tidy_data <- function(){
  
# Load reshape2 Package
print("### Loading Packages       ###")
if (!is.element("reshape2", installed.packages()[,1])){                          # package installed ?
  install.packages("reshape2")                                                   # install if necessary
} else{
  library(reshape2)                                                              # load package
}
  
## Load Feature Data & combine train and test into a single DF
print("### Reading Dirty Datasets ###")
print("### Please Be Patient      ###")
xTrain<-read.table("train/X_train.txt", sep="")
xTest<-read.table("test/X_test.txt", sep="")
featureData <- rbind(xTrain, xTest)                                              # combine 

## Load Activity Identifiers & combine train and test into a single DF
yTrain<-read.table("train/y_train.txt", sep="")
yTest<-read.table("test/y_test.txt", sep="")
activityLabels <- rbind(yTrain, yTest)                                           # combine
colnames(activityLabels) <- "activityID"                                         # name the variable


# Load Subject Identifiers & combine train and test into a single DF
sTrain <- read.table("train/subject_train.txt", sep="")
sTest <- read.table("test/subject_test.txt", sep="")
subjectLabels <- rbind(sTrain, sTest)                                            # combine
colnames(subjectLabels) <- "subjectID"                                           # name the variable

# Load Feature Names 
featureNames <- read.table("features.txt", sep="")[,2]                           # column 2 of features.txt

# Subset Features of Interest
print("### Subsetting             ###")
interestFeatures <- grep("-mean\\(\\)|-std\\(\\)", featureNames)                 # index of variables with mean() and std()
featureData <- featureData[,interestFeatures]
colnames(featureData) <- featureNames[interestFeatures]

# Pretty Feature Names
print("### Formatting             ###")
colnames(featureData) <- gsub("\\(|\\)", "", names(featureData))                 # remove ()
colnames(featureData) <- tolower(names(featureData))                             # to lower case

# Pretty Activity Names 
activityNames <- read.table("activity_labels.txt", sep="")
activityNames[, 2] <- gsub("_", " ", as.character(activityNames[, 2]))           # replace _ with space
activityNames[, 2] <- tolower(activityNames[,2])                                 # to lower case
activityNames[grep("upstairs",activityNames[,2]),2]<-"walking up"                # shorten
activityNames[grep("downstairs",activityNames[,2]),2]<-"walking down"            # shorten
colnames(activityNames)<-c("activityID","activityName")                          # column names


# Translate Activity ID to Activity Name
print("### Merging                ###")
activityData <- merge(activityLabels,activityNames,by="activityID",sort=FALSE)   # merge while keeping sequence
activityData$activityName <- factor(activityData$activityName)                   # convert names from char to factor


# Create a Tidy Data Frame
print("### Binding                ###")
cleanData <- cbind(subjectLabels,activityData$activityName,featureData)          # cbind
colnames(cleanData)[2]<-"activityName"                                           # tighten up the factor name

# Write to File
print("### Writing                ###")
write.csv(cleanData,"clean_data.csv",row.names=FALSE)                            # write CSV
write.table(cleanData,"clean_data.txt",sep="\t",row.names=FALSE)                 # write tab delimited

# Set the required identifier and measure variables
print("### Melting                ###")
varsID <- c("subjectID","activityName")                                          # IDs
varsMeasure <- setdiff(colnames(cleanData), varsID)                              # Measures = all cols except IDs

# Melt the Data Frame
meltedData <- melt(cleanData, id=varsID, measure.vars=varsMeasure)               # melt()

# Decast as Required
print("### Decasting              ###")
tidyData <- dcast(meltedData,subjectID+activityName ~ variable,mean)             # decast()

# Write to File
print("### Writing                ###")
write.csv(tidyData,"tidy_data.csv",row.names=FALSE)
write.table(tidyData,"tidy_data.txt",sep="\t",row.names=FALSE)

# All Done!
print("### All Done!              ###")
}