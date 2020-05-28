---
name: Data Accuracy
about: Errors in raw or interim data which need to be checked
title: '[Data Accuracy] [ISSUE TITLE]'
labels: 'Data Accuracy :microscope:'
---

<!--- Provide a general summary of the issue in the Title above -->

## Data / Results
<!--- Show us what data you saw or issue you see -->
<!--- Copy/pasting a screenshot is fine to do here -->

## How'd You Find this Issue
<!--- Select which of the below reflects how you found  -->
- [ ] spot check (eg randomly reviewed X rows from a dataset)
- [ ] Fan out detection (eg number of rows increased somewhere)
- [ ] Assertions / Tests (eg unit tests, formal expectations)
- [ ] Informal Checks (eg added a bit of code to print summary statistic)
- [ ] dbt tests (eg using reporting tables and included tests in dbt)
- [ ] Comparison to alternatives (eg looked at a different report and similar number was wildly different)
- [ ] Visualization (eg histogram had weird and unexpected values)

<!--- Describe what code you ran and/or copy and paste here --->

## Possible Reasons for Error
<!--- Not obligatory, but suggest a fix/reason for the data error and provide how you found it -->

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
