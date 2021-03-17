library(dplyr)

#loading data
features<-read.table("features.txt", col.names = c("n", "functions"))
head(features)
activities<-read.table("activity_labels.txt", col.names=c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

#1
X<-rbind(x_train, x_test)
Y<-rbind(y_train, y_test)
subject<-rbind(subject_train, subject_test)
merged.data<-cbind(subject, Y, X)
str(merged.data)

#2
extracted.data<-merged.data %>%
    select(subject, code, contains("mean"), contains("std"))
head(extracted.data$subject,500)

#3
str(activities)
extracted.data$code<-activities[extracted.data$code, 2]

#4
names(extracted.data)[2]<-"activity"
names(extracted.data)<-gsub("Acc", "Accelerometer", names(extracted.data))
names(extracted.data)<-gsub("Gyro", "Gyroscope", names(extracted.data))
names(extracted.data)<-gsub("BodyBody", "Body", names(extracted.data))
names(extracted.data)<-gsub("Mag", "Magnitude", names(extracted.data))
names(extracted.data)<-gsub("^t", "Time", names(extracted.data))
names(extracted.data)<-gsub("^f", "Frequency", names(extracted.data))
names(extracted.data)<-gsub("tBody", "TimeBody", names(extracted.data))
names(extracted.data)<-gsub("-mean()", "Mean", names(extracted.data), ignore.case = TRUE)
names(extracted.data)<-gsub("-std()", "STD", names(extracted.data), ignore.case = TRUE)
names(extracted.data)<-gsub("-freq()", "Frequency", names(extracted.data), ignore.case = TRUE)
names(extracted.data)<-gsub("angle", "Angle", names(extracted.data))
names(extracted.data)<-gsub("gravity", "Gravity", names(extracted.data))

#5
str(extracted.data)
extracted.data$activity<-as.factor(extracted.data$activity)
new.data<- extracted.data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
print(new.data)    
str(new.data)
head(new.data)
write.table(new.data, "newdata.txt", row.name=F)
str(new.data)
