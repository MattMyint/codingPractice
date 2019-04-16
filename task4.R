##-----------------------------------------------------------------------------------------##
##  Task 4                                                                                 ##
##-----------------------------------------------------------------------------------------##
# T4. you have the read depth file (samtools_depth.txt) calculated from the bamfile using   #
# samtools, and the bed file (target_panel.bed) for our targetted regions. We would like    #
# to get the read depth for each of the target range specifed in bed file. If no match      #
# record in samtools_depth.txt then put depth as 0                                          #
##-----------------------------------------------------------------------------------------##

depth <- read.delim("data/samtools_depth.txt",stringsAsFactors = F)
targets <- read.delim("data/target_panel.bed",stringsAsFactors = F)
target_depths <- list()
for (i in 1:nrow(targets)) {
    target_depths[[targets$name[i]]] <- list(chr = NULL, pos = NULL, name = NULL, depth = NULL)
    span <- targets$start[i]:targets$end[i]
    for (j in seq_along(span)) {
        target_depths[[targets$name[i]]][['chr']][j] <- targets$chr[i]
        target_depths[[targets$name[i]]][['pos']][j] <- span[j]
        target_depths[[targets$name[i]]][['name']][j] <- targets$name[i]
        row_check <- depth[depth$chr == targets$chr[i] & depth$pos == span[j],]
        if(nrow(row_check) == 0){
            target_depths[[targets$name[i]]][['depth']][j] <- 0
        }else{
            target_depths[[targets$name[i]]][['depth']][j] <- row_check$depth
        }
    }
    target_depths[[targets$name[i]]] <- as.data.frame(target_depths[[targets$name[i]]])
}
print(target_depths)
