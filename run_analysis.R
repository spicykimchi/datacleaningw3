library(data.table)

testDataX <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testDataY <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testDataSub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainDataX <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainDataY <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainDataSub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

subject_all <- rbind(testDataSub, trainDataSub)
features_data <- rbind(testDataX, trainDataX)

# 3) Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)

# 4) Appropriately labels the data set with descriptive variable names. 
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")

# 1) Merges the training and the test sets to create one data set.
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
bigData<-rbind(testData,trainData)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)

# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidydata.csv",sep=",",row.names = FALSE)