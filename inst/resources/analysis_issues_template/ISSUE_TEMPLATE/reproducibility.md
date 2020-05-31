---
name: Reproducibility
about: The reviewer is struggling to reproduce core parts of the analysis
title: '[Reproducibility] [ISSUE TITLE]'
labels: 'Reproducibility :ledger:'
---

<!--- Provide a general summary of the issue in the Title above -->

## Reproduction Problem
<!--- Write quickly up where you were unable to run analyses provided -->


## Reproducibility Checklist
<!--- Highlight any or all of the following that may be issues -->
- [ ] Unable to "source" (eg can't knit a markdown without errors)
- [ ] "data" dependency missing (eg analysis sources a local dataset the reviewer doesnt have)
- [ ] code dependency missing (eg analysis uses a function that is not part of the library and not in a clearly defined library)
- [ ] Order of operations is unclear (eg don't know which files to source in which order)
- [ ] Environment problems (eg version of R or a package a person is using could be causing issues)
- [ ] Outputs not in line with descriptions (eg person comments out a number of rows and it differs from what you see when running the equivalent code)

## Needed Changes or Information to Fix
<!--- Put suggested fix here and/or what reviewer needs to move forward  -->

## Regression Fixes
<!--- Put suggestions for ways to avoid the reproduction problem in the future  -->

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
