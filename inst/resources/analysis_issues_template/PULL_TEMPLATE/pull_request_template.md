## Reviewee Checklist

<!-- This is before you send to your reviewer. You should invest in getting these completed before asking for someone to look at your work. -->

<!-- Note that some of these are needed in different parts of the project -->

- [ ] Did you source all your files before pushing from start to finish (ie knit Rmd) without errors?
- [ ] Did you make sure that your code is portable (eg did you replace absolute path references vs relative path references)?
- [ ] Did you run some _basic_ assertions (eg joins dont increase rows accidentally)?
- [ ] Did you flag anywhere that you need or want help for the reviewer?
<!-- - [ ] Did you run `styler` on your files to clean things up before pushing? -->
<!-- - [ ] Did you add visualizations/results that demonstrate your approach / explorations? -->
- [ ] Did you provide the **why** of your code, not just this the **how/what**?
- [ ] Did you update your project README or other documentation to help your reviewer?
- [ ] ** Could you return to this 6 months from now and know what's going on and agree with choices you've made? **

### Reviewee Preferences
<!-- Describe preferences for code review, if any -->
- [ ] Prefer Issues
- [ ] Prefer In-Line Commenting
<!-- To provide in-line commenting guides -->

## Revieweer Checklist

<!-- This is before you do any comprehensive review. You should check to see if these high level expectations are met before investing too much time. If not, talk to reviewee. -->

- [ ] Do I have the data I need to run the code?
- [ ] Can you run all files locally?
- [ ] Is the nature of the review clear to me? What am I being asked to review?
- [ ] Do the assertions (informal or formal) look sufficient based on the description of the PR?
- [ ] Are assumptions laid out and clear? Are assumptions missing or need to be reconsidered?
- [ ] Is the story and intent of the work clear to me? Is the audience clear?
- [ ] Are all quantitative summaries of the data reproducible (eg if I run regression, are my coefficients same as whats in the output from the reviewee)?

## Description

<!-- Bullets about the work product at the time of this PR -->

## Self-Checks

<!-- Bullets describing the self-checks you've done (visualizations, assertions, etc.) -->

### Content/Requests for Review

<!-- File names that need reviewing and what you want the reviewer to check -->

### Reasoning and Assumptions

<!-- Any reasoning or assumptions the reviewer should note -->

## Outputs

<!-- Optional place to put outputs that may not be visible in the code (eg powerpoints) -->

## Environment

<!--- copy and paste results from the r chunk below --->

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
