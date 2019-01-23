# Boxplot breaking out how much each job title makes
# Phase I IT only
# This script assumes the data has been imported (import-data.R) 
# and cleaned up (wrangle-it-data.R)
library('ggplot2')

# And let's just look at Phase I IT
TaxITdf <- subset(ITdf, grepl(glob2rx("TAX COMMISSION, IDAHO STATE"), Agency) )
FinanceITdf <- subset(ITdf, grepl(glob2rx("FINANCE, DEPARTMENT OF"), Agency) )
BuildingSafetyITdf <- subset(ITdf, grepl(glob2rx("BUILDING SAFETY, DIVISION OF"), Agency) )
PUCITdf  <- subset(ITdf, grepl(glob2rx("PUBLIC UTILITIES COMMISSION"), Agency) )
InsuranceITdf  <- subset(ITdf, grepl(glob2rx("INSURANCE FUND, STATE"), Agency) )
IndustrialITdf <- subset(ITdf, grepl(glob2rx("INDUSTRIAL COMMISSION"), Agency) )
VocationITdf <- subset(ITdf, grepl(glob2rx("VOCATIONAL REHABILITATION, IDAHO DIVISION OF"), Agency) )
VetITdf <- subset(ITdf, grepl(glob2rx("VETERANS SERVICES"), Agency) )

# It is time to combine all of these agencies into a single PhaseI_ITdf
PhaseI_ITdf <- rbind(TaxITdf, 
                     BuildingSafetyITdf, 
                     FinanceITdf, 
                     PUCITdf, 
                     InsuranceITdf,
                     IndustrialITdf,
                     VocationITdf,
                     VetITdf)

# Create a plot showing how much money each job title makes
# TODO: Add a title
# TODO: Rename "Classification_"
# TODO: Can we start at $0?
# TODO: Reorder Classification_ in alphabetical order
PhaseI_ITdf %>%
  ggplot(aes(x=reorder(Job.Title, Pay.Rate, mean), y=Pay.Rate, color=Classification_)) +
  geom_boxplot() +
  geom_point() +
  theme(text = element_text(size=10), 
        axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title="Pay of all IT job titles at agencies inPhase I",x="Job Titles", y="Pay") #NOTE:  (Not all job titles displayed will be made redundant in Phase I)

# Looking closer at Insurance
InsuranceITdf %>%
  ggplot(aes(x=reorder(Job.Title, Pay.Rate, mean), y=Pay.Rate)) +
  geom_boxplot() +
  geom_point() +
  theme(text = element_text(size=10), 
        axis.text.x = element_text(angle = 90, hjust = 1))

count(InsuranceITdf, Pay.Rate)