### Getting & Cleaning Data Course Project
-------------------------------------------

#### <ins>Brief Introduction</ins>

This project is based on wearable computing, which is currently an exciting area of data science. Many companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website and also in the link given below, represent data collected from the accelerometers from the Samsung Galaxy S smartphone and we have to use this data for our project and perform some computations and processing on it.

#### <ins>Objective</ins>

The objective is to demonstrate the ability to collect, work with, and clean a data set by preparing tidy data that can be used for analysis.  The main deliverables are:

	1) tidy data set as described below
	2) link to a Github repository with your script for performing the analysis
	3) code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md
	4) readme file namely README.md explaining how to run the script, what it does and how it works

#### <ins>Script Execution Instructions</ins>

The main steps to be reproduced for script execution and retrieval of the required tidy datasets are described below

 - Download the `UCI HAR Dataset`, available here: (Download dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
 - Extract the downloaded zip file to a location on your computer
 - From this GitHub repository, download the script `run_analysis.R`, and place it into the `UCI HAR Dataset` directory
 - Your folder structure should look as follows
 	```	
		UCI HAR Dataset/                                                                                  
   			|                                                                                               
   			|---------- activity_labels.txt                                                                 
   			|---------- features.txt                                                                        
   			|---------- features_info.txt                                                                  
   			|---------- README.txt                                                                  
   			|---------- run_analysis.R                                                                    
   			|                                                                                             
   			|---------- test                                                                                
   			|             |---------- Inertial Signals                                             
   			|             |               |---------- Other Files...                               
            |             |                                                   
   			|             |---------- X_test.txt                                                   
   			|             |---------- y_test.txt                                                  
   			|             |---------- subject_test.txt                                            
   			|                                                                                     
   			|---------- train                                                                      
   			              |---------- Inertial Signals                                            
   			              |               |---------- Other Files...                            
   			              |                                                                       
   			              |---------- X_train.txt                                                
   			              |---------- y_train.txt                                                 
   			              |---------- subject_train.txt  

    ``` 
 - Now execute the script `run_analysis.R` as follows:
 	- __In RStudio:__
 	 	* With RStudio open `run_analysis.R` to review the script
                * In the RStudio console, change your working directory to the `UCI HAR Dataset` location. Slashes `/` or `\` in your path can be tricky, especially in Windows.  It is best to use the forward slash `/`.
			```
			setwd("Drive:/path/to/UCI HAR Dataset")
			For Example: setwd("C:/Users/Me/Documents/Coursera/JohnHopkins - Getting and Cleaning Data/Project/UCI HAR Dataset")
			```

		* Execute the script as follows:
			```
		        source("run_analysis.R")`
		        tidy_data()
			```		        
		* If the above steps were performed correctly, status messages will print to the console

 - Once done, you will find new files in the `UCI HAR Dataset` folder: 
 
                * Clean Dataset: `clean_data.csv` & `clean_data.txt` (clean data with mean and std features only)
                * Tidy Dataset: `tidy_data.csv` & `tidy_data.txt`    (tidy data w/ avg of mean & std features per person per activity)


  - Detailed contents of each are explained in the `CodeBook.md` file of this repository.
           
#### <ins>Script Details</ins>

Processing is performed by `run_analysis.R` in the following stages. 

   1. "### Loading Packages       ###" - loads reshape2 package in R
   2. "### Reading Dirty Datasets ###" - reads original data sets
      "### Please Be Patient      ###" - this can take some time
   3. "### Subsetting             ###" - subsets original data to only those features which contain 'mean' or 'std'
   4. "### Formatting             ###" - assigns pretty feature names and pretty activity names
   5. "### Merging                ###" - performs translation from activityID to activityName
   6. "### Binding                ###" - creates a clean & tidy data frame
   7. "### Writing                ###" - writes clean_data.csv & clean_data.txt
   8. "### Melting                ###" - melts the clean & tidy data frame with subjectID & activityName as IDs and all other fields as Measures
   9. "### Decasting              ###" - decasts the molten data frame with aggregation on average per subjectID and activityName
  10. "### Writing                ###" - writes the decast data as tidy_data.csv and tidy_data.txt
  11. "### All Done!              ###" - all done!

Find additional detail re: R objects described here in the `CodeBook.md`.


#### <ins>Tidy Dataset Details</ins>

The clean and tidy datasets produced are available in `csv` and `txt` format in the top level of this repository.
