# Glucagon and the liver-alpha-cell axis

Where the beta cell secretes insulin, the pancreatic **alpha cell**
secretes **glucagon**.
[`glucagon_release()`](https://sufyansuleman.github.io/IsletCalc/reference/glucagon_release.md)
and
[`glucagon_resistance()`](https://sufyansuleman.github.io/IsletCalc/reference/glucagon_resistance.md)
summarize alpha-cell output and its regulation from fasting and OGTT
glucagon values. This article explains the biology those indices are
meant to capture.

## The liver-alpha-cell axis

Glucagon and hepatic amino-acid metabolism form a feedback loop known as
the **liver-alpha-cell axis**. Circulating amino acids stimulate
glucagon secretion and alpha-cell proliferation; glucagon, in turn,
drives hepatic amino-acid catabolism and ureagenesis. In health, an oral
glucose load **suppresses** glucagon, limiting hepatic glucose output.

**Glucagon resistance** describes a breakdown of this loop, seen with
hepatic steatosis and type 2 diabetes: the liver responds less to
glucagon, amino acids and glucagon both rise (hyperglucagonaemia), and
glucose fails to suppress glucagon normally. Non-suppression of glucagon
after glucose is a recognized early feature of dysglycaemia.

## Indices

### Glucagon release (`glucagon_release()`)

| Index | Definition | Meaning |
|----|----|----|
| `Fasting_glucagon` | `Glucagon0` | Basal alpha-cell tone; elevated in glucagon resistance. |
| `Glucagon_auc` | trapezoidal AUC over 0, 30, 120 min | Total glucagon exposure during the OGTT. |

The area under the curve uses the trapezoidal rule:
`0.5 x ((Glucagon30 + Glucagon0) x 30 + (Glucagon120 + Glucagon30) x 90)`.

### Glucagon resistance (`glucagon_resistance()`)

| Index | Definition | Meaning |
|----|----|----|
| `Glucagon_suppression_ratio` | `Glucagon120 / Glucagon0` | Below 1 = normal suppression after glucose; at or above 1 = failed suppression, a signature of glucagon resistance. |
| `Glucagon_insulin_ratio` | `Glucagon0 / I0` | Fasting alpha-to-beta balance; tracks whole-body insulin sensitivity and beta-cell function. |

For both ratios, glucagon and insulin should be supplied in a consistent
molar unit (for example pmol/L).

## Worked example

``` r

data(example_data)
res <- glucagon_release(example_data)
res <- glucagon_resistance(res)
round(head(res[, c("Fasting_glucagon", "Glucagon_auc",
                   "Glucagon_suppression_ratio",
                   "Glucagon_insulin_ratio")], 5), 3)
#>   Fasting_glucagon Glucagon_auc Glucagon_suppression_ratio
#> 1             3.33       372.15                      1.117
#> 2            13.71      1123.05                      0.505
#> 3             6.28       556.50                      0.729
#> 4            11.36      1087.65                      0.772
#> 5            11.98      1091.10                      0.798
#>   Glucagon_insulin_ratio
#> 1                  0.059
#> 2                  0.345
#> 3                  0.072
#> 4                  0.158
#> 5                  0.383
```

Rows with `Glucagon_suppression_ratio` at or above 1 are the ones that
failed to suppress glucagon after the glucose load.

## References

- Chen X, Maldonado E, DeFronzo RA, Tripathy D (2021). Impaired
  Suppression of Glucagon in Obese Subjects Parallels Decline in Insulin
  Sensitivity and Beta-Cell Function. *J Clin Endocrinol Metab*, 106(5),
  1398-1409. <https://doi.org/10.1210/clinem/dgab019>
- Wewer Albrechtsen NJ, et al. (2018). Evidence of a liver-alpha cell
  axis in humans: hepatic insulin resistance attenuates relationship
  between fasting plasma glucagon and glucagonotropic amino acids.
  *Diabetologia*, 61(3), 671-680.
  <https://doi.org/10.1007/s00125-017-4535-5>
- Suppli MP, et al. (2020). Glucagon Resistance at the Level of Amino
  Acid Turnover in Obese Subjects With Hepatic Steatosis. *Diabetes*,
  69(6), 1090-1099. <https://doi.org/10.2337/db19-0715>
