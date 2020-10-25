#
# R script to clean data from ...
#

#read data from source into ...
source_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
store_as <- 'temp_input.zip'

download.file(source_url, destfile = store_as)
#zip.readfile.extract(, zipname = "temp_input.zip", unzip = getOption("unzip"))

# test file 2947 obs
a1 <- read.fwf('/Users/robvandererve/Downloads/UCI HAR Dataset/test/X_test.txt', rep(16,561))
a2 <- read.fwf('/Users/robvandererve/Downloads/UCI HAR Dataset/test/Y_test.txt', 1,col.names="activity_code")
a <- bind_cols(a1, a2)
# train file 7352 obs
b1 <- read.fwf('/Users/robvandererve/Downloads/UCI HAR Dataset/train/x_train.txt', rep(16,561))
b2 <- read.fwf('/Users/robvandererve/Downloads/UCI HAR Dataset/train/Y_train.txt', 1,col.names="activity_code")
b <- bind_cols(b1, b2)

#features
mynames <- tolower(as.character(unlist(list(read.delim('/Users/robvandererve/Downloads/UCI HAR Dataset/features.txt', sep=' ', header = FALSE)[2]), use.names = FALSE)))
mynames<- append(mynames, 'activity', after = length(mynames))

c <- bind_rows(a,b)

names(c) <- mynames


selected_cols <- mynames[grep("(mean\\(\\)|std\\(\\))", mynames, ignore.case = TRUE)]
c <- c[,selected_cols]

selected_cols_clean <- tolower(str_replace_all(selected_cols, "\\(\\)\\-|\\-|\\(\\)", "_"))
selected_cols_clean <- str_replace_all(selected_cols_clean, "(\\_)$","")

names(c) <- selected_cols_clean

#d <- c[,selected_cols_clean]

