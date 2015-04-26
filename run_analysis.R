library(data.table)

testDataX <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testDataY <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testDataSub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainDataX <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainDataY <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainDataSub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# 3) Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testDataY$V1 <- factor(testDataY$V1,levels=activities$V1,labels=activities$V2)
trainDataY$V1 <- factor(trainDataY$V1,levels=activities$V1,labels=activities$V2)

# 4) Appropriately labels the data set with descriptive variable names. 
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testDataX)<-features$V2
colnames(trainDataX)<-features$V2
colnames(testDataY)<-c("Activity")
colnames(trainDataY)<-c("Activity")
colnames(testDataSub)<-c("Subject")
colnames(trainDataSub)<-c("Subject")
 
# 1) Merges the training and the test sets to create one data set.
testDataX<-cbind(testDataX,testDataY)
testDataX<-cbind(testDataX,testDataSub)
trainDataX<-cbind(trainDataX,trainDataY)
trainDataX<-cbind(trainDataX,trainDataSub)
bigData<-rbind(testDataX,trainDataX)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)

# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy, file="tidyData.txt", row.name=FALSE, sep = "\t")
