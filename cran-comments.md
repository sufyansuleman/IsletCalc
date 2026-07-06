## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new release.

* checking CRAN incoming feasibility ... NOTE
  New submission

* checking for future file timestamps ... NOTE
  unable to verify current time

  This is an environment/network limitation of the local check machine
  (no reachable time server), not an issue with the package.

## Test environments

* Local: Windows 11, R 4.4.0
* GitHub Actions: ubuntu-latest, windows-latest, macos-latest (R release)

## Notes for CRAN

* The package has no hard dependencies beyond base R; `knitr`, `rmarkdown`,
  `spelling` and `testthat` are used only for the vignette and tests.
* Formulae for the beta-cell insulin-release indices follow
  Madsen et al. (2024) <doi:10.1038/s42255-024-01140-6>; the DOI is cited
  in the DESCRIPTION Description field.
* All exported functions are documented with runnable examples and a
  documented return value.
