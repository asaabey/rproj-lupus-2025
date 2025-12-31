rm(list=ls())
library(dplyr)


d1 <- rio::import("data/stage1.rds")

# Create df1 with first biopsy per patient (based on earliest date_of_biopsy)
df1 <- d1 %>%
  group_by(patient_number) %>%
  arrange(date_of_biopsy) %>%
  slice(1) %>%
  ungroup()
# Check dimensions
dim(df1)
