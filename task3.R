##-----------------------------------------------------------------------------------------##
##  Task 3                                                                                 ##
##-----------------------------------------------------------------------------------------##
# T3. load variant data from file "sample_variants.csv" (each row is a variant)             #
# save the data frame into variable "variant_data".                                         #
# Load variant clinical evidence from file "sample_clinical_evidence.csv"                   #
# (each row is a clinical evidence for a specific variant, one variant can have             #
# multiple clinical evidences), save the data frame into variable "clinical_evidence_data". #
# Then join "variant_data" and "clinical_evidence_data" on the column of "variant_id" using #
# left join (keep all variant_id from sample_variants.csv), and calculate the number of     #
# unique "disease" types associated with each "variant".                                    #
##-----------------------------------------------------------------------------------------##

variant_data <- read.csv("data/sample_variants.csv", stringsAsFactors = F)
#head(variant_data)
clinical_evidence_data <- read.csv("data/sample_clinical_evidence.csv", stringsAsFactors = F)
head(clinical_evidence_data)
merged <- merge(variant_data, clinical_evidence_data, by = "variant_id", all.x = 'T')
#head(merged)
agg_by_variant <- aggregate(merged, by = list(variant = merged$variant, disease = merged$disease), FUN = length)[,1:2]
disease_count_byVariant <- aggregate(agg_by_variant, by = list(variant = agg_by_variant$variant), FUN = length)[,1:2]
colnames(disease_count_byVariant)[2] <- 'disease_count'
disease_count_byVariant$order <- order(variant_data$variant)
disease_count_byVariant <- disease_count_byVariant[order(disease_count_byVariant$order),1:2]
print(disease_count_byVariant)
