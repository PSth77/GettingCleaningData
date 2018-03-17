## Set working directory
setwd("C:/Users/Admin/Desktop/UCI HAR Dataset")

## Read all data
rawx1 <- read.table("./test/X_test.txt")
rawy1 <- read.table("./test/Y_test.txt")
raws1 <- read.table("./test/subject_test.txt")
rawx2 <- read.table("./train/X_train.txt")
rawy2 <- read.table("./train/Y_train.txt")
raws2 <- read.table("./train/subject_train.txt")
features <- read.table("features.txt")
actlab <- read.table("activity_labels.txt")

## Rename tables
names(rawx1) = features[,2]
names(rawx2) = features[,2]

## Extract mean and std columns
extract <- grepl("mean|std",features[,2])
rawx1 <- rawx1[,extract]
rawx2 <- rawx2[,extract]

## Add activity lables
rawy1[,2] = actlab[rawy1[,1],2]
rawy2[,2] = actlab[rawy2[,1],2]

## Add column names
names(rawy1) = c("Activity_ID", "Activity_Label")
names(raws1) = "subject"
names(rawy2) = c("Activity_ID", "Activity_Label")
names(raws2) = "subject"

## Merge data across columns
test_data <- cbind(as.data.table(raws1), rawy1, rawx1)
train_data <- cbind(as.data.table(raws2), rawy2, rawx2)

## Merge data across rows
final_data <- rbind(test_data, train_data)

## Clear Environment
remove("actlab", "features", "raws1", "raws2", "rawx1", "rawx2", "rawy1", "rawy2", "test_data", "train_data", "extract")

## Create tidy data with means
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(final_data), id_labels)
melt_data = melt(final_data, id = id_labels, measure.vars = data_labels)
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)