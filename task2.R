##-----------------------------------------------------------##
##  Task 2                                                   ##
##-----------------------------------------------------------##
# T2. find all files under path "./data/csv_files/" with      #
# suffix of "example_test.csv". Load the data from each file  #
# and merge all data into a single dataframe (data structure  #
# is consistent among all files).                             #
# then group the data by gene name then count the number of   #
# variants (records) of each gene                             #
##-----------------------------------------------------------##

file_paths <- list.files("data/csv_files/", "example_test.csv", recursive = T, full.names = T)
files <- lapply(file_paths, read.csv, stringsAsFactors = F)
df <- rbind(files[[1]], files[[2]])
df <- df[order(df$GENE),]
agg <- aggregate(df, by = list(GENE = df$GENE), FUN = length)[,1:2]
colnames(agg)[2] <- "VARIANTS"
print(agg)
