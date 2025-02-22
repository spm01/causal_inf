library(pacman)
p_load(tidyverse, knitr, ggplot, ggstats, coefplot, haven)

#loading in the data
ohp_data = read_dta("ohp.dta")
 
ohp_data = na.omit(ohp_data)

#treatment: selected in the lottery
#ohp_all_ever_survey: ever enrolled in Medicaid from 1st notif. date

#subset data for control group
ohp_data$treatment = as.numeric(as.character(unclass(ohp_data$treatment)))

grouped_data <- ohp_data %>% 
  group_by(treatment)

control_group <- grouped_data %>% 
  filter(treatment == 0)

treatment_group = grouped_data %>%
  filter(treatment == 1)

treatment_group = na.omit(treatment_group)

control_group = na.omit(control_group)

#find means across groups
average_age = mean(control_group$age_inp)
average_dep_pre = mean(control_group$dep_dx_pre_lottery)
average_edu = mean(control_group$edu_inp)
average_gender = mean(control_group$gender_inp)

#create dataframe for averages
averages_table = data.frame(
  Variable = c("Age", "Depression Diagnosis", "Education", "Gender"),
  Average = c(average_age, average_dep_pre, average_edu, average_gender)
)

#create table
control_averages = kable(averages_table, align = 'c', caption = "Averages of Specific Variables in Control Group")

print(control_averages)

#finding differnce in means
#age, pre lottery depression, education, gender
age_regr <- lm(age_inp ~ treatment, data = ohp_data)
coeff_age_regr = age_regr$coefficients
summary_age_regr = summary(age_regr)
std_age_regr = summary_age_regr$coef[, "Std. Error"]

dep_regr = lm(dep_dx_pre_lottery ~ treatment, data = ohp_data)
coeff_dep_regr = dep_regr$coefficients
summary_dep_regr = summary(dep_regr)
std_dep_regr = summary_dep_regr$coef[, "Std. Error"]

edu_regr = lm(edu_inp ~ treatment, data = ohp_data)
coeff_edu_regr = edu_regr$coefficients
summary_edu_regr = summary(edu_regr)
std_edu_regr = summary_edu_regr$coef[, "Std. Error"]

#insert average gender regression here!!
gend_regr = lm(gender_inp ~ treatment, data = ohp_data)
coeff_gend_regr = gend_regr$coefficients
summary_gend_regr = summary(gend_regr)
std_gend_regr = summary_gend_regr$coef[, "Std. Error"]

#create new table w/coefficients

#defining coefficient values
coef_age = coeff_age_regr[2]
coef_depr_pre = coeff_dep_regr[2]
coef_edu = coeff_edu_regr[2]
coef_gender = coeff_gend_regr[2]

#averages_coef_table
averages_coef_table = data.frame(
  Variable = c("Age", "Prior Depression", "Education Level", "Gender"),
  Average = c(average_age, average_dep_pre, average_edu, average_gender),
  Coefficiencts = c(coef_age, coef_depr_pre, coef_edu, coef_gender)
)

#create new table w/standard errors
#define standard error values
std_age = std_age_regr[2]
std_dep = std_dep_regr[2]
std_edu = std_edu_regr[2]
std_gend = std_gend_regr[2]

#averages_coef_std_table
averages_coef_std_table = data.frame(
  Variable = c("Age", "Prior Depression", "Education Level", "Gender"),
  Average = c(average_age, average_dep_pre, average_edu, average_gender),
  Coefficiencts = c(coef_age, coef_depr_pre, coef_edu, coef_gender),
  StandardErrors = c(std_age, std_dep, std_edu, std_gend)
)

#estimate compliance rate for OHP experiment
compli_regr = lm(ohp_all_ever_survey ~ treatment, data = ohp_data)
summary_compli_regr = summary(compli_regr)
compli_rate = summary_compli_regr$coefficients["treatment", "Estimate"]
print(compli_rate)


#estimate ITT regression: pick post lottery variables for analysis
#variables include: cholesterol, depression post/lot, diabetes post/lot, number doc visits

chl_regr = lm(chl_inp ~ treatment, data = ohp_data)
dep2_regr = lm(dep_dx_post_lottery ~ treatment, data = ohp_data)
dia_regr = lm(dia_dx_post_lottery ~ treatment, data = ohp_data)
doc_regr = lm(doc_num_mod_inp ~ treatment, data = ohp_data)

#grab coefficient estimates from regressions
#cholesterol estimates
coeff_chl_regr = chl_regr$coefficients[1]
summary_chl_regr = summary(chl_regr)
std_chl_regr = summary_chl_regr$coef[, "Std. Error"]

#depression estimates
coeff_dep2_regr = dep2_regr$coefficients[1]
summary_dep2_regr = summary(dep2_regr)
std_dep2_regr = summary_dep2_regr$coef[, "Std. Error"]

#diabetes estimates
coeff_dia_regr = dia_regr$coefficients[1]
summary_dia_regr = summary(dia_regr)
std_dia_regr = summary_dia_regr$coef[, "Std. Error"]

#doctor visits estimates
coeff_doc_regr = doc_regr$coefficients[1]
summary_doc_regr = summary(doc_regr)
std_doc_regr = summary_doc_regr$coef[, "Std. Error"]

#create table for regression estimates

itt_regr_table = data.frame(
  Variable = c("Cholesterol", "Depression Diagnosis", "Diabetes Diagnosis", "Number of Doctor Visits"),
  Coefficients = c(coeff_chl_regr, coeff_dep2_regr, coeff_dia_regr, coeff_doc_regr),
  StandardErrors = c(std_chl_regr, std_dep2_regr, std_dia_regr, std_doc_regr)
)
print(itt_regr_table)

#graph w/estimates + std errors
plot1 = ggcoef_compare(list("chl_regr" = chl_regr, "dep2_regr" = dep2_regr, "dia_regr" = dia_regr, "doc_regr" = doc_regr))

#treatment on the treated effect (ATET)
#ATET = ITT / effect of winning lottery
itt_chl = coeff_chl_regr/compli_rate
itt_dep2 = coeff_dep2_regr/compli_rate
itt_dia = coeff_dia_regr/compli_rate
itt_doc = coeff_doc_regr/compli_rate

#create new data frame --> new table
atet_effect_table = data.frame(
  Variable = c("Cholesterol", "Depression Diagnosis", "Diabetes Diagnosis", "Number of Doctors Visits"),
  ATET_Effect = c(itt_chl, itt_dep2, itt_dia, itt_doc)
)




