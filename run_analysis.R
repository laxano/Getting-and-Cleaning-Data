library("data.table")

## read data files from UCI \HAR \Dataset folder 
trainSubjectData = data.table(read.table("./UCI HAR Dataset/train/subject_train.txt"))
testSubjectData = data.table(read.table("./UCI HAR Dataset/test/subject_test.txt"))
trainActivityData = data.table(read.table("./UCI HAR Dataset/train/Y_train.txt"))
testActivityData = data.table(read.table("./UCI HAR Dataset/test/Y_test.txt"))
trainData <- data.table(read.table("./UCI HAR Dataset/train/X_train.txt"))
testData <- data.table(read.table("./UCI HAR Dataset/test/X_test.txt"))

## merge train and test subject data
subjectData <- rbind(trainSubjectData, testSubjectData)
## merge train and test activity data
activityData <- rbind(trainActivityData, testActivityData)
## merge measurements
data <- rbind(trainData, testData)

## use meaningful names
setnames(subjectData, "V1", "subject")
setnames(activityData, "V1", "activityNumber")

## merge columns from subject data, activity data, measurements
subjectData <- cbind(subjectData, activityData)
data <- cbind(subjectData, data)

## read feature descriptions
featuresDesc = data.table(read.table("./UCI HAR Dataset/features.txt"))

## Get only rows for measurements on the mean and standard deviation
featuresDesc <- featuresDesc[grep("mean\\(\\)|std\\(\\)", featuresDesc$V2, perl=TRUE),]

## change the values of the first column of featuresDesc to match column name (V?) in data: add 'V' in the begining
## of values in featuresDesc$V1
featuresDesc$V1 <- featuresDesc[, paste0("V", featuresDesc$V1)] 

## keep only those columns in data that their names match values in featuresDesc$V1 (plus columns "subject" and
## "activityNumber")
data <- data[,c("subject","activityNumber",featuresDesc$V1),with=FALSE] 

## read activity names
activitiesName <- data.table(read.table("./UCI HAR Dataset/activity_labels.txt"))
## change column name 'V1' to 'activityNumber' (to use in 'by' clause in merge function), and 'V2' to 'activityName' (since 'V2' is used as a column name in data) in order to proceed with the join
setnames(activitiesName, "V1", "activityNumber")
setnames(activitiesName, "V2", "activityName")

## join with data in order to include activity names
data <- merge(data, activitiesName, by="activityNumber", all.x=TRUE)

## re-arrange data: start with columns activityNumber, subject, activityName, and go on with V? columns
data <- data[,c(2,69, 3:68),with=FALSE]

## get column names V* from data
names <- names(data)
names <- names[grep("V", names(data), perl=TRUE)] 

## replace columns names V*  in data with full feature descriptions from featuresDesc
setnames(data, names, as.character(featuresDesc$V2))

## melt data to ease the computation of measurement means per subject per activity: column names (i.e., feature names) become values
data<-melt(data, id = c("subject", "activityName"))

## re-shape: values (feature names) become column names again 
data <- dcast(data, subject + activityName ~ variable, mean)

## write the 'tidy' dataset!!! END!!!
write.table(data, "tidy.txt", row.names = FALSE, quote = FALSE)

