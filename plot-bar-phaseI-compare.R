# Let's create a geom_bar that contrasts job title's between 
# Phase I AS IS vs. ITS TO BE Org Chart




####################### Practice ##################
head(ITS.PhaseI)
head(PhaseI.ITdf)
ITS.PhaseI$Job.Title

# How many of each Job Title in ITS' proposed Phase I org chart, sorted by count
ITS.Job.Title.Count <- ddply(ITS.PhaseI,.(Job.Title, Classification),nrow)
ITS.Job.Title.Count <- ITS.Job.Title.Count[with(ITS.Job.Title.Count, order(Job.Title)),]
ITS.Job.Title.Count



# How many per Classification
PhaseI.ITdf
PhaseIdf.Job.Title.Count <- ddply(PhaseI.ITdf,.(Job.Title, Classification_),nrow)
PhaseIdf.Job.Title.Count <- PhaseIdf.Job.Title.Count[with(PhaseIdf.Job.Title.Count, order(V1)),]
PhaseIdf.Job.Title.Count


# How many per Agency
PhaseI.ITdf
PhaseIdf.Job.Title.Count <- ddply(PhaseI.ITdf,.(Agency),nrow)
PhaseIdf.Job.Title.Count <- PhaseIdf.Job.Title.Count[with(PhaseIdf.Job.Title.Count, order(V1)),]
PhaseIdf.Job.Title.Count

# Compare Phase I AS IS vs. ITS TO BE Org Chart, sorted by Job.Title
# TODO: I see a discrepency with classification of "IT Operations and Support Analyst II"
PhaseI.Count.Compare <- full_join(PhaseIdf.Job.Title.Count, ITS.Job.Title.Count, by = "Job.Title")
PhaseI.Count.Compare <- PhaseI.Count.Compare[with(PhaseI.Count.Compare, order(Job.Title)),]
colnames(PhaseI.Count.Compare) <- c("Job.Title","","AS.IS","","TO.BE")
PhaseI.Count.Compare

# Create a dataframe with both AS IS and TO BE

  # Start by copying PhaseI.ITdf bc I want to retain all this data
  PhaseI.Compare <- PhaseI.ITdf
  
  # Add new column "TO.BE" with value 0, which means it is AS IS
  PhaseI.Compare$TO.BE <- rep(0,nrow(PhaseI.Compare))
  
  # Add ITS TO BE data
  # First we have to structure it like the existing data frame
  # Add Name, Agency,Appointment.Type, Full.time.Part.time, Pay.Basis, 
  # Pay.Rate, Work.County, and TO.BE columns
  # Then resort into the correct order.
  # Then rename to Classification_
  ITS.PhaseI$Name <- NA
  ITS.PhaseI$Agency <- rep("IT Services",nrow(ITS.PhaseI))
  ITS.PhaseI$Appointment.Type <- NA
  ITS.PhaseI$Full.time.Part.time <- NA
  ITS.PhaseI$Pay.Basis <- NA
  ITS.PhaseI$Pay.Rate <- NA
  ITS.PhaseI$Work.County <- rep("ADA",nrow(ITS.PhaseI))
  ITS.PhaseI$TO.BE <- rep(1,nrow(ITS.PhaseI))
  ITS.PhaseI <- ITS.PhaseI[c("Name",
               "Job.Title",
               "Agency",
               "Appointment.Type",
               "Full.time.Part.time",
               "Pay.Basis",
               "Pay.Rate",
               "Work.County",
               "Classification",
               "TO.BE")]
  colnames(ITS.PhaseI)[9] <- "Classification_"

  
  
  head(PhaseI.Compare)
  head(ITS.PhaseI)

  class(PhaseI.Compare$TO.BE)
  
  # Combine the two data frames
  PhaseI.Compare <- rbind(PhaseI.Compare, ITS.PhaseI)

  # Change TO.BE to Logical
  PhaseI.Compare$TO.BE <- as.logical(PhaseI.Compare$TO.BE)
  
  # Order by Classification
  # This doesn't appear to be doing anything
    PhaseI.Compare <- PhaseI.Compare[with(PhaseI.Compare, order(Classification_)), ]

  
  # Create Plot
  # TODO: Add labels and group by classification (and maybe work county)
  # TODO: Add values of how many
  # TODO: Cleanup 
  # TODO: There is still data cleanup to be done. It isn't accurate.
  PhaseI.Compare %>% 
    ggplot(aes(x=Job.Title, fill=TO.BE)) +
    geom_bar(width=.5, position="dodge") +
    geom_text(y=1.5, label = PhaseI.Compare$Classification_) +
    coord_flip() +
    scale_fill_discrete(labels=c("Current", "Proposed")) +
    ggtitle("Phase I, excluding Tax Commission")
  
  # Create Plot by Classification
  PhaseI.Compare %>% 
    ggplot(aes(x=Classification_, fill=TO.BE)) +
    geom_bar(width=.5, position="dodge") +
    coord_flip()
  
  # Create Plot by Full.time.Part.time
  PhaseI.Compare %>% 
    ggplot(aes(x=TO.BE, fill=TO.BE)) +
    geom_bar(width=.5, position="dodge") +
    coord_flip()
  
  