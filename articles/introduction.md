# Introduction to IsletCalc

``` r

library(IsletCalc)
```

## Overview

IsletCalc computes surrogate indices of pancreatic islet hormone release
from fasting and 75 g oral glucose tolerance test (OGTT) measurements,
covering both beta-cell and alpha-cell function:

- [`insulin_release()`](https://sufyansuleman.github.io/IsletCalc/reference/insulin_release.md):
  beta-cell insulin release indices (HOMA-beta, CIR, Stumvoll,
  BIGTT-AIR, disposition indices), following Madsen et al. (2024)
  <doi:10.1038/s42255-024-01140-6>.
- [`glucagon_release()`](https://sufyansuleman.github.io/IsletCalc/reference/glucagon_release.md):
  alpha-cell glucagon secretion magnitude (fasting glucagon, glucagon
  AUC).
- [`glucagon_resistance()`](https://sufyansuleman.github.io/IsletCalc/reference/glucagon_resistance.md):
  glucagon suppression / resistance indices, reflecting impaired hepatic
  glucagon signaling as described in the liver-alpha-cell-axis
  literature.

## Insulin release

``` r

data(example_data)
res <- insulin_release(example_data, category = c("fasting", "ogtt"))
head(res)
#>     G0  G30 G120   I0   I30  I120 sex  bmi Glucagon0 Glucagon30 Glucagon120
#> 1 5.71 8.39 5.59 56.4 283.5 171.5   0 19.3      3.33       2.58        3.72
#> 2 5.06 8.45 6.31 39.7 153.9 115.1   0 29.4     13.71      10.10        6.92
#> 3 4.59 7.85 6.16 87.5 512.8 257.1   0 26.6      6.28       4.27        4.58
#> 4 5.29 7.72 7.01 71.7 390.1  67.7   1 21.4     11.36       8.71        8.77
#> 5 5.13 8.27 5.78 31.3 182.5  90.7   0 31.0     11.98       8.02        9.56
#> 6 5.20 9.56 5.12 52.9 374.3 155.3   1 27.7      9.40       7.17        9.05
#>   Homa_beta       Cir  Stumvoll  Xinsdg30  Xinsg30         Di Bigtt_air
#> 1  85.08489 0.3862442  850.5693 0.7847755 4.512225 0.04323715  1161.789
#> 2  84.84603 0.2054480  542.2165 0.3119820 2.252916 0.04498467  1650.537
#> 3 267.63761 0.8485002 1462.1662 1.2082057 9.031530 0.04893109  3477.854
#> 4 133.54626 0.6786166 1196.1813 1.2134723 6.875295 0.05766393  2609.218
#> 5  64.02098 0.2591574  587.8071 0.4459490 3.047768 0.07130919  1734.967
#> 6 103.74624 0.3552093  841.1615 0.6826883 5.604328 0.05052567  2111.044
#>      Dibig
#> 1 13100.08
#> 2 16881.84
#> 3 24216.89
#> 4 24179.56
#> 5 17734.61
#> 6 16087.13
```

Request a single category if you only have fasting values:

``` r

head(insulin_release(example_data, category = "fasting"))
#>     G0  G30 G120   I0   I30  I120 sex  bmi Glucagon0 Glucagon30 Glucagon120
#> 1 5.71 8.39 5.59 56.4 283.5 171.5   0 19.3      3.33       2.58        3.72
#> 2 5.06 8.45 6.31 39.7 153.9 115.1   0 29.4     13.71      10.10        6.92
#> 3 4.59 7.85 6.16 87.5 512.8 257.1   0 26.6      6.28       4.27        4.58
#> 4 5.29 7.72 7.01 71.7 390.1  67.7   1 21.4     11.36       8.71        8.77
#> 5 5.13 8.27 5.78 31.3 182.5  90.7   0 31.0     11.98       8.02        9.56
#> 6 5.20 9.56 5.12 52.9 374.3 155.3   1 27.7      9.40       7.17        9.05
#>   Homa_beta
#> 1  85.08489
#> 2  84.84603
#> 3 267.63761
#> 4 133.54626
#> 5  64.02098
#> 6 103.74624
```

## Glucagon release

``` r

head(glucagon_release(example_data))
#>     G0  G30 G120   I0   I30  I120 sex  bmi Glucagon0 Glucagon30 Glucagon120
#> 1 5.71 8.39 5.59 56.4 283.5 171.5   0 19.3      3.33       2.58        3.72
#> 2 5.06 8.45 6.31 39.7 153.9 115.1   0 29.4     13.71      10.10        6.92
#> 3 4.59 7.85 6.16 87.5 512.8 257.1   0 26.6      6.28       4.27        4.58
#> 4 5.29 7.72 7.01 71.7 390.1  67.7   1 21.4     11.36       8.71        8.77
#> 5 5.13 8.27 5.78 31.3 182.5  90.7   0 31.0     11.98       8.02        9.56
#> 6 5.20 9.56 5.12 52.9 374.3 155.3   1 27.7      9.40       7.17        9.05
#>   Fasting_glucagon Glucagon_auc
#> 1             3.33       372.15
#> 2            13.71      1123.05
#> 3             6.28       556.50
#> 4            11.36      1087.65
#> 5            11.98      1091.10
#> 6             9.40       978.45
```

## Glucagon resistance

``` r

head(glucagon_resistance(example_data))
#>     G0  G30 G120   I0   I30  I120 sex  bmi Glucagon0 Glucagon30 Glucagon120
#> 1 5.71 8.39 5.59 56.4 283.5 171.5   0 19.3      3.33       2.58        3.72
#> 2 5.06 8.45 6.31 39.7 153.9 115.1   0 29.4     13.71      10.10        6.92
#> 3 4.59 7.85 6.16 87.5 512.8 257.1   0 26.6      6.28       4.27        4.58
#> 4 5.29 7.72 7.01 71.7 390.1  67.7   1 21.4     11.36       8.71        8.77
#> 5 5.13 8.27 5.78 31.3 182.5  90.7   0 31.0     11.98       8.02        9.56
#> 6 5.20 9.56 5.12 52.9 374.3 155.3   1 27.7      9.40       7.17        9.05
#>   Glucagon_suppression_ratio Glucagon_insulin_ratio
#> 1                  1.1171171             0.05904255
#> 2                  0.5047411             0.34534005
#> 3                  0.7292994             0.07177143
#> 4                  0.7720070             0.15843794
#> 5                  0.7979967             0.38274760
#> 6                  0.9627660             0.17769376
```

A `Glucagon_suppression_ratio` at or above 1 indicates a failure to
suppress glucagon after the glucose load, a hallmark of hepatic glucagon
resistance.

## Input data

All three functions expect a data frame with a subset of these columns:

| Column | Meaning | Unit |
|----|----|----|
| `G0`, `G30`, `G120` | Glucose at 0/30/120 min | mmol/L |
| `I0`, `I30`, `I120` | Insulin at 0/30/120 min | pmol/L |
| `sex` | Male indicator | 1 = male, otherwise female |
| `bmi` | Body mass index | kg/m^2 |
| `Glucagon0`, `Glucagon30`, `Glucagon120` | Glucagon at 0/30/120 min | pmol/L |

If a column required for a given index is missing, that index is skipped
with a warning rather than the whole function failing, so you can still
compute whichever indices your data supports.

## Further reading

This vignette is a quick start. The package website hosts fuller
articles with the exact formulas, unit conventions, biological
interpretation and references:

- [Insulin release indices: formulas and
  interpretation](https://sufyansuleman.github.io/IsletCalc/articles/insulin-release-indices.html)
- [Glucagon and the liver-alpha-cell
  axis](https://sufyansuleman.github.io/IsletCalc/articles/glucagon-liver-alpha-cell-axis.html)
