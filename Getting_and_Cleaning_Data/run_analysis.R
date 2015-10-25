require(plyr)

#Loading activity and features Ids
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Id", "Activity"))
features <- read.table("UCI HAR Dataset/features.txt" ,col.names = c("Id", "Feature"))

xtest<-read.table("UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
ytest<-read.table("UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject"))


xtrain<-read.table("UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
ytrain<-read.table("UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject"))

#Merge the training and the test sets to create one data set
traindata<-cbind(cbind(xtrain, subjecttrain), ytrain)
testdata<-cbind(cbind(xtest, subjecttest), ytest)
datamerged<-rbind(traindata, testdata)

#Filter in only mean and std collumns
datamerged <- datamerged[grep(".*mean.*|.*std.*|Subject|Activity", names(datamerged))]
datamerged$Activity <- activityLabels[datamerged$Activity,][,2]
#Compute the mean for each activity and Subject
data<-ddply(datamerged, c("Subject","Activity"), colwise(mean))

#Order by Subject, to be more presentable
data <- data[order(data$Subject),]

write.table(data, file = "tidy_data.txt", row.name=FALSE)