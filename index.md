# IsletCalc

IsletCalc computes surrogate indices of pancreatic **islet hormone
release** from fasting and 75 g oral glucose tolerance test (OGTT)
measurements. It covers both **beta-cell** (insulin) and **alpha-cell**
(glucagon) function in one lightweight, dependency-free package.

## Installation

``` r

# development version:
# install.packages("remotes")
remotes::install_github("sufyansuleman/IsletCalc")
```

## Functions

| Function | Cell | Indices |
|----|----|----|
| [`insulin_release()`](https://sufyansuleman.github.io/IsletCalc/reference/insulin_release.md) | beta | HOMA-beta, CIR, Stumvoll, insulinogenic (Xinsdg30, Xinsg30), BIGTT-AIR, disposition (Di, Dibig) |
| [`glucagon_release()`](https://sufyansuleman.github.io/IsletCalc/reference/glucagon_release.md) | alpha | fasting glucagon, glucagon AUC |
| [`glucagon_resistance()`](https://sufyansuleman.github.io/IsletCalc/reference/glucagon_resistance.md) | alpha | glucagon suppression ratio, fasting glucagon:insulin ratio |

Beta-cell formulas follow Madsen et al. (2024, *Nature Metabolism*,
[doi:10.1038/s42255-024-01140-6](https://doi.org/10.1038/s42255-024-01140-6)).

## Example

``` r

library(IsletCalc)
data(example_data)

# beta-cell insulin release
res <- insulin_release(example_data, category = c("fasting", "ogtt"))
head(res[, c("Homa_beta", "Cir", "Bigtt_air", "Di")], 3)
#>   Homa_beta       Cir Bigtt_air         Di
#> 1  85.08489 0.3862442  1161.789 0.04323715
#> 2  84.84603 0.2054480  1650.537 0.04498467
#> 3 267.63761 0.8485002  3477.854 0.04893109

# alpha-cell glucagon release and resistance
res <- glucagon_release(example_data)
res <- glucagon_resistance(res)
head(res[, c("Fasting_glucagon", "Glucagon_auc",
             "Glucagon_suppression_ratio")], 3)
#>   Fasting_glucagon Glucagon_auc Glucagon_suppression_ratio
#> 1             3.33       372.15                  1.1171171
#> 2            13.71      1123.05                  0.5047411
#> 3             6.28       556.50                  0.7292994
```

A `Glucagon_suppression_ratio` at or above 1 indicates a failure to
suppress glucagon after the glucose load, a hallmark of hepatic glucagon
resistance.

## Input data

| Column | Meaning | Unit |
|----|----|----|
| `G0`, `G30`, `G120` | Glucose at 0/30/120 min | mmol/L |
| `I0`, `I30`, `I120` | Insulin at 0/30/120 min | pmol/L |
| `sex` | Male indicator | 1 = male, else female |
| `bmi` | Body mass index | kg/m^2 |
| `Glucagon0`, `Glucagon30`, `Glucagon120` | Glucagon at 0/30/120 min | pmol/L |

Only the columns required for a requested index need be present; a
missing column skips that index with a warning rather than failing the
whole call.

## Citation

``` r

citation("IsletCalc")
```

## Related package

For insulin **sensitivity** indices (as opposed to release), see
[InsuSensCalc](https://github.com/sufyansuleman/InsuSensCalc).
