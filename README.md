# Peri-Pancreatic Umbrella
A repository for the Bayesian design of a Peri-Operative Pancreatic Cancer Umbrella study

Here we provide:

1. R code for a simulation study to justify the sample size calulation (Design/periPanc.ss.R)
2. Details of the intended Bayesian analytical approach (Analysis/periPanc.anal.R)


Here we also include a proposes statistical analysis plan to detail the design and analysis of the study

## Peri-Pan Statistical Analysis Plan

###  Design 
The proposed study is aA Phase 2 umbrella platform study using 3 enriched cohorts to evaluate the impact of experimental treatments over the standard of care (SoC). 
 
### Setting 
The clinical trial will be performed in tertiary hospital setting in UK and Australia. 
 
### Target Population 
Patients with (borderline) resectable pancreatic ductal adenocarcinomaPDAC suitable for neo-adjuvant chemotherapy and considered fit for neoadjuvant combination chemotherapy and subsequent surgery (PS 0-1). 

### Follow up 
Patients will be followed up for up for a minimum ofto 2 years after registration. 
 
### Primary endpoint 
Disease Control Rate (DCR) defined as patients who achieve either a stable disease, partial response or complete response at 16 weeks (end of neoadjuvant treatment) based on RECIST 1.1 criteria. 
 
### Secondary endpoint 
* Objective Response Rate (ORR) defined as patients who achieve either a partial response or complete response at 16 weeks (end of neoadjuvant treatment) based on RECIST 1.1 criteria. 
* Progression- fFree Survival: measured as the time from registration until disease progression or death by any cause. 
* Overall Survival: measured as the time from registration until death by any cause. 
* Toxicity: measured as the occurrence of Adverse Events (AEs) and Serious Adverse Events (SAEs) over the course of the study. 
* Quality of life will be assessed with the EORTC Quality of Life Questionnaire. 
* R0 resection rate 
* Post-operative complications. 
 

### Study Design 

The study is designed as an umbrella study evaluating each of the interventions as a randomised comparison within each cohort and allowing for Bayesian borrowing of information between the control arms in each cohort.  The three individual cohorts are 

* Cohort 1: Standard of CareSoC + RMC-6236 Vs Standard of CareSoC (KRAS mutated) 
* Cohort 2: Standard of CareSoC + BMS-986504. Vs Standard of CareSoC (MTAP deleted) 
* Cohort 3: Standard of CareSoC + AZD0901 Vs Standard of CareSoC (CLDN18.2 over expressing) 

IUpon presentation, it is anticipated that ~c95% of patients will be eligible for cohort 1, ~c25% will be eligible for cohort 2 and ~c50% will be eligible for Cohort 3. 

### Cohort Allocation 

Patients will be randomised using a 2:1 ratio to experimental:control (Soc). For those randomised to receive an experimental intervention wWhilst it is not assumed a-priori that cohort suitability will be mutually exclusive (i.e. patients may be eligible for multiple cohorts) given the imbalance in anticipated prevalence patients will be allocated on the following basis (i.e. those randomised to receive intervention): 

1. Patients eligible for cohort 1 but not eligible for cohorts 2 or 3 will be allocated to cohort 1. 
2. Patients eligible for cohort 2 will be allocated to cohort 2 (irrespective of other eligibility). 
3. Patients eligible for cohort 3 but not eligible for cohort 2 will be allocated to cohort 3 
 

### Information Borrowing 
To ensure efficient use of information within the study, we will utilise a Bayesian design using a borrowing of information between the control arms of each study.  Here, provided there is overlap between cohorts (being that the standard of careSoC between cohorts remains consistent) we will allow that information is shared only between the control arms of each cohort.  Here when borrowing information, we will down-weight using a factor of 0.5. 

### Randomisation: 
Patients will be randomised on a 2:1 basis with a greater number of patients allocated to the experimental regimen in each cohort.   Patients will be stratified based on site (25 levels) and resctable Vs borderline status (2 levels).  Randomisation will be performed using pre generated lists produces on the principle of randomly permuted blocks with random block sizes of 2 and 4.

### Sample Size
Given the Bayesian design, sample size calculations are performed using a simulation approach. Using a simulation approach also allows for multiple sources of variability to be accounted for (e.g in the unknown prevalence rates for each cohort).  Datasets are simulated for each cohort.  The primary outcome of disease control rate is simulated to have a response ofbe 70% and a clinically relevant difference of 17.5%. 

Using direct analyses (which ignore information from other cohorts) gives an estimated Power of 63% 76% and 74% for each Cohort respectively. 

A sample size of 250 is set.  On average over a 2 year recruitment period, we envisage an average of 63 patients in Cohort 1 and 93 in each of Cohorts 2 and 3.  The efficacy parameter of interest is the odds ratio which is measured alongside credibility intervals.  An experimental treatment is considered efficacious if >90% of the posterior distribution is >1, warranting investigation in a future Phase III (if safety considered appropriate).  We set the sample size on the probability of meeting this threshold where a true treatment effect exists (analogous to Power estimates).   Using direct analyses (which ignore information from other cohorts) gives an estimated Power of 63% 76% and 74% for each Cohort respectively.  Allowing for the borrowing of information gives estimates of 80%, 88% and 89% respectively. 

 

### Analysis Methodology 

**Patient Groups:** Analysis will be undertaken following the treatment policy approach to defining the study estimand. Here all inter-current events will be ignored and patients retained in the treatment groups to which they are assigned. 

**Levels of Significance:**  TFor the primary outcome, the primary outcome (Odds Ratio) will be reported alongside a one-sided 90% credibility interval (as is consistent with the sample size calculation). All other outcomes will be reported alongside nominal two-sided 95% intervals.  

**Primary Outcome Analysis:** Primary analysis will be performed using Bayesian estimation techniques.  Here Tthe outcome will be defined to follow a binomial distribution.  A logit link will be used which will ensure that the primary efficacy parameters is expressed as a (log) odds ratio.  Separate likelihoods will be applied for each country and standard of careSoC regimen to account for the study stratification factors.  Prior distributions are required for both the rate of response in the control arm and the log odds ratio between arms.   Prior distributions for the control response rate are developed by borrowing the information from the control arms of alternative cohorts and inflating the variance by a factor of 2.  Vague uninformative priors are set for the efficacy parameter of interest.  Analyses are planned using Bugs routines with code included in the github repository for reference. 

**Secondary Outcome Analysis:**
Secondary endpoints will follow the same principle as that for the primary outcome which allow for the borrowing of information between treatment arms.  For outcomes with a binary outcome equivalent procedures will be run as for the primary outcome.  Quality of Life will be analysed using an equivalent approach adapted for continuous data outcomes.  Survival outcomes will require a parametric form for the underlying cumulative hazard function to enable information borrowing.  Toxicity will be defined based on the Common Toxicity Criteria for Adverse Events (CTCAE) Version 4 with the number of grade 3+ AEs compared between treatment groups.   

