library(curl)
library(dplyr)
fileName<-"getdata_projectfiles_UCI_HAR_Dataset.zip"
if (! file.exists(fileName)) {
     fileUrl<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	 download.file(fileUrl, fileName, quiet = TRUE, mode = "wb")
	 unzip(fileName)
    }
#Read test data
Test_Activity<-read.table(paste0(".//UCI HAR Dataset//test//","y_test.txt"))
Test_Subject<-read.table(paste0(".//UCI HAR Dataset//test//","subject_test.txt"))
Test_Feature<-read.table(paste0(".//UCI HAR Dataset//test//","x_test.txt"))

#Read train data
Train_Activity<-read.table(paste0(".//UCI HAR Dataset//train//","y_train.txt"))
Train_Subject<-read.table(paste0(".//UCI HAR Dataset//train//","subject_train.txt"))
Train_Feature<-read.table(paste0(".//UCI HAR Dataset//train//","x_train.txt"))

#Merge train and test data

Activity<- rbind(Train_Activity,Test_Activity)
Subject <- rbind(Train_Subject, Test_Subject)
Feature<- rbind(Train_Feature, Test_Feature)

#Set colume names
names(Activity)<- c("Activity")
names(Subject)<-c("Subject")
FeatureNames<- read.table(file.path(".//UCI HAR Dataset//features.txt"),head=FALSE)
names(Feature)<- FeatureNames$V2
#Read activity label
Activity_Label<-read.table(".//UCI HAR Dataset/activity_labels.txt",header=FALSE)
Activity[,1]<-Activity_Label[Activity[,1],2]
#Merge all data in one dataset
Data<- cbind(Activity,Subject)
Data<-cbind(Data,Feature)

#Get std and mean data
std_and_meanFeatureName<-FeatureNames$V2[grep("mean\\(\\)|std\\(\\)",FeatureNames$V2)]
Data_Names<-c("Activity","Subject",as.character(std_and_meanFeatureName))
Data<-subset(Data,select=Data_Names)

#Make a tidy DataSet
tidyData<-ddply(Data, .(Activity,Subject), function(x) colMeans(x[, 3:68]))
