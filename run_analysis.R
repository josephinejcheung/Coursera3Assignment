#run_analysis for assignment 
#-----------------

#------------EXTRACT ALL DATA INTO MEMORY ----------
#store directory before pulling files
olddir <- getwd()

#extract keys
keydir <- "./Dataset"
setwd(keydir)
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
setwd(olddir)

#extract test data
testdir <- "./Dataset/test"
setwd(testdir)
subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
Y_test <- read.table("Y_test.txt")
setwd(olddir)

#extract train data
traindir <- "./Dataset/train"
setwd(traindir)
subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
Y_train <- read.table("Y_train.txt")
setwd(olddir)

#--------------PROCESS DATA ----------------
#Step 1
#merge train and test data 
subject <- rbind(subject_test, subject_train)
X <- rbind(X_test,X_train) 
Y <- rbind(Y_test,Y_train)

#Rename X with features names 
library(data.table)
setnames(X,old = names(X), new = features$V2)

#Step 2. trim X for mean and standard deviation measurements only
trimcols <- grep("mean\\(\\)|std\\(\\)",names(X))
X <- X[,trimcols]

#Step 3. bind activity name onto Y
Y <- merge(Y,activity_labels,sort=FALSE)
setnames(Y,old =names(Y), new = c("activity_no","activity_desc"))
setnames(subject, old=names(subject), new = "subject_no")
df <- cbind(subject,Y,X)

#Step 4. Cleanse features 
names(df) <- gsub("\\(\\)","", names(df))
names(df) <- gsub("-","_",names(df))

df
write.table(df,file="output1_data.txt",row.names=FALSE)

#Step 5. Summarise into a tidy data set 
summary <- sapply(split(df[4:69],list(df$activity_desc,df$subject_no)),colMeans,na.rm=TRUE)
summary <- t(summary[,!is.na(summary[4,])])

summary
write.table(summary,file="output2_summary.txt",row.names=FALSE)