# ETL Script for Lupus Research Data
# Load required packages
rm(list = ls())

library(dplyr)

setwd("/mnt/readynas/ntg-jolghazi-lupus-2025/")

# stop at row 125
# Load excel ----
d0 <- rio::import("data/Lupus Research 7 with Data Dictionary.xlsx", sheet = "Main", skip = 1, n_max = 123) %>% janitor::clean_names()



# Transformations
d0 <- d0 %>%
  mutate(
    u_acr_at_biopsy = as.numeric(u_acr_at_biopsy),
    crt_at_biopsy = as.numeric(crt_at_biopsy),
    hb = as.numeric(hb),
    plt= as.numeric(plt),
    hb_a1c_percent_at_biopsy = as.numeric(hb_a1c_percent_at_biopsy),
    c3 = as.numeric(c3),
    c4 = as.numeric(c4)
  )

# Rank presentations by patient (descending by date - most recent = 1) ----
d0 <- d0 %>%
  group_by(hospital_number) %>%
  arrange(desc(date_of_biopsy)) %>%
  mutate(
    presentation_rank = row_number(),
    total_presentations = n(),
    is_first_presentation = (presentation_rank == 1),
    is_last_presentation = (presentation_rank == total_presentations)
  ) %>%
  ungroup() 


# break u_actr_at_biopsy into categories, use break point 3,30,300
d0 <- d0 %>%
  mutate(
    u_acr_category = case_when(
      u_acr_at_biopsy < 3 ~ "Normal",
      u_acr_at_biopsy >= 3 & u_acr_at_biopsy < 30 ~ "Microalbuminuria",
      u_acr_at_biopsy >= 30 & u_acr_at_biopsy < 300 ~ "Macroalbuminuria",
      u_acr_at_biopsy >= 300 ~ "Nephrotic range",
      TRUE ~ NA_character_
    )
  )

# what is the best way to visualize the u_acr_category variable?
d0$u_acr_category <- factor(d0$u_acr_category, levels = c("Normal", "Microalbuminuria", "Macroalbuminuria", "Nephrotic range"))

# combine NA and normal into one  category
d0 <- d0 %>%
  mutate(
    u_acr_category = ifelse(is.na(u_acr_category), "Normal", as.character(u_acr_category))
  )


# create a new variable called indigenous_status using ethnicity
d0 <- d0 %>%
  mutate(
    indigenous_status = if_else(ethnicity == "Aboriginal","Indigenous","Non-Indigenous")
  )

# create female_gender variable from sex
d0 <- d0 %>%
  mutate(
    female_gender = if_else(sex == "F", "Female", "Male")
  )

# create remoteness variable from community
d0 <- d0 %>%
  mutate(
    remote = if_else(
      community == "DARWIN", FALSE,TRUE
    )
  )

# create haematuria_dd variable from haematuria_at_biopsy
d0 <- d0 %>%
  mutate(
    haematuria_dd = case_when(
      haematuria == "Yes" ~ "Present",
      haematuria == "No" ~ "Absent",
      TRUE ~ NA_character_
    )
  )

# Create ISN/RPS class dummy variables ----
d0 <- d0 %>%
  mutate(
    isn_class_I = as.integer(grepl("1", isn_rps_class)),
    isn_class_II = as.integer(grepl("2", isn_rps_class)),
    isn_class_III = as.integer(grepl("3", isn_rps_class)),
    isn_class_IV = as.integer(grepl("4", isn_rps_class)),
    isn_class_V = as.integer(grepl("5", isn_rps_class)),
    isn_class_VI = as.integer(grepl("6", isn_rps_class))
  )

# Create clinically relevant groupings ----
d0 <- d0 %>%
  mutate(
    # Pure vs mixed class
    isn_pure_class = case_when(
      grepl("and|or", isn_rps_class) ~ "Mixed",
      !is.na(isn_rps_class) ~ "Pure",
      TRUE ~ NA_character_
    ),
    # Proliferative (III or IV)
    isn_proliferative = as.integer(isn_class_III == 1 | isn_class_IV == 1),
    # Any membranous (V)
    isn_membranous = isn_class_V
  )

# Recode antiphospholipid antibodies to logical (TRUE/FALSE) ----
d0 <- d0 %>%
  mutate(
    # Anti-beta2 glycoprotein: Y=TRUE, N=FALSE, NC=NA
    anti_b2_glycoprotein = case_when(
      anti_b2_glycoprotein_20 == "Y" ~ TRUE,
      anti_b2_glycoprotein_20 == "N" ~ FALSE,
      anti_b2_glycoprotein_20 == "NC" ~ NA,
      TRUE ~ NA
    ),
    # Anti-cardiolipin: Y=TRUE, N=FALSE, NC=NA
    anti_cardiolipin = case_when(
      anti_cardiolipin_9 == "Y" ~ TRUE,
      anti_cardiolipin_9 == "N" ~ FALSE,
      anti_cardiolipin_9 == "NC" ~ NA,
      TRUE ~ NA
    ),
    # Lupus anticoagulant: Y=TRUE, N=FALSE, NC=NA
    lupus_anticoagulant_positive = case_when(
      lupus_anticoagulant == "Y" ~ TRUE,
      lupus_anticoagulant == "N" ~ FALSE,
      lupus_anticoagulant == "NC" ~ NA,
      TRUE ~ NA
    ),
    # Anti-dsDNA: H=TRUE (high/positive), N=FALSE (normal/negative), NC=NA
    anti_dsdna_positive = case_when(
      ds_dna_dd == "H" ~ TRUE,
      ds_dna_dd == "N" ~ FALSE,
      ds_dna_dd == "NC" ~ NA,
      TRUE ~ NA
    ),
    # C3 low: TRUE if low (L or VL), FALSE if normal (N), NA if NC or missing
    c3_low = case_when(
      c3_dd == "L" | c3_dd == "VL" ~ TRUE,
      c3_dd == "N" ~ FALSE,
      c3_dd == "NC" ~ NA,
      TRUE ~ NA
    ),
    # C3 very low: TRUE if low (L or VL), FALSE if normal (N), NA if NC or missing
    c3_very_low = case_when(
      c3_dd == "VL" ~ TRUE,
      c3_dd == "L" | c3_dd == "N" ~ FALSE,
      c3_dd == "NC" ~ NA,
      TRUE ~ NA
    ),
    # C4 low: TRUE if low (L), FALSE if normal/high (N or H), NA if NC or missing
    c4_low = case_when(
      c4_dd == "L" ~ TRUE,
      c4_dd == "N" | c4_dd == "H" ~ FALSE,
      c4_dd == "NC" ~ NA,
      TRUE ~ NA
    ),
    # C4 very low: TRUE if low (L), FALSE if normal/high (N or H), NA if NC or missing
    c4_very_low = case_when(
      c4_dd == "VL" ~ TRUE,
      c3_dd == "L" | c4_dd == "N" | c4_dd == "H" ~ FALSE,
      c4_dd == "NC" ~ NA,
      TRUE ~ NA
    )
  )

# Create ANA ≥1:80 logical variable ----
d0 <- d0 %>%
  mutate(
    ana_80 = case_when(
      # Include all titres >= 1:80
      ana %in% c(">1:1280", ">1:2560", ">1:640",
                 "1:1280", "1:160", "1:2560", "1:320", "1:640", "1:80",
                 "POSITIVE") ~ TRUE,
      # N (negative) and NC (not checked) are FALSE
      ana %in% c("N", "NC") ~ FALSE,
      # Missing values remain NA
      TRUE ~ NA
    )
  )
# create ANA >- 1:320 logical variable ----

d0 <- d0 %>%
  mutate(
    ana_320 = case_when(
      # Include all titres >= 1:80
      ana %in% c(">1:1280", ">1:2560", ">1:640",
                 "1:1280", "1:2560", "1:320", "1:640") ~ TRUE,
      # N (negative) and NC (not checked) are FALSE
      ana %in% c("N", "NC") ~ FALSE,
      # Missing values remain NA
      TRUE ~ NA
    )
  )

# Save cleaned data ----
d0 %>%  rio::export("data/stage1.rds")

