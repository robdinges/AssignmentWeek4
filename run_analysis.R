#
# R script to clean data from ...
#
print('loading libraries ...')
library(dplyr)
print('done')

# test file a 2947, 1=observations. 2=activities, 3=subjects
print('reading test files ...')
test_observations <- read.fwf('UCI HAR Dataset/test/X_test.txt', rep(16,561))
test_activities <- read.fwf('UCI HAR Dataset/test/Y_test.txt', 1,col.names="activity")
test_subjects <- read.fwf('UCI HAR Dataset/test/subject_test.txt', 10, col.names="subject")
print('done')

# train file b 7352 obs, 1=observations. 2=activities, 3=subjects
print('reading train files ...')
train_observations <- read.fwf('UCI HAR Dataset/train/x_train.txt', rep(16,561))
train_activities <- read.fwf('UCI HAR Dataset/train/Y_train.txt', 1, col.names="activity")
train_subjects <- read.fwf('UCI HAR Dataset/train/subject_train.txt', 10, col.names="subject")
print('done')

# merge the data
print('merge files ...')
test_data <- bind_cols(test_observations, test_activities, test_subjects)
train_data <- bind_cols(train_observations, train_activities, train_subjects)
all_data <- bind_rows(test_data, train_data)
print('done')

print('and the rest ...')

# read activities reference data
activities_descriptions <- read.delim('UCI HAR Dataset/activity_labels.txt', sep=' ', header = FALSE, col.names = c('activity_id', 'activity_name'))

# read features as column data for c (all observations)
mynames <- tolower(as.character(unlist(list(read.delim('UCI HAR Dataset/features.txt', sep=' ', header = FALSE)[2]), use.names = FALSE)))
mynames<- append(mynames, c('activity','subject'), after = length(mynames))
names(all_data) <- mynames

# filter the columns with mean() or std(), add the columns fot activity and subject
selected_cols <- mynames[grep("(mean\\(\\)|std\\(\\)|activity|subject)", mynames, ignore.case = TRUE)]
filtered_data <- all_data[,selected_cols]

# make the column names more readable
selected_cols_clean <- tolower(str_replace_all(selected_cols, "\\(\\)\\-|\\-|\\(\\)", "_"))
selected_cols_clean <- str_replace_all(selected_cols_clean, "(\\_)$","")

# rename the columns of filtered_data
names(filtered_data) <- selected_cols_clean

# add the descriptions to the activities (factors)
filtered_data$activity <- factor(filtered_data$activity, levels = activities_descriptions[[1]], labels = activities_descriptions[[2]])

# group by activity and subject and then create the table with means of all selected columns
assignment_result <- filtered_data %>% group_by(activity, subject) %>% summarise_all(funs(mean))

# write the table to assignment_result.txt
write.table(assignment_result, 'assignment_result.txt', sep=",", row.names = FALSE)

print("everything's ready!")

