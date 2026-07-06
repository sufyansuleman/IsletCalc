# Insulin release indices: formulas and interpretation

[`insulin_release()`](https://sufyansuleman.github.io/IsletCalc/reference/insulin_release.md)
computes eight surrogate indices of beta-cell insulin secretion from
fasting and 75 g oral glucose tolerance test (OGTT) data. This article
gives the exact formula, units and interpretation of each, and the
references they come from.

## Units and conversions

The source formulae mix conventional and SI units, so
[`insulin_release()`](https://sufyansuleman.github.io/IsletCalc/reference/insulin_release.md)
converts internally before applying each equation:

| Quantity | Input unit | Converted to | Factor |
|----|----|----|----|
| Glucose (`G0`, `G30`, `G120`) | mmol/L | mg/dL | `x 18` |
| Insulin (`I0`, `I30`, `I120`) | pmol/L | microU/mL | `x 0.1667` (that is, `/ 6`) |

`sex` enters the BIGTT equations as a male indicator (male = 1,
otherwise female), and `bmi` is in kg/m^2. The subscripts 0, 30 and 120
denote minutes after the glucose load.

## Fasting index

| Index       | Formula (converted units)   | Reference     |
|-------------|-----------------------------|---------------|
| `Homa_beta` | `(20 x I0_uU) / (G0 - 3.5)` | Matthews 1985 |

**HOMA-beta** estimates steady-state basal beta-cell function. Higher
values mean greater fasting insulin output; markedly high values often
reflect compensatory hypersecretion in the face of insulin resistance,
while low values suggest beta-cell insufficiency. It is undefined as
`G0` approaches 3.5 mmol/L.

## OGTT indices

| Index | Formula (converted units) | Reference |
|----|----|----|
| `Cir` | `(100 x I30_uU) / (G30_mg x (G30_mg - 70))` | Sluiter 1976 |
| `Stumvoll` | `1283 + 1.829 x I30 - 138.7 x G30 + 3.772 x I0` (pmol/L, mmol/L) | Stumvoll 2000 |
| `Xinsdg30` | `((I30 - I0)_uU) / ((G30 - G0)_mg)` | insulinogenic index |
| `Xinsg30` | `((I30 - I0)_uU) / G30` (mmol/L) | insulinogenic index |
| `Di` | `Xinsg30 x 1000 / (sqrt(G0_mg x I0_uU) x meanG_mg x meanI_uU)` | Madsen 2024 (see note) |
| `Bigtt_air` | `exp(8.20 + 0.00178 I0 + 0.00168 I30 - 0.000383 I120 - 0.314 G0 - 0.109 G30 + 0.0781 G120 + 0.180 sex + 0.032 bmi)` | Hansen 2007 |
| `Dibig` | `Bigtt_air x exp(4.90 - 0.00402 I0 - 0.000556 I30 - 0.00127 I120 - 0.152 G0 - 0.00871 G30 - 0.0373 G120 - 0.145 sex - 0.0376 bmi)` | Madsen 2024 |

where `meanG` and `meanI` are the row means of glucose and insulin
across 0, 30 and 120 min.

**Interpretation.**

- **`Cir`** (corrected insulin response) and the **insulinogenic
  indices** (`Xinsdg30`, `Xinsg30`) capture the early-phase insulin
  response to glucose; higher is greater early secretion.
- **`Stumvoll`** and **`Bigtt_air`** estimate first-phase / acute
  insulin release; higher means a larger burst.
- **`Di`** and **`Dibig`** are disposition indices: insulin secretion
  scaled by insulin sensitivity. Because a healthy beta cell secretes
  more when the body is more resistant, the disposition index is the key
  measure of whether secretion is *adequate for the prevailing
  sensitivity*. Lower values indicate beta-cell failure to compensate
  and are a strong predictor of progression to type 2 diabetes.

### Note on the `Di` formula

The `Di` equation is transcribed **exactly as reported in the Madsen
(2024) index table**: the square root covers only `G0_mg x I0_uU`, with
the mean terms outside the root and a numerator of 1000. This is not
identical to the canonical Matsuda-based disposition index (a single
square root over all four terms, numerator 10000). We keep the
as-reported form so results reproduce the source exactly; if you need
the Matsuda-standard disposition index, compute it separately.

## Worked example

``` r

data(example_data)
res <- insulin_release(example_data, category = c("fasting", "ogtt"))
round(head(res[, c("Homa_beta", "Cir", "Stumvoll", "Xinsg30",
                   "Di", "Bigtt_air", "Dibig")], 5), 3)
#>   Homa_beta   Cir Stumvoll Xinsg30    Di Bigtt_air    Dibig
#> 1    85.085 0.386  850.569   4.512 0.043  1161.789 13100.08
#> 2    84.846 0.205  542.216   2.253 0.045  1650.537 16881.84
#> 3   267.638 0.849 1462.166   9.032 0.049  3477.854 24216.88
#> 4   133.546 0.679 1196.181   6.875 0.058  2609.218 24179.56
#> 5    64.021 0.259  587.807   3.048 0.071  1734.967 17734.61
```

## References

- Madsen AL, et al. (2024). Genetic architecture of oral
  glucose-stimulated insulin release provides biological insights into
  type 2 diabetes aetiology. *Nature Metabolism*.
  <https://doi.org/10.1038/s42255-024-01140-6>
- Matthews DR, et al. (1985). Homeostasis model assessment: insulin
  resistance and beta-cell function from fasting plasma glucose and
  insulin concentrations in man. *Diabetologia*, 28(7), 412-419.
  <https://doi.org/10.1007/BF00280883>
- Sluiter WJ, et al. (1976). Glucose tolerance and insulin release, a
  mathematical approach. *Diabetes*, 25(4).
  <https://doi.org/10.2337/diab.25.4.241>
- Stumvoll M, et al. (2000). Use of the oral glucose tolerance test to
  assess insulin release and insulin sensitivity. *Diabetes Care*,
  23(3), 295-301. <https://doi.org/10.2337/diacare.23.3.295>
- Matsuda M, DeFronzo RA (1999). Insulin sensitivity indices obtained
  from oral glucose tolerance testing. *Diabetes Care*, 22(9),
  1462-1470. <https://doi.org/10.2337/diacare.22.9.1462>
- Hansen T, et al. (2007). The BIGTT test: a novel test for simultaneous
  measurement of pancreatic beta-cell function, insulin sensitivity, and
  glucose tolerance. *Diabetes Care*, 30(2), 257-262.
  <https://doi.org/10.2337/dc06-1240>
