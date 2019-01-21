# Import all state employees from https://transparent.idaho.gov
# Also, I created a csv with the classification of each job title using
# the new job classifications.

library('xlsx')

# Assuming the file is copied to this directory...
setwd("C:/Users/elton/OneDrive/Documents/Data Science/DataScience_Idaho_IT")

# If I want to automate copying the file from the download folder...
filename <- "Workforce by Name Summary xls-en-us.xlsx"

# Import xlsx - commented out so I dont accidently run it
employeesdf <- read.xlsx(filename, sheetIndex = 1)

# Import a comma seperated file I manually created with Job Title and Classification
jobclassdf <- read.csv("JobTitle_Classification.csv", header=TRUE)

