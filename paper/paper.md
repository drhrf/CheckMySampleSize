---
title: "CheckMySampleSize: a Shiny decision-support app for choosing statistically plausible analyses at small N"
tags:
  - R
  - Shiny
  - study design
  - sample size planning
  - feasibility
authors:
  - name: Hercules Rezende Freitas
    orcid: 0000-0003-1584-9157
    affiliation: 1
affiliations:
  - name: Health Informatics Laboratory (LabInfoS), Department of Integrated Medical Sciences, School of Medicine, UERJ, Rio de  Janeiro, Brazil. 
    index: 1
date: 22 December 2025
bibliography: paper.bib
---

# Summary

Study planning often collapses into “pick α = 0.05 and aim for 80% power,” even when the study size is fixed (or constrained) and the design space is wide. This routinely produces fragile analyses: too many groups for the available data, over-parameterized regressions, multiplicity-heavy workflows, and binary models starved of events. *CheckMySampleSize* is a lightweight Shiny application that helps researchers map an *expected total sample size* to analysis choices that are statistically plausible, with language aimed at preventing common planning errors rather than producing a single “magic N”.

The app intentionally does **not** compute achieved power from N. Tools for sample size estimation are already available in R [@pwr] and elsewhere [@faul2007gpower]. Instead, it provides feasibility guidance tied to the structure of the intended analysis (two-group means, multi-group comparisons, paired/repeated designs, binary outcomes, association vs. prediction regression, and correlation). It highlights regime shifts (pilot vs. workable vs. more stable inference), warns about effective sample size when observations are correlated, emphasizes event counts for binary outcomes, and encourages estimation-focused reporting (effect sizes and uncertainty) when tests are inherently fragile.

# Statement of need

Most practical study constraints are logistical: time, recruitment, cost, and measurement burden fix N (or cap it) before statistics enters the room. At that point, “sample size calculation” tools are often used backwards: the user varies assumptions until the number looks acceptable, and then treats the resulting design as justified [@hoenig2001abuse]. This is particularly risky for multi-group studies, covariate-heavy regressions, prediction modelling with tuning, and analyses involving many outcomes or subgroup splits—settings where underpowered designs can still generate “significant” but unstable findings.

*CheckMySampleSize* addresses this gap by acting as a design sanity-checker and teaching aid. It helps users (i) choose an analysis goal consistent with their realistic N, (ii) understand the tradeoffs introduced by groups, parameters, and multiplicity, and (iii) avoid self-inconsistencies (e.g., selecting a two-group comparison while setting k ≠ 2). The output is intentionally narrative and decision-oriented: it points to robust alternatives (simpler models, planned contrasts, regularization, resampling, estimation-first reporting) rather than offering a single binary “adequate/inadequate” verdict.

# Implementation

The application is implemented in R [@R] using Shiny [@shiny] and is distributed as open-source code under an OSI-approved license. The user interface combines a compact sidebar of planning inputs (expected N, primary analysis goal, group count where applicable, α and target power preferences, and a robustness toggle) with a main panel that generates a study-question prompt, feasibility guidance, and a design summary.

Input validation is enforced so users cannot generate logically inconsistent settings. For example, the group count is automatically constrained to exactly two when the primary goal is a two-group mean comparison, and constrained to k ≥ 3 for an ANOVA-type goal. In addition, the app prevents k from exceeding N and adjusts minimum N where the chosen goal would otherwise be undefined (e.g., multi-group comparisons with too few total observations).

An “alpha and power” illustration panel provides a visual interpretation of α, β, and power using a two-sided Z-test with unit variance. The illustration chooses a distribution shift Δ so that the shaded power matches the user’s selected target power at the selected α; Δ is explicitly not derived from N, preventing the plot from being misread as an achieved-power computation.

# Use cases

*CheckMySampleSize* is designed for early-stage protocol planning, teaching (introductory biostatistics and study design), and fast feasibility conversations in clinical or laboratory settings. Typical scenarios include deciding whether a multi-group design should be simplified into planned contrasts, whether a regression model needs to reduce predictors or avoid interaction fishing, whether binary-outcome modelling is plausible given expected event rates, and whether prediction claims should be postponed until larger datasets or external validation are available.

# Availability

The source repository is archived and publicly available at: <https://github.com/drhrf/CheckMySampleSize>.\
A hosted instance is available at: <https://drhrf.shinyapps.io/CheckMySampleSize/>.

To meet reproducibility expectations for web software, the application can be run locally from the repository in an R environment with Shiny installed (the hosted instance is provided for convenience only).

# Acknowledgements

The author thanks colleagues and students who provided feedback during iterative development of the feasibility text and UI, and acknowledges the R and Shiny open-source communities that make lightweight scientific tooling practical.

# References
