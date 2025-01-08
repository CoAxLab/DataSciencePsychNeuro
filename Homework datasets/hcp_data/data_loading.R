# First clear the workspace
rm(list = ls())

# Look at the files in the directory
datafile = "unrestricted_trimmed_1_7_2020_10_50_44.csv"

# We know right now that the 4th file in the directory is 
# the target. So load that.
hcpdata = read.csv(datafile,header=TRUE, na.strings = "")

