# Variables

Documentation of variables in the Lupus Research Data (loaded in `etl.R` as `d0`).

## Patient Identifiers

| Variable | Description | Type |
|----------|-------------|------|
| study_number | Study identifier | - |
| patient_number | Patient identifier | - |
| hospital_number | Hospital identifier | - |

## Demographics

| Variable | Description | Type |
|----------|-------------|------|
| date_of_birth | Date of birth | Date |
| age_at_biopsy | Age at time of biopsy | Numeric |
| sex | Patient sex | Categorical |
| ethnicity | Patient ethnicity | Categorical |
| community | Community | Categorical |

## Biopsy Information

| Variable | Description | Type |
|----------|-------------|------|
| date_of_biopsy | Date of biopsy | Date |
| time_to_biopsy_from_lupus_nephritis_suspicion_days | Days from LN suspicion to biopsy | Numeric |
| isn_rps_class | ISN/RPS classification | Categorical |
| isn_rps_class_dd | ISN/RPS class (DD) | - |

## Renal Function

| Variable | Description | Type |
|----------|-------------|------|
| u_acr_at_biopsy | Urine albumin-to-creatinine ratio at biopsy | Numeric |
| haematuria | Haematuria present | - |
| haematuria_dd | Haematuria (DD) | - |
| crt_at_biopsy | Creatinine at biopsy | Numeric |
| e_gfr_at_biopsy | Estimated GFR at biopsy | Numeric |
| ckd_stage_dd | CKD stage (DD) | - |

## Hematology

| Variable | Description | Type |
|----------|-------------|------|
| hb | Hemoglobin | Numeric |
| plt | Platelet count | Numeric |
| hb_a1c_percent_at_biopsy | HbA1c % at biopsy | Numeric |

## Immunology - Autoantibodies

| Variable | Description | Type |
|----------|-------------|------|
| anti_gbm | Anti-GBM antibodies | - |
| anca | ANCA | - |
| anca_dd | ANCA (DD) | - |
| ana | Antinuclear antibodies | - |
| ana_dd | ANA (DD) | - |
| ena | Extractable nuclear antigens | - |
| ds_dna | Anti-dsDNA antibodies | - |
| ds_dna_dd | dsDNA (DD) | - |

## Complement

| Variable | Description | Type |
|----------|-------------|------|
| c3 | Complement C3 | Numeric |
| c3_dd | C3 (DD) | - |
| c4 | Complement C4 | Numeric |
| c4_dd | C4 (DD) | - |

## Antiphospholipid Antibodies

| Variable | Description | Type |
|----------|-------------|------|
| anti_b2_glycoprotein_20 | Anti-B2 glycoprotein >20 | - |
| anti_cardiolipin_9 | Anti-cardiolipin >9 | - |
| lupus_anticoagulant | Lupus anticoagulant | - |

## Outcomes

| Variable | Description | Type |
|----------|-------------|------|
| non_dialysis_eskd_e_gfr_15 | Non-dialysis ESKD/eGFR <15 | - |
| permanent_rrt | Permanent renal replacement therapy | - |
| mortality | Mortality | - |
| mortality_dd | Mortality (DD) | - |
| transplant | Transplant | - |

## Other

| Variable | Description | Type |
|----------|-------------|------|
| notes | Additional notes | Text |

---

*Note: Variable names are converted to snake_case by `janitor::clean_names()` in etl.R*
