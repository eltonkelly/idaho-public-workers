# Boxplot breaking out how much each job title makes
# State of Idaho all IT Employee's Job Titles
# This script assumes the data has been imported (import-data.R) 
# and cleaned up (wrangle-it-data.R)
library('ggplot2')

# Create a plot showing how much money each job title makes
# This needs to be fixed so it starts at $0
# Also, There are too many job Titles. Many seem unique
ITdf %>%
  ggplot(aes(x=reorder(Job.Title, Pay.Rate, mean), y=Pay.Rate, color=Classification_)) +
  geom_boxplot() +
  geom_point() +
  theme(text = element_text(size=10), 
        axis.text.x = element_text(angle = 90, hjust = 1))

# This probably isn't good for primetime, but I was curious...
# What if we filter out job title's less frequent than...
ITJobTitleCount %>%
  filter(V1 >= 3) %>%
  ggplot(aes(x=reorder(Job.Title, Pay.Rate, mean), y=Pay.Rate, color=Classification_)) +
  geom_boxplot() +
  geom_point() +
  theme(text = element_text(size=10), 
        axis.text.x = element_text(angle = 90, hjust = 1))