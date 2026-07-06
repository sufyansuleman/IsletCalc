# Simulated OGTT Example Data

A simulated dataset of 50 subjects with fasting and 75 g oral glucose
tolerance test (OGTT) glucose, insulin and glucagon values, for use in
the package examples, vignette and tests. Values are randomly generated
and are not derived from real subjects.

## Usage

``` r
example_data
```

## Format

A data frame with 50 rows and 11 variables:

- G0, G30, G120:

  Glucose (mmol/L) at 0, 30 and 120 min.

- I0, I30, I120:

  Insulin (pmol/L) at 0, 30 and 120 min.

- sex:

  Sex, coded 1 = male, 0 = female.

- bmi:

  Body mass index (kg/m^2).

- Glucagon0, Glucagon30, Glucagon120:

  Glucagon (pmol/L) at 0, 30 and 120 min.

## Source

Simulated; see `data-raw/example_data.R`.
