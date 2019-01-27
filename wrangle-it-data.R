# Wrangle data. We specifically want to see IT. I am trying to reduce
# the number of unique job titles.
# NOTE: By creating a new data frame for IT, if the data gets corrupted,
# one can rerun this code to recreate it from the employeesdf

library('readr')
library('stringr')
library('plyr')
library('dplyr') # apparently plyr and dplyr don't play well together
                # so there may be another way


### Initial Data Wrangling
# Let's look only at IT for now
ITdf <- subset(employeesdf, grepl(glob2rx("IT*"), Job.Title) ) 

# Remove blanks
ITdf$Job.Title <- str_trim(ITdf$Job.Title)
jobclassdf$Classification_ <- str_trim(jobclassdf$Classification_)

# Replace "Annual" with estimated hourly (2,087)
index <-ITdf$Pay.Basis == 'ANNUAL'
ITdf$Pay.Rate[index] <- ITdf$Pay.Rate[index]/2087

# Sort by Pay.Rate Ascending
ITdf <- ITdf[with(ITdf,order(Pay.Rate)), ]

# Sort Classification_
jobclassdf <- jobclassdf[with(jobclassdf,order(Classification_)), ]

# Data Cleanup



# These are just for viewing the data
str_subset(ITdf$Agency, "INSURANCE")

str_subset(ITdf$Job.Title, "IT OPS & SUPPORT TECHNICIAN")
str_subset(ITdf$Job.Title, "Operations and Support")

# Make Job Title's consistent in Workforce by Name Summary xls-en-us.xlsx
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT OPS & SUPPORT TECHNICIAN", "IT Operations and Support Technician")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT OPS & SUPPORT SR TECHNICIAN", "IT Operations and Support Senior Technician")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT OPS & SUPPORT ANALYST I", "IT Operations and Support Analyst I")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT SOFTWARE ENGINEER I", "IT Software Engineer I")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT SOFTWARE ENGINEER ASSOCIATE", "IT Software Engineer Associate")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT MANAGER", "IT Manager")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT DATABASE ADMIN ANALYST I", "IT Database Administration Analyst I")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT INFO SECURITY ENGINEER I", "IT Information Security Engineer I")
ITdf$Job.Title <- str_replace(ITdf$Job.Title, "IT INFRASTRUCTURE ENGINEER I", "IT Infrastructure Engineer I") 
#  ITdf$Job.Title <- str_replace(ITdf$Job.Title, "", "")
#  ITdf$Job.Title <- str_replace(ITdf$Job.Title, "", "")
#  ITdf$Job.Title <- str_replace(ITdf$Job.Title, "", "")

# Add Classification_ by combining dataframes
# Expect a warning about coercing factor into character
ITdf <- left_join(ITdf, jobclassdf, by = "Job.Title")

# How many of each Job Title, sorted by count (so I can cleanup)
ITJobTitleCount <- ddply(ITdf,.(Job.Title),nrow)
ITJobTitleCount <- ITJobTitleCount[with(ITJobTitleCount, order(Job.Title)),]
ITJobTitleCount

# Combine the ITJobTitleCount with ITdf (and rename the results to Job.Title.Count)
# This seems like it is not best practice
ITJobTitleCount <- left_join(ITdf, ITJobTitleCount, by = "Job.Title")

############### PHASE I #########################
# And let's just look at Phase I IT
# TODO: We have to figure out who in Phase I from TAX is included
Tax.ITdf <- subset(ITdf, grepl(glob2rx("TAX COMMISSION, IDAHO STATE"), Agency) )
Finance.ITdf <- subset(ITdf, grepl(glob2rx("FINANCE, DEPARTMENT OF"), Agency) )
Building.Safety.ITdf <- subset(ITdf, grepl(glob2rx("BUILDING SAFETY, DIVISION OF"), Agency) )
PUC.ITdf  <- subset(ITdf, grepl(glob2rx("PUBLIC UTILITIES COMMISSION"), Agency) )
Insurance.ITdf  <- subset(ITdf, grepl(glob2rx("INSURANCE, DEPARTMENT OF"), Agency) )
Industrial.ITdf <- subset(ITdf, grepl(glob2rx("INDUSTRIAL COMMISSION"), Agency) )
Vocation.ITdf <- subset(ITdf, grepl(glob2rx("VOCATIONAL REHABILITATION, IDAHO DIVISION OF"), Agency) )
Vet.ITdf <- subset(ITdf, grepl(glob2rx("VETERANS SERVICES"), Agency) )

# It is time to combine all of these agencies into a single PhaseI_ITdf
PhaseI.ITdf <- rbind(#TaxITdf, 
                     BuildingSafetyITdf, 
                     FinanceITdf, 
                     PUCITdf, 
                     InsuranceITdf,
                     IndustrialITdf,
                     VocationITdf,
                     VetITdf)

###################### ITS Org Chart ####################
# Make Job Title's consistent in ITS_Org_Chart.csv
ITS.PhaseI$Job.Title <- str_replace(ITS.PhaseI$Job.Title, "Analyst I", "IT Operations and Support Analyst I")
ITS.PhaseI$Job.Title <- str_replace(ITS.PhaseI$Job.Title, "DBA I", "IT Database Administration Analyst I")
ITS.PhaseI$Job.Title <- str_replace(ITS.PhaseI$Job.Title, "Info Security Engineer I", "IT Information Security Engineer I") 
ITS.PhaseI$Job.Title <- str_replace(ITS.PhaseI$Job.Title, "Infrastructure Engineer I", "IT Infrastructure Engineer I")
ITS.PhaseI$Job.Title <- str_replace(ITS.PhaseI$Job.Title, "Senior Tech", "IT Operations and Support Senior Technician")
ITS.PhaseI$Job.Title <- str_replace(ITS.PhaseI$Job.Title, "Software Engineer I", "IT Software Engineer I")
