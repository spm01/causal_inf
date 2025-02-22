A brief analysis of the Oregon Health Plan's natural experiment. PDF file has pretty formatting!

This project conducts an analysis of data from an experiment related to the Oregon Health Plan (OHP) that occurred in 2009. I start by assigning the data into treatment and control groups based on a binary treatment indicator variable.

First, I calculate the means of specific variables in the control group, including age, prior depression diagnosis, education level, and gender. I do this to ensure valid randomization and external validity for further study.

Next, I estimate the compliance rate for the OHP experiment using linear regression, with the outcome variable being enrollment in Medicaid (ohp_all_ever_survey). The treatment effect is also estimated using intention-to-treat (ITT) regression for variables including cholesterol levels, depression diagnosis post-lottery, diabetes diagnosis post-lottery, and number of doctor visits.

Finally, I calculate the "treatment on the treated" effect (ATET) by dividing the estimated coefficients from the ITT regressions by the compliance rate, yielding the ATET effect for each variable. These results are organized into a table for further analysis and interpretation.

Based on these results, being randomly assigned healthcare had positive long term health outcomes, as indicated by lower cholesterol levels, lower rates of diabetes and depression, and more frequent doctors visits. These conclusions can easily lend themselves to another discussion surrounding preventative vs. reactionary medicine.

If anyone has any suggestions about my coding, process, or conclusions, feel free to drop me a line!
