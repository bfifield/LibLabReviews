---
name: Results Accuracy
about: Problems or unexpected outcomes in the results from analyses
title: '[Results Accuracy] [ISSUE TITLE]'
labels: 'Results Accuracy :telescope:'
---

<!--- Provide a general summary of the issue in the Title above -->

## Data / Results
<!--- Show us what data you saw or issue you see -->
<!--- Copy/pasting a screenshot is fine to do here -->

## How'd You Find this Issue
<!--- Select which of the below reflects how you found  -->
- [ ] Spot check (eg randomly reviewed X results from run and prediction didnt make logical sense)
- [ ] Diagnostic plots or tests (eg QQ plot, ROC curves, etc)
- [ ] Review of components of approach (eg looked at single tree within a random forest, randomly sorted the data before running and got wildly different results, etc.)
- [ ] Assertions / Tests (eg unit tests, formal expectations)
- [ ] Informal Checks (eg added a bit of code to print summary statistic)
- [ ] Comparison to alternatives (eg looked at a different report and similar number was wildly different)

<!--- Describe what code you ran and/or copy and paste here --->

## Possible Reasons for Error
<!--- Not obligatory, but suggest a fix/reason for the results error and provide how you found it -->

## Solutions
<!--- if you have a known way to fix this, provide it of course --->

## Possible Regression Prevention Measures
<!--- even if you dont know how to fix, writing up an assertion or unit test the person could use make sure this doesn't reappear is helpful --->

## Context (Environment)
<!--- copy and paste results from the r chunk below if doing from within Github Issues --->

<details><summary>Reprodicibility Recceipt</summary>

```r
# Datetime
Sys.time()

# Repo
git2r::repository()

# Session Info
sessioninfo::session_info()
```

</details>
