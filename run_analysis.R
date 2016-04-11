if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files
activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

str(activityTest)
str(activityTrain)
str(subjectTrain)
str(subjectTest)
str(featuresTest)
str(featuresTrain)

subject <- rbind(subjectTrain, subjectTest)
activity<- rbind(activityTrain, activityTest)
features<- rbind(featuresTrain, featuresTest)

names(subject)<-c("subject")
names(activity)<- c("activity")
featuresNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(features)<- featuresNames$V2

datacombine <- cbind(subject, activity)
data <- cbind(features, datacombine)

fname<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
selectedNames<-c(as.character(fname), "subject", "activity" )
data<-subset(data,select=selectedNames)
str(data)

nlabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
head(labels)
head(data$activity,30)

data$activity <- factor(data$activity,levels = nlabels$V1, labels = nlabels$V2)


names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

names(data)

library(plyr)
Data<-aggregate(. ~subject + activity, data, mean)
Data<-Data[order(Data$subject,Data$activity),]
write.table(Data, file = "tidydata.txt",row.name=FALSE)


