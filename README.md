# IsletCalc

<!-- badges: start -->
[![R-CMD-check](https://github.com/sufyansuleman/IsletCalc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sufyansuleman/IsletCalc/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

## Overview

IsletCalc computes surrogate indices of pancreatic islet hormone release from
fasting and 75 g oral glucose tolerance test (OGTT) measurements — covering
both beta-cell (insulin) and alpha-cell (glucagon) function in one lightweight,
dependency-free package.

## Installation

```r
# once on CRAN:
install.packages("IsletCalc")

# development version:
remotes::install_github("sufyansuleman/IsletCalc")
```

## Functions

- `insulin_release(data, category = c("fasting", "ogtt"))` — beta-cell
  insulin release indices: HOMA-beta, Corrected Insulin Response (CIR),
  Stumvoll first-phase index, insulinogenic indices (Xinsdg30, Xinsg30),
  BIGTT-AIR, and disposition indices (Di, Dibig). Formulas follow
  Madsen et al. (2024, *Nature Metabolism*, <doi:10.1038/s42255-024-01140-6>).
- `glucagon_release(data)` — alpha-cell glucagon secretion magnitude:
  fasting glucagon and glucagon AUC.
- `glucagon_resistance(data)` — glucagon suppression / resistance indices:
  glucagon suppression ratio and fasting glucagon:insulin ratio, reflecting
  impaired hepatic glucagon signaling (the "liver-alpha-cell axis").

## Quick start

```r
library(IsletCalc)
data(example_data)

insulin_release(example_data, category = c("fasting", "ogtt"))
glucagon_release(example_data)
glucagon_resistance(example_data)
```

## Input data

| Column | Meaning | Unit |
|---|---|---|
| `G0`, `G30`, `G120` | Glucose at 0/30/120 min | mmol/L |
| `I0`, `I30`, `I120` | Insulin at 0/30/120 min | pmol/L |
| `sex` | Sex | 1 = male, 0/2 = female |
| `bmi` | Body mass index | kg/m^2 |
| `Glucagon0`, `Glucagon30`, `Glucagon120` | Glucagon at 0/30/120 min | pmol/L |

Only the columns required for a requested index need to be present; missing
columns cause that specific index to be skipped with a warning rather than
the whole call failing.

## Citation

```r
citation("IsletCalc")
```

## Related package

For insulin **sensitivity** indices (as opposed to release), see
[InsuSensCalc](https://github.com/sufyansuleman/InsuSensCalc).
