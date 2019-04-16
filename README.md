---
title: Coding Problem Sets
output:
  html_document:
    toc: true
    toc_depth: 2
    code_folding: hide
---
# Introduction

This document details the assortment of coding tasks that I've come across. Bear with the haphazardness with which they're arranged, as I'm still deciding between grouping by assignments or by perceived difficulty, or any other way to organise the problem sets.  

If there are any issues, or there's better implementations of my solutions, please let me know! I'd be happy to resolve the issues and learn more. :smiley:

***

# Job application #1

## Task 1

Task one was simple, iterate through 1-100, printing each number with some exceptions. Multiples of three would be substituted with string `A`, while multiples of five with string `B`. Multiples of both 3 **and** 5 (i.e. 15), were to be substituted with string `A + B`.

Here I've chosen the classic `Hello World` in place of the strings. 

Solution:  
```
for(i in 1:100){
    if(i%%3 == 0){
        if(i%%5 ==0){
            print("Hello World")
        }else{
            print("Hello")
        }
    }else{
        if(i%%5 ==0){
            print("World")
        }else{
            print(i)
        }
    }
}
```

We check whether remainders are zero to determine if the number is a multiple of 3 or 5. This set the conditions for our flow control.

Flow control is built on the idea that if a given number is not a multiple of the first number, it is either a multiple of the second number or not. If that number *is* a multiple of the first number, then we test if it is a multiple of the second number or not. The order of which multiple to test for doesn't matter.

## Task 2

The focus of task two was pattern matching, file system interaction, and dataframe manipulation. The task requires searching a directory for csv files suffixed "example_test.csv", merging them, then getting a tally of how many variants exist for each gene.  
A visual inspection of the directory showed that the files were stored across different subfolders, so a recursive search was needed. Furthermore, there were decoy files that could be picked up if pattern matching was not done properly.

Solution:  

```
file_paths <- list.files("data/csv_files/", "example_test.csv", recursive = T, full.names = T)
files <- lapply(file_paths, read.csv, stringsAsFactors = F)
df <- rbind(files[[1]], files[[2]])
df <- df[order(df$GENE),]
agg <- aggregate(df, by = list(GENE = df$GENE), FUN = length)[,1:2]
colnames(agg)[2] <- "VARIANTS"
print(agg)
```

## Task 3

This task is more work on data manipulation. In fact, this task could be easier done using SQL (or SQL through R). For this task, two tables with different data need to be merged on a common column of identifiers using a left join.

The left table is a table of gene variants, while the right table is a table of drugs and diseases associated with each variant.

Then using the merged tables, we calculate the number of unique "disease" types associated with each "variant".

Solution:  

```
variant_data <- read.csv("data/sample_variants.csv", stringsAsFactors = F)
clinical_evidence_data <- read.csv("data/sample_clinical_evidence.csv", stringsAsFactors = F)
head(clinical_evidence_data)
merged <- merge(variant_data, clinical_evidence_data, by = "variant_id", all.x = 'T')
agg_by_variant <- aggregate(merged, by = list(variant = merged$variant, disease = merged$disease), FUN = length)[,1:2]
disease_count_byVariant <- aggregate(agg_by_variant, by = list(variant = agg_by_variant$variant), FUN = length)[,1:2]
colnames(disease_count_byVariant)[2] <- 'disease_count'
disease_count_byVariant$order <- order(variant_data$variant)
disease_count_byVariant <- disease_count_byVariant[order(disease_count_byVariant$order),1:2]
print(disease_count_byVariant)
```

## Task 4

Task four is an example involving sequence depth. In sequencing, for each position in the nucleotide sequence, there is an associated depth value (i.e. how many times has that position been sequenced in the experiment). The sequencing depth can be used as a QC measure; if a region has not been sequenced to an adequate depth, it would not be as reliable as data compared to a region that was sequenced to a higher depth.

For this task, we have a `.bed` file that indicates target genes and their position in terms of which chromosome they are on, and at which positions along the nucleotide the gene starts and ends. We are also provided with a `.txt` file that contains a table of nucleotide positions and its corresponding sequencing depth.

The task is to print out, for each gene, the nucleotide positions within the gene's range, and the corresponding depth. If the `.txt` file has no record for a given position, our script should return a depth of zero.

One consideration here is that we would need to match chromosome between the target genes and the `.txt` table, not just nucleotide positions.

Solution:  

```
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
```

The solution here runs iteratively through the targets start to end positions, so that we can check if the depth table has a missing record for that position, and if so then return a depth of zero.