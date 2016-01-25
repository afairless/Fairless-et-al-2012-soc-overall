# Andrew Fairless, December 2010
# modified May 2015 for posting onto Github
# This script executes analyses of (co)variance for Fairless et al 2012
# Fairless et al 2012, doi: 10.1016/j.bbr.2011.12.001, PMID:  22178318, PMCID:  PMC3474345

# The fictional data in "altereddata.txt" were modified from the original 
# empirical data used in Fairless et al 2012.
# I am using fictional data instead of the original data because I do not have 
# permission of my co-authors to release the data into the public domain.  
# NOTE:  Because these data are fictional, several important characteristics of
# these data may be different from those of the original data (e.g., interrater
# correlations are probably lower, behaviors may not sum properly)

# Each row is a separate mouse.
# The left-most 3 columns are quasi-independent variables (mouse strain, sex, and age).
# The right-most 5 columns are dependent variables describing behaviors of the
# mice during the Social Approach/Choice Test.

data = read.table("altereddata.txt", header = TRUE)      

# implements the conventional ANCOVA as described in Fairless et al 2012:
# "An ANCOVA modeled mouse strain (C57BL/6J vs. BALB/cJ) and sex (female vs. 
# male) as factors of social cylinder investigation (which consisted 
# predominantly of sniffing of the social cylinder) during Phase 2 of the Social 
# Approach Test and age (at 19, 23, 31, 42, and 70 days) as a continuous 
# covariate of social cylinder investigation during Phase 2."
aovmodelfull = aov(soc.3rd5min ~ strain * age * sex, data = data)

sink(file = "conventionalancova.txt")
aovmodelfull
summary(aovmodelfull)
sink(file = NULL)

# diagnostic plots for the ANCOVA model
png(file = "diagnostics, conventionalancova.png", width = 1280, height = 1024)
layout(matrix(c(1, 2 , 3, 4), 2, 2))
plot(aovmodelfull)
dev.off()

# implements the robust ANOVA as described in Fairless et al 2012:
# "A 20% trimmed means ANOVA, which modeled age as a factor, verified these 
# effects: . . . "
source("Rallfun-v13.txt")
source("t3wayaf.txt")
depvarcol = 8
data2 = data.matrix(cbind(data[ , 1], data[ , 3], data[ , 2], data[ , depvarcol]))

sink(file = "robustanova.txt")
paste("The dependent variable is:  ", colnames(data)[depvarcol])
paste("Factor 1 or A is:  ", colnames(data)[1])
paste("Factor 2 or B is:  ", colnames(data)[3])
paste("Factor 3 or C is:  ", colnames(data)[2])
t3wayaf(2, 5, 2, data2, MAT = T)
sink(file = NULL)
