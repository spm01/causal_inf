![phone_guy](https://github.com/user-attachments/assets/2a9cea56-2a61-4ecc-a4be-5be376b48443)

This is a research project for my independent research class in Spring2025. 
Class is taught / performed / executed in 100% Standard Taiwanese Mandarin. 

This project is aimed at analysing self-reported health habits on self-evaluated overall health status.
I designed a small questionnaire that inquired about daily average phone screen time, weekly average workout time, daily average sleep duration, and daily caloric intake.
Data was collected in binned groups based on assumed habits IE <4hrs sleep time per night with scaled values binned up to 9+ hrs per night. 
These values are self-reported from ~40 volunteer classmate and teacher participants in the survey.

Our initial approach to collecting binned values made it easily accessible for participants, but increased the difficulty of the data processing/packaging steps in analysis.
I converted all binned values to scale based on the number of options available IE <4hrs, 4-5, 5-6, 6-7, 7-8, 8-9, 9+hrs was transformed into scaled values of 1,2,3,4,5,6, respectively.
I also normalized all data before running any regressions.

A wide breadth of data allowed for decent graphical analysis where I used Matplotlib for the first time. Most people reported their health status as above average, with health status >6 on scale 1-10.

Initial analysis indicated potential relationships between observations and self-evaluated health status based on correlation values.
However, using (parametric) multiple linear regression, I found no strong relationship between any variables and the self-evaluated health status.
The exception to this was workout_time, which had a positive impact on self-percieved health status with p-value = 0.003.

My second regression utilized interaction terms (phone_time * sleep_time + phone_time * workout_time), but failed to cross any statistically significant threshold.
Including interaction terms in the regression also greatly increased the p-value of workout_time from the prior regression from 0.003 to 0.710.

Based on these analyses, the true relationship between my queries and self-percieved health time is likely negligible. 

If I was to do this research again, I would include a question on body-weight. Body-weight in particular is often associated with health, or at minimum, self-perceived healthiness.
The inclusion of this into my analysis would be another useful tool for later regression.

Additionally, from a convenience perspective, I would allow individuals to input numeric values directly into the questionnaire instead of binned values.
This would save me time on the back end for data processing.
Binned values also create a form of data censoring making it more difficult to analyze underlying relationships. 
I had previously viewed documentation on "censored regression" where binned values are split into 2 sections, lower-bound and upper-bound.
This would also be a useful technique for more rigorous applications of similar data.

All raw data is available in the associated .csv file.
